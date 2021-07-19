import 'package:flutter/services.dart';
import 'package:equatable/equatable.dart';
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:wifi_iot/wifi_iot.dart';

abstract class WifiEvent extends Equatable {
  WifiEvent([List props = const []]);
}

abstract class WifiState extends Equatable {
  WifiState([List props = const []]);
}

// *ssid is already connected, then disconnect
// *or just connect to this ssid
class ChangeWifiState extends WifiEvent {
  final String ssid;
  final String pwd;
  ChangeWifiState({this.ssid, this.pwd});

  @override
  String toString() => 'Change Wifi state $ssid';

  @override
  List<Object> get props => [ssid, pwd];
}

class FetchWifiStatus extends WifiEvent {
  final String ssid;

  FetchWifiStatus({this.ssid});

  @override
  String toString() => 'Fetch wifi info';

  @override
  List<Object> get props => [ssid];
}

class WifiDisconnect extends WifiState {
  @override
  String toString() => 'Wifi disconnect';

  @override
  List<Object> get props => ['Wifi diconnect'];
}

class WifiConnecting extends WifiState {
  @override
  String toString() => 'Wifi connecting';

  @override
  List<Object> get props => ['Wifi connection'];
}

class WifiConnected extends WifiState {
  final String ssid;

  WifiConnected({this.ssid});

  @override
  String toString() => 'Wifi connected $ssid';

  @override
  List<Object> get props => [ssid];
}

class WifiConnectError extends WifiState {
  final String errorMsg;

  WifiConnectError({this.errorMsg});

  @override
  String toString() => 'Wifi connect error $errorMsg';

  @override
  List<Object> get props => [errorMsg];
}

class WifiBloc extends Bloc<WifiEvent, WifiState> {
  @override
  WifiState get initialState => WifiDisconnect();

  @override
  Stream<WifiState> mapEventToState(WifiEvent event) async* {
    if (event is FetchWifiStatus) {
      yield* _mapFetchWifiSsid(event);
    } else if (event is ChangeWifiState) {
      yield* _mapChangeWifiStateToState(event);
    }
  }

  Stream<WifiState> _mapFetchWifiSsid(FetchWifiStatus event) async* {
    try {
      final isConnected = await WiFiForIoTPlugin.isConnected();
      if (isConnected) {
        final ssid = await WiFiForIoTPlugin.getSSID();
        if (ssid == event.ssid) {
          yield WifiConnected(ssid: ssid);
        } else {
          yield WifiDisconnect();
        }
      } else {
        yield WifiDisconnect();
      }
    } on PlatformException {
      yield WifiConnectError(errorMsg: 'Can not get Wi-Fi info');
    }
  }

  Stream<WifiState> _mapChangeWifiStateToState(ChangeWifiState event) async* {
    yield WifiConnecting();
    try {
      if ((state is WifiConnected) &&
          (event.ssid == (state as WifiConnected).ssid)) {
        //*wifi already connected, disconnect ssid is same
        await WiFiForIoTPlugin.disconnect();
        yield WifiDisconnect();
      } else {
        //*wifi not connect, connect to ssid
        final result = await WiFiForIoTPlugin.connect(
          event.ssid,
          password: event.pwd,
          security: NetworkSecurity.WPA,
        );
        if (result) {
          yield WifiConnected(ssid: event.ssid);
        } else {
          yield WifiDisconnect();
        }
      }
    } on PlatformException {
      yield WifiConnectError(errorMsg: 'Connect error.');
    }
  }
}
