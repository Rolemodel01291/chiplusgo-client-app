import 'package:meta/meta.dart';

@immutable
abstract class SettingState {}

class InitialSettingState extends SettingState {}

class AppVersionLoaded extends SettingState {
  final String versionNum;
  final String buildNum;

  AppVersionLoaded({this.versionNum, this.buildNum});
}

