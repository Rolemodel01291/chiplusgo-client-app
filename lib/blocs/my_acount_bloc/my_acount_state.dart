import 'package:infishare_client/models/user.dart';
import 'package:meta/meta.dart';

@immutable
abstract class MyAcountState {}

class NoAcountState extends MyAcountState {
  @override
  String toString() => 'InitialMyAcountState';
}

class MyAccountLoading extends MyAcountState {
  @override
  String toString() => 'MyAccount loading';
}

class MyAccountLoaded extends MyAcountState {
  final User user;

  MyAccountLoaded([this.user]);

  @override
  String toString() => 'Load User: ${user.toJson()}';
}

class MyAccountLoadingPayment extends MyAccountLoaded {
  MyAccountLoadingPayment([User user]) : super(user);

  @override
  String toString() => "My Account Loading payment";
}

class MyAccountPaymentError extends MyAccountLoaded {
  final String errorMsg;

  MyAccountPaymentError(this.errorMsg, [User user]) : super(user);

  @override
  String toString() => 'My account payment load error';
}

class MyAccountLoadError extends MyAcountState {
  final String errorMsg;

  MyAccountLoadError({this.errorMsg});

  @override
  String toString() => 'Load error$errorMsg';
}
