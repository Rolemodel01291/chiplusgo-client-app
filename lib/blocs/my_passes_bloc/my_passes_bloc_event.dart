import 'package:equatable/equatable.dart';
import 'package:infishare_client/models/coupon_ticket.dart';
import 'package:meta/meta.dart';

@immutable
abstract class MyPassesBlocEvent extends Equatable {}

class FetchUserPassesTicket extends MyPassesBlocEvent {
  final String type;
  final bool used;

  FetchUserPassesTicket({this.type, this.used});

  @override
  String toString() => 'Fetch user ticket type:$type, used:$used';

  @override
  List<Object> get props => [type, used];
}

class SelfRedeemTicket extends MyPassesBlocEvent {
  final CouponTicket ticket;

  SelfRedeemTicket({this.ticket});

  @override
  List<Object> get props => [ticket];

  @override
  String toString() => 'Self redeem ticket ${ticket.couponTicketId}';
}

class InternalQRCodeVerified extends MyPassesBlocEvent {
  final CouponTicket ticket;

  InternalQRCodeVerified({this.ticket});

  @override
  List<Object> get props => [ticket];

  @override
  String toString() => 'Internal qrcode verified ${ticket.couponTicketId}';
}

class QRcodeRedeemTicketEvent extends MyPassesBlocEvent {
  final String ticketNum;

  QRcodeRedeemTicketEvent({this.ticketNum});

  @override
  List<Object> get props => [ticketNum];

  @override
  String toString() => 'QRcode redeem $ticketNum';
}
