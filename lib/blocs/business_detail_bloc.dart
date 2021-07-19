import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import '../repo/repo.dart';
import 'dart:async';
import 'package:bloc/bloc.dart';

import '../models/models.dart';

///
/// Business detail state
///

abstract class BusinessDetailState extends Equatable {
  BusinessDetailState();
}

class BusinessDetailLoading extends BusinessDetailState {
  @override
  String toString() => 'Business detail loading';

  @override
  List<Object> get props => ['Business detal loading'];
}

class BusinessDetailLoaded extends BusinessDetailState {
  final List<Business> nearbyBusinesses;
  final List<Coupon> coupons;
  final List<Coupon> vouchers;
  final Business business;

  BusinessDetailLoaded({
    this.business,
    this.nearbyBusinesses,
    this.coupons,
    this.vouchers,
  });

  @override
  String toString() => 'Business coupon and nearby business loaded';

  @override
  List<Object> get props => [nearbyBusinesses, coupons, vouchers];
}

class BusinessDetailError extends BusinessDetailState {
  final String errorMsg;

  BusinessDetailError({this.errorMsg});

  @override
  String toString() => 'Business detail error';

  @override
  List<Object> get props => ['Business detail error'];
}

///
/// Business detail event
///
abstract class BusinessDetailEvent extends Equatable {
  BusinessDetailEvent();
}

class FetchCouponAndNearby extends BusinessDetailEvent {
  final String businessId;

  FetchCouponAndNearby({this.businessId}) : assert(businessId != null);

  @override
  String toString() => 'Fetch coupon and nearby: $businessId';

  @override
  List<Object> get props => [businessId];
}

/// Business detail Bloc
class BusinessDetailBloc
    extends Bloc<BusinessDetailEvent, BusinessDetailState> {
  BusinessRepository businessRepository;
  final Geolocator geolocator = Geolocator();
  BusinessDetailBloc({@required this.businessRepository});

  @override
  BusinessDetailState get initialState => BusinessDetailLoading();

  @override
  Stream<BusinessDetailState> mapEventToState(
      BusinessDetailEvent event) async* {
    if (event is FetchCouponAndNearby) {
      yield* _mapFetchCouponAndNearbyToState(event);
    }
  }

  Stream<BusinessDetailState> _mapFetchCouponAndNearbyToState(
      FetchCouponAndNearby event) async* {
    try {
      final location = await this
          .geolocator
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
      final business =
          await this.businessRepository.getBusinessById(event.businessId);
      final coupons =
          await this.businessRepository.getBusinessCoupon(event.businessId);
      print('coupon fetch complete');
      final nearbys = await this
          .businessRepository
          .getNearbyBusiness(location: business.getLocationFilterString());

      nearbys.removeWhere((business) {
        return business.businessId == event.businessId;
      });

      if (location != null) {
        nearbys.forEach((business) {
          business.calculateDistance(location.latitude, location.longitude);
        });
        business.calculateDistance(location.latitude, location.longitude);
      }

      List<Coupon> couponList = [];
      List<Coupon> voucherList = [];
      coupons.forEach((coupon) {
        couponList.add(coupon);
      });
      // coupons.forEach((coupon) {
      //   if (coupon.couponType == CouponType.COUPON) {
      //     couponList.add(coupon);
      //   } else {
      //     voucherList.add(coupon);
      //   }
      // });
      yield BusinessDetailLoaded(
          business: business,
          coupons: couponList,
          vouchers: voucherList,
          nearbyBusinesses: nearbys);
    } catch (e) {
      print(e);
      yield BusinessDetailError(errorMsg: e.toString());
    }
  }
}
