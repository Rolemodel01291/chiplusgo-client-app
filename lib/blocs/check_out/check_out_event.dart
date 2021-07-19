import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

///
/// Check out event
abstract class CheckOutEvent extends Equatable {
  CheckOutEvent([List props = const []]);
}

class PaymentDataUpdate extends CheckOutEvent {
  @override
  String toString() => 'Payment data update';

  @override
  List<Object> get props => ["Payment data update"];
}

class IncreaseAmount extends CheckOutEvent {
  @override
  String toString() => 'Increase Amount';
  @override
  List<Object> get props => ["Increase Amount"];
}

class DecreaseAmount extends CheckOutEvent {
  @override
  String toString() => 'Decrease amount';
  @override
  List<Object> get props => ["Decrease amount"];
}

class ChangePayment extends CheckOutEvent {
  @override
  String toString() => 'Change payment event';
  @override
  List<Object> get props => ['Change payment event'];
}

class ChangeInfiCash extends CheckOutEvent {
  final double usage;

  ChangeInfiCash({@required this.usage}) : super([usage]);

  @override
  String toString() => 'InfiCashUsageUpdate';

  @override
  List<Object> get props => ["InfiCashUsageUpdate"];
}

class ChangeTips extends CheckOutEvent {
  final double tipsRate;

  ChangeTips({this.tipsRate}) : super([tipsRate]);

  @override
  String toString() => 'Change tips $tipsRate';

  @override
  List<Object> get props => [tipsRate];
}

class InitData extends CheckOutEvent {
  @override
  String toString() => 'Load inital data event';

  @override
  List<Object> get props => ["Load inital data event"];
}

class NotifyPaymentError extends CheckOutEvent {
  final String errorMsg;

  NotifyPaymentError({this.errorMsg});

  @override
  String toString() => 'payment method error: $errorMsg';

  @override
  List<Object> get props => [errorMsg];
}

class CheckOut extends CheckOutEvent {
  @override
  String toString() => 'Check out';

  @override
  List<Object> get props => ["Check out"];
}