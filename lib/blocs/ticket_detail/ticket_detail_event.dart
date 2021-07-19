import 'package:equatable/equatable.dart';

abstract class TicketDetailEvent extends Equatable {
  TicketDetailEvent();
}

class FetchCouponDetail extends TicketDetailEvent {
  final String couponId;

  FetchCouponDetail({this.couponId});

  @override
  String toString() => 'Fetch coupon detail $couponId';

  @override
  List<Object> get props => [couponId];
}
