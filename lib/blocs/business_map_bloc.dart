import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import '../repo/repo.dart';

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../models/models.dart';
import 'package:rxdart/rxdart.dart';

///
/// Business map state
///
abstract class BusinessState extends Equatable {
  BusinessState();
}

class BusinessLoading extends BusinessState {
  @override
  String toString() {
    return 'Business map loading';
  }

  @override
  List<Object> get props => null;
}

class BusinessLoaded extends BusinessState {
  final List<Business> businesses;
  final bool hasReachMax;
  final int categoryIndex;
  final List<bool> label;
  final int sortIndex;
  final int distanceIndex;
  double lati;
  double longti;
  final int radiusIndex;

  BusinessLoaded(
      {this.label,
      this.distanceIndex,
      this.businesses,
      this.hasReachMax,
      this.categoryIndex,
      this.sortIndex,
      this.lati,
      this.longti,
      this.radiusIndex})
      : assert(businesses != null);

  BusinessLoaded copyWith(
      {List<Business> business,
      bool hasReachMax,
      List<String> filters,
      String category,
      String index,
      double lati,
      double longti,
      int radius}) {
    return BusinessLoaded(
      businesses: business ?? this.businesses,
      hasReachMax: hasReachMax ?? this.hasReachMax,
      distanceIndex: distanceIndex ?? this.distanceIndex,
      label: label ?? this.label,
      categoryIndex: categoryIndex ?? this.categoryIndex,
      sortIndex: sortIndex ?? this.sortIndex,
      lati: lati ?? this.lati,
      longti: longti ?? this.longti,
      radiusIndex: radius ?? this.radiusIndex,
    );
  }

  @override
  String toString() {
    return 'Business loaded';
  }

  @override
  List<Object> get props => [
        businesses,
        hasReachMax,
        categoryIndex,
        label,
        sortIndex,
        distanceIndex,
        lati,
        longti,
        radiusIndex,
      ];
}

class BusinessLoadError extends BusinessState {
  final String msg;

  BusinessLoadError({this.msg});

  @override
  String toString() {
    return 'Business map load error $msg';
  }

  @override
  List<Object> get props => [msg];
}

///
/// Business map event
///
abstract class BusinessEvent extends Equatable {}

///
/// *Fetch business event
/// *lati: latitude get from map
/// *longti: longtitude get from map
/// *if lati and longti == 0.0, fetch business from user current location
class FetchBusiness extends BusinessEvent {
  final int categoryIndex;
  final List<bool> label;
  final int sortIndex;
  final int distanceIndex;
  double lati;
  double longti;

  FetchBusiness(
      {this.categoryIndex = -1,
      this.label = const [false, false, false, false],
      this.sortIndex = 0,
      this.distanceIndex = 0,
      this.lati,
      this.longti});

  @override
  String toString() {
    return 'Fetch map business cate $categoryIndex, index $sortIndex, lati${lati ?? 'null'} longti${longti ?? null}';
  }

  @override
  List<Object> get props => [
        categoryIndex,
        sortIndex,
        distanceIndex,
        label,
      ];
}

class FetchMoreBusiness extends BusinessEvent {
  @override
  String toString() {
    return 'Fetch more business';
  }

  @override
  List<Object> get props => ['Fetch'];
}

///
/// Business map bloc
///
class BusinessMapBloc extends Bloc<BusinessEvent, BusinessState> {
  final BusinessRepository businessRepository;
  final Geolocator location;
  final String prefixFilter;

  final List<String> algoliafilterList = [
    "group_buy",
    "voucher",
    "Wifi",
    "Parking"
  ];
  final List<int> distances = [-1, 300, 1000, 2000, 5000];
  final List<String> sortList = [
    // search only have coupons
    AlgoliaConsts.RESTAURANT_COUPON_INDEX,
    // search business base on distance
    AlgoliaConsts.RESTAURANT_DISTANCE,
    // search business base on rating
    AlgoliaConsts.RESTAURANT_RATING_DESC
  ];
  String filters = '';
  String locationString = '';
  final List<String> categorys;

  int page = 0;
  int sortIndex = 0;
  int distanceIndex = 0;
  int cateIndex = -1;
  //* coupon, voucher, wifi, parking
  List<bool> labelFilter = [false, false, false, false];

  BusinessMapBloc({
    this.categorys,
    @required this.businessRepository,
    @required this.location,
    @required this.prefixFilter,
  }) : assert(
          businessRepository != null,
          location != null,
        );

  @override
  BusinessState get initialState => BusinessLoading();

  @override
  Stream<BusinessState> transformEvents(Stream<BusinessEvent> events,
      Stream<BusinessState> Function(BusinessEvent event) next) {
    return super.transformEvents(
      events.debounceTime(
        Duration(milliseconds: 500),
      ),
      next,
    );
  }

  @override
  Stream<BusinessState> mapEventToState(BusinessEvent event) async* {
    if (event is FetchBusiness) {
      yield* _mapFetchBusiness(event);
    } else if (event is FetchMoreBusiness) {
      yield* _mapFetchMoreBusiness(event);
    }
  }

  Stream<BusinessState> _mapFetchBusiness(FetchBusiness event) async* {
    _resetFilterCondition(event);
    try {
      yield BusinessLoading();
      List<Business> retVal = [];
      final locationData = await this
          .location
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
      if (locationData == null) {
        yield BusinessLoadError(msg: 'Location permission required');
      }
      locationString = event.lati == null && event.longti == null
          ? '${locationData.latitude}, ${locationData.longitude}'
          : '${event.lati}, ${event.longti}';
      final businesses = await this.businessRepository.fetchBusiness(
            page: page,
            queryWord: '',
            filters: filters,
            location: locationString,
            radius: distances[distanceIndex],
            index: sortList[sortIndex],
            hitsPerPage: 15,
          );
      businesses.forEach((business) {
        business.calculateDistance(
            locationData.latitude, locationData.longitude);
      });
      retVal.addAll(businesses);
      yield BusinessLoaded(
        businesses: retVal,
        hasReachMax: businesses.length < 15,
        label: labelFilter,
        categoryIndex: cateIndex,
        sortIndex: sortIndex,
        radiusIndex: distanceIndex,
        lati: event.lati ?? locationData.latitude,
        longti: event.longti ?? locationData.longitude,
      );
    } on PlatformException catch (e) {
      yield BusinessLoadError(msg: e.code);
    } on Exception catch (e) {
      yield BusinessLoadError(msg: e.toString());
    }
  }

  ///
  ///* clear all filters and change to new condition pass in by event
  ///
  void _resetFilterCondition(FetchBusiness event) {
    page = 0;
    sortIndex = event.sortIndex;
    cateIndex = event.categoryIndex;
    distanceIndex = event.distanceIndex;
    labelFilter.clear();
    labelFilter.addAll(event.label);
    List<String> filterList = ['Type:$prefixFilter'];
    if (cateIndex != -1) {
      filterList.add(
          AlgoliaConsts.CATEGORY_FILTER_PREFIX + "'${categorys[cateIndex]}'");
    }

    for (int i = 0; i < labelFilter.length; i++) {
      if (labelFilter[i]) {
        final tmp =
            AlgoliaConsts.LABEL_FILTER_PREFIX + algoliafilterList[i] + '=1';
        filterList.add(tmp);
      }
    }

    filters = filterList.join(AlgoliaConsts.AND_OPERATOR);
    print(filters);
  }

  Stream<BusinessState> _mapFetchMoreBusiness(FetchMoreBusiness event) async* {
    if (!_hasReachMax(state)) {
      try {
        page = page + 1;
        final locationData = await this
            .location
            .getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
        final businesses = await this.businessRepository.fetchBusiness(
              page: page,
              queryWord: '',
              filters: filters,
              location: locationString,
              radius: distances[distanceIndex],
              index: sortList[sortIndex],
              hitsPerPage: 15,
            );
        businesses.forEach((business) {
          business.calculateDistance(
              locationData.latitude, locationData.longitude);
        });
        yield BusinessLoaded(
            businesses: (state as BusinessLoaded).businesses + businesses,
            label: labelFilter,
            categoryIndex: cateIndex,
            sortIndex: sortIndex,
            hasReachMax: businesses.length < 15,
            radiusIndex: distanceIndex);
      } on Exception catch (e) {
        if (e is PlatformException) {
          yield BusinessLoadError(msg: e.code);
        } else {
          yield BusinessLoadError(msg: e.toString());
        }
      }
    }
  }

  bool _hasReachMax(BusinessState state) {
    return state is BusinessLoaded && state.hasReachMax;
  }
}
