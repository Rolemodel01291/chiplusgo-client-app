import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class TabBloc extends Bloc<TabEvent, TabState> {
  @override
  TabState get initialState => HomeTab();

  @override
  Stream<TabState> mapEventToState(
    TabEvent event,
  ) async* {
    if (event is UpdateTabEvent) {
      yield* _mapUpdateTabEventToState(event);
    }
  }

  Stream<TabState> _mapUpdateTabEventToState(UpdateTabEvent event) async* {
    switch (event.appTab) {
      case AppTab.Home:
        yield HomeTab();
        break;
      case AppTab.Wallet:
        yield WalletTab();
        break;
      case AppTab.Orders:
        yield OrderTab();
        break;
      case AppTab.Me:
        yield MeTab();
        break;

      default:
        yield HomeTab();
        break;
    }
  }
}
