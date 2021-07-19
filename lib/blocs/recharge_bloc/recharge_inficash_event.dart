import 'package:infishare_client/models/models.dart';
import 'package:meta/meta.dart';

@immutable
abstract class RechargeInficashEvent {}

class FetchRechargeOptions extends RechargeInficashEvent {}

class ChangeRechargeOptions extends RechargeInficashEvent {
  final int index;
  ChangeRechargeOptions({this.index});

  @override
  String toString() => 'Change to charge option index: $index';
}

class ConfirmChargeInficash extends RechargeInficashEvent {}

class CustomizeInficash extends RechargeInficashEvent {
  final double usage;

  CustomizeInficash({this.usage});

  @override
  String toString() => 'Change customize usage';
}

class PaymentMethodUpdate extends RechargeInficashEvent {
  final ChargeOption chargeOptions;
  final int selectedIndex;
  final String paymentInfo;
  final double balance;

  PaymentMethodUpdate({
    this.chargeOptions,
    this.selectedIndex,
    this.paymentInfo,
    this.balance,
  });

  @override
  String toString() => 'Payment Data Update $paymentInfo';
}

class ShowChangePayment extends RechargeInficashEvent {
  @override
  String toString() => 'Show change payment';
}

class PaymentMethodError extends RechargeInficashEvent {
  final String errorMsg;

  PaymentMethodError({
    this.errorMsg,
  });

  @override
  String toString() => 'Payment Data error $errorMsg';
}
