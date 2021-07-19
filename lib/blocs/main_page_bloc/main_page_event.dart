import 'package:meta/meta.dart';

@immutable
abstract class MainPageEvent {}


class FetchMainData extends MainPageEvent {

}

//* Connect to Wifi that business distance is less than 20 m
class ConnectWifi extends MainPageEvent {

}