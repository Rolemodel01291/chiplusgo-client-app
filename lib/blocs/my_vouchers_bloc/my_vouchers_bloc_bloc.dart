import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:infishare_client/models/models.dart';
import 'package:infishare_client/repo/coupon_repo.dart';
import 'package:rxdart/rxdart.dart';
import './bloc.dart';

class MyVouchersBlocBloc
    extends Bloc<MyVouchersBlocEvent, MyVouchersBlocState> {
  final CouponRepository couponRepository;
  DocumentSnapshot _lastdoc;
  StreamSubscription _couponSub;

  MyVouchersBlocBloc({this.couponRepository});

  @override
  MyVouchersBlocState get initialState => TicketUninit();

  @override
  Stream<MyVouchersBlocState> transformEvents(
    Stream<MyVouchersBlocEvent> events,
    Stream<MyVouchersBlocState> Function(MyVouchersBlocEvent event) next,
  ) {
    return super.transformEvents(
      events.debounceTime(
        Duration(milliseconds: 500),
      ),
      next,
    );
  }

  @override
  Stream<MyVouchersBlocState> mapEventToState(
    MyVouchersBlocEvent event,
  ) async* {
    if (event is FetchUserVouchersTicket) {
      yield* _mapFetchUserVouchersToState(event);
    } else if (event is SelfRedeemTicket) {
      yield* _mapSelfRedeemTicketToState(event);
    } else if (event is QRcodeRedeemTicketEvent) {
      yield* _mapQRcodeRedeemTicketEventToState(event);
    } else if (event is InternalQRCodeVerified) {
      yield TicketVerified(ticket: event.ticket);
    }
  }

  Stream<MyVouchersBlocState> _mapSelfRedeemTicketToState(
      SelfRedeemTicket event) async* {
    try {
      yield TicketVerifing();
      await couponRepository.selfRedeemUserTicket(event.ticket.couponTicketId);
      //yield TicketVerified(ticket: event.ticket);
      return;
    } catch (_) {
      yield TicketVerifiedError(errorMsg: 'Redeem failed');
    }
  }

  Stream<MyVouchersBlocState> _mapQRcodeRedeemTicketEventToState(
      QRcodeRedeemTicketEvent event) async* {
    try {
      _couponSub?.cancel();
      final couponStream = await couponRepository.getRealTimeCoupon();
      _couponSub = couponStream.listen((snapShot) {
        snapShot.documentChanges.forEach((change) {
          if (change.type == DocumentChangeType.modified) {
            final ticket = CouponTicket.fromJson(change.document.data);
            if (ticket.couponTicketId == event.ticketNum) {
              add(InternalQRCodeVerified(ticket: ticket));
              _couponSub?.cancel();
              return;
            }
          }
        });
      });
    } catch (_) {
      yield TicketVerifiedError(errorMsg: 'Can not get order info');
    }
  }

  Stream<MyVouchersBlocState> _mapFetchUserVouchersToState(
      FetchUserVouchersTicket event) async* {
    //* three conditions
    //* 1. currentState is uninit then load first ten ticket
    //* 2. currentState is loaded then load next ten (check has reach max in here)
    //* 3. currentState is ticket verified then load first ten
    try {
      if (state is TicketUninit ||
          state is TicketVerified ||
          state is TicketLoadError) {
        //* ticket init

        yield TicketLoadding();

        _lastdoc = null;
        final docs = await couponRepository.fetchUserCouponTicket(
            lastdoc: _lastdoc, used: event.used, type: event.type);

        if (docs.isEmpty) {
          yield TicketLoaded(tickets: [], hasMore: false);
          return;
        }
        _lastdoc = docs.last;
        final tickets = docs.map((doc) {
          return CouponTicket.fromJson(doc.data);
        }).toList();

        yield TicketLoaded(
          // tickets: tickets,
          tickets: [],
          hasMore: !(tickets.length < 10),
        );
        return;
      }

      if (_hasReachMax(state)) {
        final docs = await couponRepository.fetchUserCouponTicket(
            lastdoc: _lastdoc, type: event.type, used: event.used);
        final tickets = docs.map((doc) {
          return CouponTicket.fromJson(doc.data);
        }).toList();
        if (tickets.length == 10) {
          _lastdoc = docs.last;
        }
        print(((state as TicketLoaded).tickets + tickets).length);
        yield tickets.length < 10
            ? TicketLoaded(
                tickets: (state as TicketLoaded).tickets + tickets,
                hasMore: false)
            : TicketLoaded(
                tickets: (state as TicketLoaded).tickets + tickets,
                hasMore: true);
        return;
      }
    } catch (e) {
      print(e.toString());
      yield TicketLoadError(errorMsg: 'Error loading orders');
    }
  }

  bool _hasReachMax(MyVouchersBlocState state) {
    return state is TicketLoaded && state.hasMore;
  }

  @override
  Future<void> close() async {
    _couponSub?.cancel();
    super.close();
  }
}
