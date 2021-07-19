import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class StripeChannel {
  MethodChannel _channel = const MethodChannel('com.infishare/stripe_payment');
  EventChannel _eventChannel =
      const EventChannel('com.infishare/stripe_payment_method');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map<String, String>> showChoosePaymentView() async {
    FirebaseUser _user = await _auth.currentUser();
    if (_user != null) {
      IdTokenResult _token = await _user.getIdToken();
      return await _channel
          .invokeMapMethod('showChoosePayment', {'token': _token.token});
    } else {
      throw new Exception('No user signed in!');
    }
  }

  Future<Map<String, String>> editPayment() async {
    FirebaseUser _user = await _auth.currentUser();
    if (_user != null) {
      IdTokenResult _token = await _user.getIdToken();
      return await _channel
          .invokeMapMethod('editPayment', {'token': _token.token});
    } else {
      throw new Exception('No user signed in!');
    }
  }

  Future<Stream<dynamic>> startReceivePaymentMethod() async {
    FirebaseUser _user = await _auth.currentUser();
    if (_user != null) {
      IdTokenResult _token = await _user.getIdToken();
      return _eventChannel.receiveBroadcastStream({'token': _token.token});
    } else {
      throw new Exception('No user signed in!');
    }
  }

  Future<Map<String, String>> createPayment(
      {@required List<String> businessId,
      @required String couponId,
      @required int amount,
      @required int count,
      @required int reward,
      @required double tips,
      @required double tax,
      @required double balance}) async {
    FirebaseUser _user = await _auth.currentUser();
    if (_user != null) {
      IdTokenResult _token = await _user.getIdToken();
      return await _channel.invokeMapMethod("createPaymentToken", <String, dynamic>{
        'token': _token.token,
        'businessId': businessId,
        'couponId': couponId,
        'amount': amount,
        'count': count,
        'tips': tips,
        'tax': tax,
        'reward': reward,
        'balance': balance,
      });
    } else {
      throw new Exception('No user signed in!');
    }
  }

  Future<Map<String, String>> chargeInfiCash({@required int amount}) async {
    FirebaseUser _user = await _auth.currentUser();
    if (_user != null) {
      IdTokenResult _token = await _user.getIdToken();
      return await _channel.invokeMapMethod("chargeInfiCash", {
        'token': _token.token,
        'amount': amount,
      });
    } else {
      throw new Exception('No user signed in!');
    }
  }
}
