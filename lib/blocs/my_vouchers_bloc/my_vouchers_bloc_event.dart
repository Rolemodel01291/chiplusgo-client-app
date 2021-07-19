import 'package:equatable/equatable.dart';
import 'package:infishare_client/models/coupon_ticket.dart';
import 'package:meta/meta.dart';

@immutable
abstract class MyVouchersBlocEvent extends Equatable {}

class FetchUserVouchersTicket extends MyVouchersBlocEvent {
  final String type;
  final bool used;

  FetchUserVouchersTicket({this.type, this.used});

  @override
  String toString() => 'Fetch user ticket type:$type, used:$used';

  @override
  List<Object> get props => [type, used];
}

class SelfRedeemTicket extends MyVouchersBlocEvent {
  final CouponTicket ticket;

  SelfRedeemTicket({this.ticket});

  @override
  List<Object> get props => [ticket];

  @override
  String toString() => 'Self redeem ticket ${ticket.couponTicketId}';
}

class InternalQRCodeVerified extends MyVouchersBlocEvent {
  final CouponTicket ticket;

  InternalQRCodeVerified({this.ticket});

  @override
  List<Object> get props => [ticket];

  @override
  String toString() => 'Internal qrcode verified ${ticket.couponTicketId}';
}

class QRcodeRedeemTicketEvent extends MyVouchersBlocEvent {
  final String ticketNum;

  QRcodeRedeemTicketEvent({this.ticketNum});

  @override
  List<Object> get props => [ticketNum];

  @override
  String toString() => 'QRcode redeem $ticketNum';
}
