import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:infishare_client/channel/stripe_channel.dart';
import 'package:infishare_client/repo/payment_repo.dart';
import './bloc.dart';

class RechargeInficashBloc
    extends Bloc<RechargeInficashEvent, RechargeInficashState> {
  StreamSubscription _paymentSubscription;
  final PaymentRepository paymentRepository;
  StripeChannel _stripeChannel = StripeChannel();

  RechargeInficashBloc({this.paymentRepository});

  @override
  RechargeInficashState get initialState => RechargeOptionLoading();

  @override
  Stream<RechargeInficashState> mapEventToState(
    RechargeInficashEvent event,
  ) async* {
    if (event is FetchRechargeOptions) {
      yield* _mapFetchRechargeOptions(event);
    } else if (event is ChangeRechargeOptions) {
      yield* _mapChangeRechargeOptions(event);
    } else if (event is ConfirmChargeInficash) {
      yield* _mapConfirmChargeInfiCash(event);
    } else if (event is PaymentMethodUpdate) {
      yield RechargeOptionLoaded(
        event.chargeOptions,
        event.selectedIndex,
        event.paymentInfo,
        event.balance,
        (state is RechargeOptionLoading)
            ? 0.0
            : (state as RechargeOptionLoaded).customAmount,
      );
    } else if (event is PaymentMethodError) {
      yield RechargeOptionLoadError(errorMsg: event.errorMsg);
    } else if (event is ShowChangePayment) {
      _stripeChannel.showChoosePaymentView();
    } else if (event is CustomizeInficash) {
      yield* _mapCustomizeInficashToState(event);
    }
  }

  Stream<RechargeInficashState> _mapCustomizeInficashToState(
      CustomizeInficash event) async* {
    final preState = (state as RechargeOptionLoaded);

    yield RechargeOptionLoaded(
      preState.chargeOptions,
      5,
      preState.paymentInfo,
      preState.balance,
      event.usage,
    );
  }

  Stream<RechargeInficashState> _mapFetchRechargeOptions(
      FetchRechargeOptions event) async* {
    yield RechargeOptionLoading();
    _paymentSubscription?.cancel();
    try {
      var user = await paymentRepository.fetchUser();
      double balance = user.balance;
      var chargeOption = await paymentRepository.getChargeOptions();
      var paymentStream = await _stripeChannel.startReceivePaymentMethod();
      _paymentSubscription = paymentStream.listen((data) {
        var map = data as Map;
        if (map['method'] != null) {
          add(
            PaymentMethodUpdate(
              selectedIndex: (state is RechargeOptionLoading)
                  ? 0
                  : (state as RechargeOptionLoaded).selectedIndex,
              chargeOptions: chargeOption,
              balance: balance,
              paymentInfo: map['method'],
            ),
          );
        } else {
          add(
            PaymentMethodError(errorMsg: map['error']),
          );
        }
      });
    } on Exception catch (e) {
      yield RechargeOptionLoadError(errorMsg: e.toString());
    }
  }

  Stream<RechargeInficashState> _mapChangeRechargeOptions(
      ChangeRechargeOptions event) async* {
    final preState = (state as RechargeOptionLoaded);

    if (event.index == 5) {
      yield ShowCustomInficash(
        preState.chargeOptions,
        preState.selectedIndex,
        preState.paymentInfo,
        preState.balance,
        preState.customAmount,
      );
    } else {
      yield RechargeOptionLoaded(
        preState.chargeOptions,
        event.index,
        preState.paymentInfo,
        preState.balance,
        0.0,
      );
    }
  }

  Stream<RechargeInficashState> _mapConfirmChargeInfiCash(
      ConfirmChargeInficash event) async* {
    final preState = (state as RechargeOptionLoaded);
    double damount = preState.selectedIndex == 5
        ? preState.customAmount * 100
        : preState.chargeOptions.options[preState.selectedIndex].baseAmount *
            100;
    int amount = int.parse(damount.toStringAsFixed(0));
    print(amount);
    yield PaymentProcessing(
      preState.chargeOptions,
      preState.selectedIndex,
      preState.paymentInfo,
      preState.balance,
      preState.customAmount,
    );
    try {
      var response = await _stripeChannel.chargeInfiCash(amount: amount);
      if (response['error'] != null) {
        yield PaymentError(
          response['error'],
          preState.chargeOptions,
          preState.selectedIndex,
          preState.paymentInfo,
          preState.balance,
          preState.customAmount,
        );
      } else if (response['Cancel'] != null) {
        add(FetchRechargeOptions());
      } else {
        paymentRepository.chargeWallet(
          chargeAmount: amount/100
        );

        yield PaymentSuccess(
          preState.chargeOptions,
          preState.selectedIndex,
          preState.paymentInfo,
          preState.balance,
          preState.customAmount,
        );
      }
    } catch (e) {
      yield PaymentError(
        e.toString(),
        preState.chargeOptions,
        preState.selectedIndex,
        preState.paymentInfo,
        preState.balance,
        preState.customAmount,
      );
    }
  }

  @override
  Future<void> close() async {
    _paymentSubscription?.cancel();
    super.close();
  }
}
