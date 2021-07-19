import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthEvent extends Equatable {}

//* App start event
class AppStart extends AuthEvent {
  @override
  List<Object> get props => ['App start'];
}

//* User enter phone number and tap button
class SendCodeEvent extends AuthEvent {
  final String phoneNum;

  SendCodeEvent({this.phoneNum});

  @override
  String toString() => 'Phone number: $phoneNum';

  @override
  List<Object> get props => null;
}

class AuthGoogleEvent extends AuthEvent {
  @override
  String toString() => 'Google Authenticated';

  @override
  List<Object> get props => ['Facebook Authenticated'];
}

class AuthFacebookEvent extends AuthEvent {

  final Function onSuccess;

  AuthFacebookEvent({ this.onSuccess});

  @override
  String toString() => 'Facebook Authenticated';

  @override
  List<Object> get props => ['Facebook Authenticated'];
}

class AuthInternalSucEvent extends AuthEvent {
  @override
  String toString() => 'Internal Authticated';

  @override
  List<Object> get props => ['Internal Authticated'];
}

//* this event is used to dispath error from callback in firebase auth sdk
class AuthInternalErrorEvent extends AuthEvent {
  final String errorMsg;

  AuthInternalErrorEvent({this.errorMsg});

  @override
  List<Object> get props => [errorMsg];
}

class AuthInternalPhoneVerified extends AuthEvent {
  final String verficationId;

  AuthInternalPhoneVerified({this.verficationId});

  @override
  List<Object> get props => [verficationId];
}

class SignOut extends AuthEvent {
  @override
  String toString() => 'Sign out';

  @override
  List<Object> get props => ['Sign out'];
}

//* User enter sms code sent to their phone and tap button
class VerifySmscode extends AuthEvent {
  final String smsCode;

  VerifySmscode({this.smsCode});

  @override
  String toString() => 'sms code: $smsCode';

  @override
  List<Object> get props => [this.smsCode];
}

class InternalSmsCodeVerified extends AuthEvent {
  @override
  List<Object> get props => null;
}

class InternalGmailVerified extends AuthEvent {
  final String email;

  InternalGmailVerified({this.email});
  @override
  String toString() => 'gmail: $email';
  @override
  List<Object> get props => [this.email];
}

class InternalFacebookVerified extends AuthEvent {
  final String email;

  InternalFacebookVerified({this.email});
  @override
  String toString() => 'facebook: $email';
  @override
  List<Object> get props => [this.email];
}

//* Sign up user with email, create user in Stripe
class SignUpNewUser extends AuthEvent {
  final String name;
  final String email;

  SignUpNewUser({this.name, this.email});

  @override
  String toString() => '===> $name, $email';

  @override
  List<Object> get props => [name, email];
}

class SignUpNewUserFromGoogle extends AuthEvent {
  final String name;
  final String phone;
  final String email;

  SignUpNewUserFromGoogle({this.name, this.phone, this.email});

  @override
  String toString() => '===> $name, $phone';

  @override
  List<Object> get props => [name, phone];
}
