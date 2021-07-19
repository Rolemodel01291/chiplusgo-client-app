import 'package:meta/meta.dart';

@immutable
abstract class QrCodeBlocEvent {}

class SelfRedeemEvent extends QrCodeBlocEvent {
  @override
  String toString() => 'self redeem event';
}

class InternalRedeemSuccessEvent extends QrCodeBlocEvent {

  @override
  String toString() => 'Internal redeem success event';
}

class WaitRedeemEvent extends QrCodeBlocEvent {
  @override
  String toString() => 'Waiting QR code to be redeemed';
}

class ChangeRedeemMethod extends QrCodeBlocEvent {
  @override
  String toString() => 'Change redeem method';
}
