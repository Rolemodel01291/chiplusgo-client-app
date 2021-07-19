import 'package:infishare_client/models/models.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SingleCouponDetailState {}

class SingleCouponLoading extends SingleCouponDetailState {
  @override
  String toString() => 'Single coupon loading';
}

class SingleCouponLoaded extends SingleCouponDetailState {
  final Coupon coupon;
  final Business business;

  SingleCouponLoaded({this.coupon, this.business});

  @override
  String toString() => 'Single coupon loaded';
}

class SingleCouponLoadError extends SingleCouponDetailState {
  final String errorMsg;

  SingleCouponLoadError({this.errorMsg});

  @override
  String toString() => 'Single coupon loaded error: $errorMsg';
}
