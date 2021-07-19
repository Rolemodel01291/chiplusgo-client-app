import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:infishare_client/repo/business_repo.dart';
import './bloc.dart';

class SingleCouponDetailBloc
    extends Bloc<SingleCouponDetailEvent, SingleCouponDetailState> {
  final BusinessRepository repository;
  final String couponId;
  final String businessId;

  SingleCouponDetailBloc({
    this.repository,
    this.couponId,
    this.businessId,
  });

  @override
  SingleCouponDetailState get initialState => SingleCouponLoading();

  @override
  Stream<SingleCouponDetailState> mapEventToState(
    SingleCouponDetailEvent event,
  ) async* {
    if (event is FetchCouponAndBusiness) {
      yield* _mapFetchCouponAndBusiness(event);
    }
  }

  Stream<SingleCouponDetailState> _mapFetchCouponAndBusiness(
      FetchCouponAndBusiness event) async* {
    try {
      
      final business = await repository.getBusinessById(
        businessId,
      );
      
      final coupon = await repository.getCouponById(
        couponId,
        businessId,
      );
      
      //* check if coupon is false because user might enter here by link

      if (!coupon.isActivce) {
        yield SingleCouponLoadError(errorMsg: 'Coupon has expired');
      } else {
        yield SingleCouponLoaded(
          business: business,
          coupon: coupon,
        );
      }
    } catch (e) {
      print(e.toString());
      yield SingleCouponLoadError(errorMsg: 'Coupon not found');
    }
  }
}
