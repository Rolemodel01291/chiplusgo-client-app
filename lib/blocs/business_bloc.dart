import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import '../repo/repo.dart';
import 'dart:async';
import 'package:bloc/bloc.dart';

import '../models/models.dart';

///
/// Business state
///
///
abstract class BusinessState extends Equatable {
  BusinessState([List props = const []]);
}

class BusinessEmpty extends BusinessState {
  @override
  String toString() => 'Empty business';

  @override
  List<Object> get props => ['Empty business'];
}

class BusinessLoading extends BusinessState {
  @override
  String toString() => 'Business loading';

  @override
  List<Object> get props => ['Loading'];
}

class BusinessLoaded extends BusinessState {
  final List<Business> businesses;

  BusinessLoaded({@required this.businesses})
      : assert(businesses != null);

  @override
  String toString() => 'Business loaded ${businesses.length}';

  @override
  List<Object> get props => [businesses];
}

class BusinessError extends BusinessState {
  @override
  String toString() => 'Business loaded error';

  @override
  List<Object> get props => ['Loaded error'];
}

///
/// Business event
///
abstract class BusinessEvent extends Equatable {
  BusinessEvent([List props = const []]);
}

class FetchBusiness extends BusinessEvent {
  final int page;
  final int radius;
  final int hitsPerPage;
  final String queryWord;
  final String filters;
  final String location;
  final String index;

  FetchBusiness(
      {this.page = 0,
      this.radius = 3000,
      this.hitsPerPage = 20,
      this.queryWord = '',
      this.filters = '',
      this.location = '',
      this.index = AlgoliaConsts.RESTAURANT_COUPON_INDEX});

  @override
  String toString() => 'FetchBusiness';

  @override
  List<Object> get props => [page, radius, hitsPerPage, queryWord, filters, location, index];
}

class SearchBusiness extends BusinessEvent {
  final String queryWord;

  SearchBusiness({this.queryWord});

  @override
  String toString() => 'Search business: $queryWord';

  @override
  List<Object> get props => [queryWord];
}

///
/// Business Bloc
///
class BusinessBloc extends Bloc<BusinessEvent, BusinessState> {
  final BusinessRepository businessRepository;

  BusinessBloc({@required this.businessRepository});

  @override
  BusinessState get initialState => BusinessLoading();

  @override
  Stream<BusinessState> mapEventToState(BusinessEvent event) async* {
    if (event is FetchBusiness) {
      yield* _mapFetchBusinessToState(event);
    } else if (event is SearchBusiness) {
      yield* _mapSearchBusinessToState(event);
    }
  }

  Stream<BusinessState> _mapSearchBusinessToState(SearchBusiness event) async* {
    try {
      final businesses = await this
          .businessRepository
          .fetchBusiness(queryWord: event.queryWord);
      if (businesses.length == 0) {
        yield BusinessEmpty();
      } else {
        yield BusinessLoaded(businesses: businesses);
      }
    } catch (_) {
      yield BusinessError();
    }
  }

  Stream<BusinessState> _mapFetchBusinessToState(FetchBusiness event) async* {
    try {
      final businesses = await this.businessRepository.fetchBusiness(
          page: event.page,
          queryWord: event.queryWord,
          filters: event.filters,
          location: event.location,
          radius: event.radius,
          index: event.index,
          hitsPerPage: event.hitsPerPage);
      if (businesses.length == 0) {
        yield BusinessEmpty();
      } else {
        yield BusinessLoaded(businesses: businesses);
      }
    } catch (_) {
      yield BusinessError();
    }
  }
}
