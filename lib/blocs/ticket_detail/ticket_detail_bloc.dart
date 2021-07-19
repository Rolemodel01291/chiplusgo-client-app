import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:infishare_client/models/coupon_ticket.dart';
import 'package:infishare_client/models/models.dart';
import 'package:infishare_client/repo/repo.dart';
import './bloc.dart';

class TicketDetailBloc extends Bloc<TicketDetailEvent, TicketDetailState> {
  final CouponRepository couponRepository;

  TicketDetailBloc({this.couponRepository});

  @override
  TicketDetailState get initialState => TicketDetailLoading();

  @override
  Stream<TicketDetailState> mapEventToState(
    TicketDetailEvent event,
  ) async* {
    if (event is FetchCouponDetail) {
      yield* _mapFetchCouponDetailToState(event);
    }
  }

  Stream<TicketDetailState> _mapFetchCouponDetailToState(
    FetchCouponDetail event,
  ) async* {
    try {
      final CouponTicket ticket =
          await couponRepository.getTicketWithId(event.couponId);
      final Business business =
          await couponRepository.getBusinessByRef(ticket.businessRef[0]);
      yield TicketDetailLoaded(business: business, ticket: ticket);
    } catch (e) {
      yield TicketDetailLoadError(
          errorMsg: 'Combo info loaded error' + e.toString());
    }
  }
}