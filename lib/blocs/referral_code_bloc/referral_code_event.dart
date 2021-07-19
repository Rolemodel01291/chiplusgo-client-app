import 'package:meta/meta.dart';

@immutable
abstract class ReferralCodeEvent {}


class CheckReferralCode extends ReferralCodeEvent {
  final String referralCode;

  CheckReferralCode({this.referralCode});
}