import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

enum AppTab {
  Home,
  Wallet,
  Orders,
  Me,
}

@immutable
abstract class TabEvent extends Equatable {}

class UpdateTabEvent extends TabEvent {
  final AppTab appTab;

  UpdateTabEvent({this.appTab});

  @override
  List<Object> get props => [appTab];
}
