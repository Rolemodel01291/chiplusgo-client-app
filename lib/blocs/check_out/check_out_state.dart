import 'package:equatable/equatable.dart';

///
/// Check out state
///
abstract class CheckOutState extends Equatable {}

class PaymentDataLoading extends CheckOutState {
  @override
  String toString() => 'Loading payment info';

  @override
  List<Object> get props => ['Payment loading'];
}

class PaymentDataCacheState extends CheckOutState {
  final double subTotal;
  final double tips;
  final double tax;
  final double infiCash;
  final double totalAmount;
  final String paymentMethod;
  final int amount;
  final double balance;

  PaymentDataCacheState(
      [this.subTotal,
      this.tips,
      this.tax,
      this.infiCash,
      this.totalAmount,
      this.paymentMethod,
      this.amount,
      this.balance]);

  @override
  List<Object> get props => [
        subTotal,
        tips,
        tax,
        infiCash,
        totalAmount,
        paymentMethod,
        amount,
        balance
      ];

  @override
  String toString() => 'Payment data cache loaded';
}

class PaymentDataError extends CheckOutState {
  final String errorMsg;

  PaymentDataError({this.errorMsg});

  @override
  String toString() => 'Load payment info error $errorMsg';

  @override
  List<Object> get props => [errorMsg];
}

class CheckOutProcessing extends PaymentDataCacheState {
  CheckOutProcessing([
    double subTotal,
    double tips,
    double tax,
    double infiCash,
    double totalAmount,
    String paymentMethod,
    int amount,
    double balance,
  ]) : super(subTotal, tips, tax, infiCash, totalAmount, paymentMethod, amount,
            balance);

  @override
  String toString() => 'Check out processing';

  @override
  List<Object> get props => super.props;
}

class CheckOutError extends PaymentDataCacheState {
  final String errorMsg;

  CheckOutError(
    this.errorMsg, [
    double subTotal,
    double tips,
    double tax,
    double infiCash,
    double totalAmount,
    String paymentMethod,
    int amount,
    double balance,
  ]) : super(subTotal, tips, tax, infiCash, totalAmount, paymentMethod, amount,
            balance);

  @override
  String toString() => 'Check out error $errorMsg';

  @override
  List<Object> get props => [errorMsg, super.props];
}

class CheckOutSuccess extends PaymentDataCacheState {
  final String receiptNum;

  CheckOutSuccess(
    this.receiptNum, [
    double subTotal,
    double tips,
    double tax,
    double infiCash,
    double totalAmount,
    String paymentMethod,
    int amount,
    double balance,
  ]) : super(subTotal, tips, tax, infiCash, totalAmount, paymentMethod, amount,
            balance);

  @override
  String toString() => 'Checkout success $receiptNum';

  @override
  List<Object> get props => [receiptNum, super.props];
}

class CheckOutCancel extends PaymentDataCacheState {
  CheckOutCancel([
    double subTotal,
    double tips,
    double tax,
    double infiCash,
    double totalAmount,
    String paymentMethod,
    int amount,
    double balance,
  ]) : super(subTotal, tips, tax, infiCash, totalAmount, paymentMethod, amount,
            balance);

  @override
  String toString() => "User cancel";

  @override
  List<Object> get props => super.props;
}
