import 'package:infishare_client/models/models.dart';
import 'package:meta/meta.dart';

@immutable
abstract class MyAcountEvent {}

class FetchUserData extends MyAcountEvent {
  @override
  String toString() => 'Fetch user data';
}

class InternalNoUser extends MyAcountEvent {
  @override
  String toString() => 'InternalNoUser';
}

class InternalUserUpdate extends MyAcountEvent {
  final User user;

  InternalUserUpdate({this.user});

  @override
  String toString() => 'user balance: ${user.balance}';
}

class ShowPayment extends MyAcountEvent {
  @override
  String toString() => 'Show payment';
}
