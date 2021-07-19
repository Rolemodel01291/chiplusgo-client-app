import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:package_info/package_info.dart';
import './bloc.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  @override
  SettingState get initialState => InitialSettingState();

  @override
  Stream<SettingState> mapEventToState(
    SettingEvent event,
  ) async* {
    if (event is FetchAppVersion) {
      yield* _mapFetchAppVersion(event);
    }
  }

  Stream<SettingState> _mapFetchAppVersion(FetchAppVersion event) async* {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final versionNum = packageInfo.version;
      final buildNum = packageInfo.buildNumber;
      yield AppVersionLoaded(versionNum: versionNum, buildNum: buildNum);
    } catch (e) {
      yield AppVersionLoaded(versionNum: '', buildNum: '');
    }
  }
}
