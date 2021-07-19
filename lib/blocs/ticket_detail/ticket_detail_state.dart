import 'package:infishare_client/models/coupon_ticket.dart';
import 'package:infishare_client/models/models.dart';

abstract class TicketDetailState {
  TicketDetailState();
}

class TicketDetailLoading extends TicketDetailState {
  @override
  String toString() => 'TicketDetailLoading';
}

class TicketDetailLoaded extends TicketDetailState {
  final CouponTicket ticket;
  final Business business;
  final bool updated;

  TicketDetailLoaded({this.ticket, this.business, this.updated});

  @override
  String toString() => "";
  // String toString() => ticket.detail.toJson().toString();

}

class TicketDetailLoadError extends TicketDetailState {
  final String errorMsg;

  TicketDetailLoadError({this.errorMsg});

  @override
  String toString() => 'detail loaded error $errorMsg';
}

class TicketDetailUpdated extends TicketDetailState {
  final CouponTicket ticket;

  TicketDetailUpdated({this.ticket});

  @override
  String toString() => 'Ticket Detail updated';
}
