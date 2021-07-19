import 'package:meta/meta.dart';

@immutable
abstract class ReferralCodeState {}
  
class InitialReferralCodeState extends ReferralCodeState {}


class CodeChecked extends ReferralCodeState {}

class CodeChecking extends ReferralCodeState {}

class CodeCheckError extends ReferralCodeState {
  final String errorMsg;

  CodeCheckError({this.errorMsg});
}