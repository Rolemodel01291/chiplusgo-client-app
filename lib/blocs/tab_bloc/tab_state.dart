import 'package:meta/meta.dart';

@immutable
abstract class TabState {}
  
class HomeTab extends TabState {}

class WalletTab extends TabState{}

class OrderTab extends TabState {}

class MeTab extends TabState {}

