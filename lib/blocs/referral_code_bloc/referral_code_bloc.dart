import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:infishare_client/repo/infishare_api.dart';
import './bloc.dart';

class ReferralCodeBloc extends Bloc<ReferralCodeEvent, ReferralCodeState> {

  final InfiShareApiClient client;

  ReferralCodeBloc({this.client});

  @override
  ReferralCodeState get initialState => InitialReferralCodeState();

  @override
  Stream<ReferralCodeState> mapEventToState(
    ReferralCodeEvent event,
  ) async* {
    if (event is CheckReferralCode) {
      yield CodeChecking();
      try {
        await client.enterReferalCode(event.referralCode);
        yield CodeChecked();
      } catch(e) {
        yield CodeCheckError(errorMsg: e.toString());
      }
    }
  }
}
