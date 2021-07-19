import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:infishare_client/models/coupon_ticket.dart';
import 'package:infishare_client/repo/repo.dart';
import './bloc.dart';

class QrCodeBlocBloc extends Bloc<QrCodeBlocEvent, QrCodeBlocState> {
  final CouponTicket couponTicket;
  final CouponRepository couponRepository;
  StreamSubscription<QuerySnapshot> _streamSubscription;

  QrCodeBlocBloc({this.couponRepository, this.couponTicket});

  @override
  QrCodeBlocState get initialState =>
      QRCodeState(couponTicket, RedeemMethod.Qrcode);

  @override
  Stream<QrCodeBlocState> mapEventToState(
    QrCodeBlocEvent event,
  ) async* {
    if (event is SelfRedeemEvent) {
      yield* _mapSelfRedeemEventToState(event);
    } else if (event is WaitRedeemEvent) {
      yield* _mapWaitRedeemEventToState(event);
    } else if (event is ChangeRedeemMethod) {
      yield* _mapChangeRedeemMethod(event);
    } else if (event is InternalRedeemSuccessEvent) {
      yield QRCodeRedeemSuccess(
          couponTicket, (state as QRCodeState).redeemMethod);
    }
  }

  Stream<QrCodeBlocState> _mapSelfRedeemEventToState(
    SelfRedeemEvent event
  ) async* {
    try {
      yield QRCodeRedeemLoading(
          (state as QRCodeState).ticket, (state as QRCodeState).redeemMethod);
      // await couponRepository.selfRedeemUserTicket(couponTicket.ticketNum);
      await couponRepository.selfRedeemUserTicket(couponTicket.couponTicketId);
    } catch (e) {
      
      yield QRCodeRedeemFailed(e.toString(), (state as QRCodeState).ticket,
          (state as QRCodeState).redeemMethod);
    }
  }

  Stream<QrCodeBlocState> _mapWaitRedeemEventToState(
    WaitRedeemEvent event,
  ) async* {
    try {
      _streamSubscription?.cancel();
      final coupons = await couponRepository.getRealTimeCoupon();
      _streamSubscription = coupons.listen((snapshot) {
        snapshot.documentChanges.forEach((docuemntChange) {
          // if (docuemntChange.document.documentID == couponTicket.ticketNum) {
          if (docuemntChange.document.documentID ==
              couponTicket.couponTicketId) {
            final ticket = CouponTicket.fromJson(docuemntChange.document.data);
            if (ticket.used) {
              add(InternalRedeemSuccessEvent());
            }
          }
        });
      });
    } catch (e) {
      yield QRCodeRedeemFailed(e.toString(), (state as QRCodeState).ticket,
          (state as QRCodeState).redeemMethod);
    }
  }

  Stream<QrCodeBlocState> _mapChangeRedeemMethod(
    ChangeRedeemMethod event,
  ) async* {
    if ((state as QRCodeState).redeemMethod == RedeemMethod.Qrcode) {
      yield QRCodeState(couponTicket, RedeemMethod.Merchant);
    } else {
      yield QRCodeState(couponTicket, RedeemMethod.Qrcode);
    }
  }

  @override
  Future<void> close() async {
    _streamSubscription?.cancel();
    super.close();
  }
}
