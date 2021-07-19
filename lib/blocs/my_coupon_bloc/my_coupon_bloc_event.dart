import 'package:equatable/equatable.dart';
import 'package:infishare_client/models/coupon_ticket.dart';
import 'package:meta/meta.dart';

@immutable
abstract class MyCouponBlocEvent extends Equatable {}

class FetchUserCouponTicket extends MyCouponBlocEvent {
  final String type;
  final bool used;

  FetchUserCouponTicket({this.type, this.used});

  @override
  String toString() => 'Fetch user ticket type:$type, used:$used';

  @override
  List<Object> get props => [type, used];
}

class SelfRedeemTicket extends MyCouponBlocEvent {
  final CouponTicket ticket;

  SelfRedeemTicket({this.ticket});

  @override
  List<Object> get props => [ticket];

  @override
  String toString() => 'Self redeem ticket ${ticket.couponTicketId}';
}

class InternalQRCodeVerified extends MyCouponBlocEvent {
  final CouponTicket ticket;

  InternalQRCodeVerified({this.ticket});

  @override
  List<Object> get props => [ticket];

  @override
  String toString() => 'Internal qrcode verified ${ticket.couponTicketId}';
}

class QRcodeRedeemTicketEvent extends MyCouponBlocEvent {
  final String ticketNum;

  QRcodeRedeemTicketEvent({this.ticketNum});

  @override
  List<Object> get props => [ticketNum];

  @override
  String toString() => 'QRcode redeem $ticketNum';
}
