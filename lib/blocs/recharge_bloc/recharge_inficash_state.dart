import 'package:infishare_client/models/charge_option.dart';
import 'package:meta/meta.dart';

@immutable
abstract class RechargeInficashState {}

class RechargeOptionLoading extends RechargeInficashState {}

class RechargeOptionLoaded extends RechargeInficashState {
  final ChargeOption chargeOptions;
  final int selectedIndex;
  final String paymentInfo;
  final double balance;
  final double customAmount;

  RechargeOptionLoaded([
    this.chargeOptions,
    this.selectedIndex,
    this.paymentInfo,
    this.balance,
    this.customAmount,
  ]);

  @override
  String toString() => 'selectIndex $selectedIndex, customAmount $customAmount';
}

class ShowCustomInficash extends RechargeOptionLoaded {
  ShowCustomInficash([
    ChargeOption chargeOption,
    int selectedIndex,
    String paymentInfo,
    double balance,
    double customAmount,
  ]) : super(
          chargeOption,
          selectedIndex,
          paymentInfo,
          balance,
          customAmount,
        );

  @override
  String toString() => 'Show custom inficash';
}

class RechargeOptionLoadError extends RechargeInficashState {
  final String errorMsg;

  RechargeOptionLoadError({this.errorMsg});
}

class PaymentProcessing extends RechargeOptionLoaded {
  PaymentProcessing([
    ChargeOption chargeOption,
    int selectedIndex,
    String paymentInfo,
    double balance,
    double customAmount,
  ]) : super(
          chargeOption,
          selectedIndex,
          paymentInfo,
          balance,
          customAmount,
        );

  @override
  String toString() => 'Payment processing';
}

class PaymentSuccess extends RechargeOptionLoaded {
  PaymentSuccess([
    ChargeOption chargeOption,
    int selectedIndex,
    String paymentInfo,
    double balance,
    double customAmount,
  ]) : super(
          chargeOption,
          selectedIndex,
          paymentInfo,
          balance,
          customAmount,
        );

  @override
  String toString() => 'Payment success';
}

class PaymentError extends RechargeOptionLoaded {
  final String errorMsg;

  PaymentError(
    this.errorMsg, [
    ChargeOption chargeOption,
    int selectedIndex,
    String paymentInfo,
    double balance,
    double customAmount,
  ]) : super(
          chargeOption,
          selectedIndex,
          paymentInfo,
          balance,
          customAmount,
        );

  @override
  String toString() => 'Payment error: $errorMsg';
}
