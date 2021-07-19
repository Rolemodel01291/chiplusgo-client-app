import 'package:meta/meta.dart';

@immutable
abstract class SplashState {}

class InitialSplashState extends SplashState {}

class VersionChecked extends SplashState {
  final bool notNew;

  VersionChecked({this.notNew});
}

class NeedUpdateState extends SplashState {}

class VersionCheckError extends SplashState {
  final String errorMsg;

  VersionCheckError({this.errorMsg});
}
