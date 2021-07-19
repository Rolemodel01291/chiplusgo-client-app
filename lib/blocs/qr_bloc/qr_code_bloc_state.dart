import 'package:infishare_client/models/coupon_ticket.dart';
import 'package:meta/meta.dart';

enum RedeemMethod { Merchant, Qrcode }

@immutable
abstract class QrCodeBlocState {}

class QRCodeState extends QrCodeBlocState {
  final CouponTicket ticket;
  final RedeemMethod redeemMethod;
  QRCodeState([this.ticket, this.redeemMethod]);

  @override
  String toString() => 'QRcode state redeem method: $redeemMethod';
}

class QRCodeRedeemLoading extends QRCodeState {
  QRCodeRedeemLoading([CouponTicket ticket, RedeemMethod redeemMeth])
      : super(ticket, redeemMeth);

  @override
  String toString() => 'QRcode state redeem loading: $redeemMethod';
}

class QRCodeRedeemSuccess extends QRCodeState {
  QRCodeRedeemSuccess([CouponTicket ticket, RedeemMethod redeemMeth])
      : super(ticket, redeemMeth);

  @override
  String toString() => 'QRcode state redeem success: $redeemMethod';
}

class QRCodeRedeemFailed extends QRCodeState {
  final String errorMsg;

  QRCodeRedeemFailed(this.errorMsg,
      [CouponTicket ticket, RedeemMethod redeemMeth])
      : super(ticket, redeemMeth);

  @override
  String toString() => 'QRcode state redeem error: $errorMsg';
}
