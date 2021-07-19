import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthState extends Equatable {}

class Uninitialized extends AuthState {
  @override
  String toString() => 'Uninitialized';

  @override
  List<Object> get props => ['Uninitialized'];
}

//* User successfully logined in
class Autheticated extends AuthState {
  @override
  String toString() => 'Authticated';

  @override
  List<Object> get props => ['Authticated'];
}

class UnAutheticated extends AuthState {
  @override
  String toString() => 'Unauth';

  @override
  List<Object> get props => null;
}

class AuthLoading extends AuthState {
  @override
  String toString() => 'Loading';

  @override
  List<Object> get props => ['Loading'];
}

//* User has already verify phone number and sms is sent to user phone
class PhoneVerified extends AuthState {
  final String verificationId;

  PhoneVerified({this.verificationId});

  @override
  String toString() => 'VerificationId $verificationId';

  @override
  List<Object> get props => [verificationId];
}

//* User verify sms code sent to their phone
class SmsCodeVerified extends AuthState {
  @override
  List<Object> get props => ['Sms code verified'];
}

class GmailVerified extends AuthState {
  final String email;
  GmailVerified({this.email});

  @override
  String toString() => "Gmail $email";
  @override
  List<Object> get props => ['Gmail verified'];
}

class FacebookVerified extends AuthState {
  final String email;
  FacebookVerified({this.email});

  @override
  String toString() => "Facebook $email";
  @override
  List<Object> get props => ['Facebook verified'];
}

//* Some error in auth process
class AuthError extends AuthState {
  final String errorMsg;

  AuthError({this.errorMsg});

  @override
  String toString() => 'Auth error :$errorMsg';

  @override
  List<Object> get props => [errorMsg];
}
