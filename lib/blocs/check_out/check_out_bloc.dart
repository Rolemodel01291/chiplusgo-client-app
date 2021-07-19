import 'dart:math';

import 'package:infishare_client/channel/stripe_channel.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:infishare_client/models/models.dart';
import 'package:infishare_client/repo/repo.dart';
import 'check_out_event.dart';
import 'check_out_state.dart';

///
/// check out bloc
///
class CheckOutBloc extends Bloc<CheckOutEvent, CheckOutState> {
  final Coupon coupon;
  StreamSubscription _paymentSubscription;
  final PaymentRepository paymentRepository;
  StripeChannel _stripeChannel = StripeChannel();

  double tipsRate = 0.0;
  double taxRate = 0.0;

  int count = 1;

  double tips = 0.0;
  double tax = 0.0;
  double infiCash = 0.0;
  double subTotal = 0.0;
  double totalAmount = 0.0;
  var f = NumberFormat("#,###,##0.00", "en_US");
  double balance = 0.0;

  String paymentMethod = "";

  CheckOutBloc({@required this.paymentRepository, @required this.coupon}) {
    // tipsRate = coupon.tips / 100;
    taxRate = coupon.tax;
  }

  @override
  CheckOutState get initialState => PaymentDataLoading();

  @override
  Stream<CheckOutState> mapEventToState(CheckOutEvent event) async* {
    if (event is IncreaseAmount || event is DecreaseAmount) {
      yield* _mapChangAmountEventToState(event);
    } else if (event is InitData) {
      yield* _mapInitDataToState(event);
    } else if (event is ChangeInfiCash) {
      yield* _mapInficashUsageUpdateToState(event);
    } else if (event is ChangeTips) {
      yield* _mapChangeTipsToState(event);
    } else if (event is ChangePayment) {
      yield* _mapShowPaymentEventToState(event);
    } else if (event is PaymentDataUpdate) {
      yield* _mapPaymentDataUpdateToState(event);
    } else if (event is CheckOut) {
      yield* _mapCheckOutToState(event);
    } else if (event is NotifyPaymentError) {
      yield PaymentDataError(errorMsg: event.errorMsg);
    }
  }

  Stream<CheckOutState> _mapChangAmountEventToState(
      CheckOutEvent event) async* {
    if (event is IncreaseAmount) {
      if (count < 9) {
        count += 1;
      }
    } else {
      if (count >= 2) {
        count -= 1;
      }
    }
    _calculatePaymentData();
    yield PaymentDataCacheState(
      subTotal,
      tips,
      tax,
      infiCash,
      totalAmount,
      paymentMethod,
      count,
      balance,
    );
  }

  Stream<CheckOutState> _mapChangeTipsToState(ChangeTips event) async* {
    tipsRate = event.tipsRate / 100;
    _calculatePaymentData();
    yield PaymentDataCacheState(
      subTotal,
      tips,
      tax,
      infiCash,
      totalAmount,
      paymentMethod,
      count,
      balance,
    );
  }

  Stream<CheckOutState> _mapInitDataToState(InitData event) async* {
    _paymentSubscription?.cancel();
    try {
      var user = await paymentRepository.fetchUser();
      balance = user.balance;
      var paymentStream = await _stripeChannel.startReceivePaymentMethod();
      _paymentSubscription = paymentStream.listen((data) {
        var map = data as Map;
        if (map['method'] != null) {
          paymentMethod = map['method'];
          add(PaymentDataUpdate());
        } else {
          add(NotifyPaymentError(errorMsg: map['error']));
        }
      });
    } on Exception catch (e) {
      print(e);
      yield PaymentDataError(errorMsg: e.toString());
    }
  }

  Stream<CheckOutState> _mapInficashUsageUpdateToState(
      ChangeInfiCash event) async* {
    _calculatePaymentData(infi: event.usage);
    yield PaymentDataCacheState(
      subTotal,
      tips,
      tax,
      infiCash,
      totalAmount,
      paymentMethod,
      count,
      balance,
    );
  }

  Stream<CheckOutState> _mapPaymentDataUpdateToState(
      PaymentDataUpdate event) async* {
    _calculatePaymentData();
    yield PaymentDataCacheState(
      subTotal,
      tips,
      tax,
      infiCash,
      totalAmount,
      paymentMethod,
      count,
      balance,
    );
  }

  Stream<CheckOutState> _mapShowPaymentEventToState(
      ChangePayment event) async* {
    _stripeChannel.showChoosePaymentView();
  }

  Stream<CheckOutState> _mapCheckOutToState(CheckOut event) async* {
    yield CheckOutProcessing(
      subTotal,
      tips,
      tax,
      infiCash,
      totalAmount,
      paymentMethod,
      count,
      balance,
    );
    try {
      final response = await paymentRepository.chargeCustomer(
          businessId: coupon.businessId,
          couponId: coupon.couponId,
          amount: (totalAmount * 100.0).toInt(),
          reward: 0,
          tips: tips,
          tax: tax,
          balance: infiCash,
          count: count);
      if (response['receipt'] != null) {
        yield CheckOutSuccess(
          response['receipt'],
          subTotal,
          tips,
          tax,
          infiCash,
          totalAmount,
          paymentMethod,
          count,
          balance,
        );
      } else if (response['error'] != null) {
        yield CheckOutError(
          response['error'],
          subTotal,
          tips,
          tax,
          infiCash,
          totalAmount,
          paymentMethod,
          count,
          balance,
        );
      } else if (response['Cancel'] != null) {
        yield CheckOutCancel(
          subTotal,
          tips,
          tax,
          infiCash,
          totalAmount,
          paymentMethod,
          count,
          balance,
        );
      }
    } catch (e) {
      print(e);
      yield CheckOutError(
        e.toString(),
        subTotal,
        tips,
        tax,
        infiCash,
        totalAmount,
        paymentMethod,
        count,
        balance,
      );
    }
  }

  ///
  /// infi == -1 represent user dose not change inficash amount
  ///
  void _calculatePaymentData({double infi = -1.0}) {
    subTotal = double.parse(f.format(count * coupon.price));
    tips = double.parse(f.format(coupon.price * tipsRate * count));
    tax = double.parse(f.format(coupon.price * taxRate * count));

    infiCash = infi == -1.0
        ? double.parse(f.format(min(subTotal + tax + tips, balance)))
        : double.parse(f.format(infi));
    totalAmount = double.parse(f.format(
        double.parse((subTotal + tax + tips).toStringAsFixed(2)) - infiCash));
  }

  @override
  Future<void> close() async {
    _paymentSubscription?.cancel();
    super.close();
  }
}
