import 'package:equatable/equatable.dart';
import 'package:infishare_client/models/models.dart';

abstract class CouponDetailState extends Equatable {}

abstract class CouponDetailEvent extends Equatable {}

class FetchRecommendCoupon extends CouponDetailState {
  @override
  String toString() => 'Fetch recommend coupons';

  @override
  List<Object> get props => ['Fetch recommend coupons'];
}

class RecommendCouponLoaded extends CouponDetailState {
  final List<CouponThumbnail> couponThumbnails;

  RecommendCouponLoaded({this.couponThumbnails});

  @override
  List<Object> get props => [couponThumbnails];
}


