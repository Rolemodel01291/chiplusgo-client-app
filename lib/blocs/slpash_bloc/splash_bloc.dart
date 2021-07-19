import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:infishare_client/repo/infishare_api.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './bloc.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final InfiShareApiClient client;

  SplashBloc({this.client});

  @override
  SplashState get initialState => InitialSplashState();

  @override
  Stream<SplashState> mapEventToState(
    SplashEvent event,
  ) async* {
    if (event is CheckAppVersion) {
      try {
        final newVersion = await client.getAppVersion();
        await client.getFCM().requestNotificationPermissions();
        // client.getFCM().configure(
        //   onMessage: (Map<String, dynamic> message) async {
        //     print("onMessage: ${message['data']}");
        //   },
        //   onLaunch: (Map<String, dynamic> message) async {
        //     print("onLaunch: $message");
        //   },
        //   onResume: (Map<String, dynamic> message) async {
        //     print("onResume: $message");
        //   },
        // );
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        String versionName = packageInfo.version;
        String versionCode = packageInfo.buildNumber;
        final versions = versionName.split('.').map((v) {
          return int.parse(v);
        }).toList();
        int versionBuild = int.parse(versionCode);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (newVersion.minimal.versionCode
                .checkVersion(versions[0], versions[1], versionBuild) >
            0) {
          //* need update
          yield NeedUpdateState();
        } else {
          //* to home screen or onboarding page
          final isFirstTime = prefs.getBool('firstTime') ?? false;
          prefs.setBool('firstTime', true);
          yield VersionChecked(notNew: isFirstTime);
        }
      } catch (e) {
        yield VersionCheckError(
          errorMsg: e.toString(),
        );
      }
    }
  }
}
