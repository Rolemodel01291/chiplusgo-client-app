import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:infishare_client/models/transaction_history.dart';
import 'package:infishare_client/repo/infishare_api.dart';
import '../channel/stripe_channel.dart';
import '../models/models.dart';
import 'package:http/http.dart' as http;

class PaymentRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final StripeChannel _channel = StripeChannel();
  final InfiShareApiClient _infiShareApiClient;

  PaymentRepository({InfiShareApiClient infiShareApiClient})
      : _infiShareApiClient = infiShareApiClient ??
            InfiShareApiClient(
              httpClient: http.Client(),
            );

  Future<User> fetchUser() async {
    final user = await _auth.currentUser();
    if (user == null) throw Exception('No user signed in');
    final userData =
        await Firestore.instance.collection('Client').document(user.uid).get();

    if (userData == null) throw Exception('Can not find user infomation');
    return User.fromJson(userData.data);
  }

  Future<User> fetchUserById(String uid) async {
    final userData =
        await Firestore.instance.collection('Client').document(uid).get();
    if (!userData.exists) {
      return null;
    } else {
      return User.fromJson(userData.data);
    }
  }

  Future<ChargeOption> getChargeOptions() async {
    return await _infiShareApiClient.getChargeOptions();
  }

  Future<Stream<dynamic>> startReceivePaymentMethod() async {
    return await _channel.startReceivePaymentMethod();
  }

  Future<void> showChoosePaymentView() async {
    await _channel.showChoosePaymentView();
  }

  Future<Map<String, String>> chargeCustomer(
      {@required List<String> businessId,
      @required String couponId,
      @required int amount,
      @required int count,
      @required int reward,
      @required double tips,
      @required double tax,
      @required double balance}) async {
    return await _channel.createPayment(
        businessId: businessId,
        count: count,
        couponId: couponId,
        amount: amount,
        reward: reward,
        tips: tips,
        tax: tax,
        balance: balance);
  }

  Future<List<ChargeHistory>> getChargeHistory(
      {int limit, String startId}) async {
    return await _infiShareApiClient.getChargeHistory(
        limit: limit, startId: startId);
  }

  Future<List<TransactionHistory>> getTransactionHistory() async {
    return await _infiShareApiClient.getTransactionHistory();
  }

  Future<void> chargeWallet({double chargeAmount}) async {
    return await _infiShareApiClient.chargeWallet(chargeAmount: chargeAmount);
  }

  Future<String> payToBusiness(
      {double amount,
      double finalCashBalance,
      double finalPointsBalance,
      double finalCreditlineBalance,
      Business business,
      Coupon coupon,
      String subAccountId,
      String note}) async {
    return await _infiShareApiClient.payToBusiness(
        amount: amount,
        business: business,
        subAccountId: subAccountId,
        finalCashBalance: finalCashBalance,
        finalPointsBalance: finalPointsBalance,
        finalCreditlineBalance: finalCreditlineBalance,
        note: note,
        coupon:coupon,
        type: "Pay",
        orderId: "");
  }

  Future<String> purchaseCoupon(
      {double amount,
      double finalCashBalance,
      double finalPointsBalance,
      double finalCreditlineBalance,
      Business business,
      Coupon coupon}) async {
    return await _infiShareApiClient.purchaseCoupon(
      amount: amount,
      business: business,
      finalCashBalance: finalCashBalance,
      finalPointsBalance: finalPointsBalance,
      finalCreditlineBalance: finalCreditlineBalance,
      coupon: coupon,
    );
  }
}
