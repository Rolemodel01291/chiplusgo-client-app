import 'package:equatable/equatable.dart';
import 'package:infishare_client/models/models.dart';
import 'package:meta/meta.dart';

@immutable
abstract class MyCouponBlocState extends Equatable {}

class TicketUninit extends MyCouponBlocState {
  @override
  List<Object> get props => null;
}

class TicketLoaded extends MyCouponBlocState {
  final List<CouponTicket> tickets;
  final bool hasMore;

  TicketLoaded({this.tickets, this.hasMore});

  TicketLoaded copyWith({List<CouponTicket> tickets, bool hasMore}) {
    return TicketLoaded(
        tickets: tickets ?? this.tickets, hasMore: hasMore ?? this.hasMore);
  }

  @override
  String toString() => 'Ticket loaded ${tickets.length} hasMore $hasMore';

  @override
  List<Object> get props => [tickets, hasMore];
}

class TicketLoadding extends MyCouponBlocState {
  @override
  List<Object> get props => null;
}

class TicketLoadError extends MyCouponBlocState {
  final String errorMsg;

  TicketLoadError({this.errorMsg});

  @override
  String toString() => errorMsg;

  @override
  List<Object> get props => [errorMsg];
}

class TicketVerified extends MyCouponBlocState {
  final CouponTicket ticket;

  TicketVerified({this.ticket});

  @override
  String toString() => 'Coupont verified ${ticket.couponTicketId}';

  @override
  List<Object> get props => null;
}

class TicketVerifing extends MyCouponBlocState {
  @override
  List<Object> get props => null;
}

class TicketVerifiedError extends MyCouponBlocState {
  final String errorMsg;

  TicketVerifiedError({this.errorMsg});

  @override
  String toString() => 'Ticket verified error $errorMsg';

  @override
  List<Object> get props => [errorMsg];
}
