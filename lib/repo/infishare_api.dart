import 'dart:async';
import 'dart:convert' show json;
import 'dart:developer';
// ignore: avoid_web_libraries_in_flutter
// import 'dart:html';
import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:infishare_client/models/models.dart';
import 'package:algolia/algolia.dart';
import 'package:infishare_client/models/search_suggestions.dart';
import 'package:infishare_client/models/transaction_history.dart';
import 'package:infishare_client/repo/infishare_api_error.dart';
import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import './utils/algolia_consts.dart';

class InfiShareApiClient {
  static const String BASE_URL =
      "https://us-central1-chiplusgo-95ec4.cloudfunctions.net/";

  static const String STRIPE_CREATE_CUSTOMER_URL = "createCust/";
  static const String GET_CHARGE_HISTORY_URL = "retrieveCharges/";
  static const String TICKET_VERIFY_URL = "ticketVerify/";

  static const String ALGOLIA_API_KEY = "e04593357e3a2638cae2e948bfd2cdcc";
  static const String ALGOLIA_APPID = "BQA21EY37X";
  // static const String ALGOLIA_API_KEY = "d90ab2260321539c5f4c845046d71017";
  // static const String ALGOLIA_APPID = "CG29ACKSAU";

  final http.Client httpClient;
  final FirebaseAuth _firebaseAuth;
  final Firestore _firestore;
  final Algolia _algolia;
  final FirebaseStorage _firebaseStorage;
  final FirebaseMessaging _firebaseMessaging;
  final FirebaseAnalytics _analytics;
  final Locale _locale;

  InfiShareApiClient(
      {@required this.httpClient,
      FirebaseAuth firebaseAuth,
      Firestore firestore,
      Algolia algolia,
      FirebaseMessaging firebaseMessaging,
      FirebaseStorage firebaseStorage,
      Locale locale,
      FirebaseAnalytics analytics})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? Firestore.instance,
        _algolia = algolia ??
            Algolia.init(applicationId: ALGOLIA_APPID, apiKey: ALGOLIA_API_KEY),
        _firebaseMessaging = firebaseMessaging ?? FirebaseMessaging(),
        _firebaseStorage = firebaseStorage ?? FirebaseStorage(),
        _locale = locale ?? Locale('en', 'US'),
        _analytics = analytics ?? FirebaseAnalytics();

  /// check App version with firebase
  Future<AppVersion> getAppVersion() async {
    final versionResponse = await _firestore
        .collection('App_version')
        .orderBy('Update_time', descending: true)
        .getDocuments();
    await _analytics.logAppOpen();
    if (versionResponse.documents.length == 0) {
      throw Exception('No app version found');
    }

    final lastestVersion =
        AppVersion.fromJson(versionResponse.documents[0].data);
    return lastestVersion;
  }

  FirebaseMessaging getFCM() => _firebaseMessaging;

  /// verify phone number and send sms code to user's phone
  Future<void> verifyPhoneNum(
      {@required String phoneNum,
      PhoneVerificationCompleted verificationCompleted,
      PhoneVerificationFailed verificationFailed,
      PhoneCodeSent codeSent,
      PhoneCodeAutoRetrievalTimeout timeout}) async {
    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNum,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: timeout);
  }

  /// use sms code to sign in user
  Future<AuthResult> signInWithPhoneNum(
      {String smsCode, String verifyCode}) async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verifyCode, smsCode: smsCode);
    try {
      final authResult = await _firebaseAuth.signInWithCredential(credential);
      await _analytics.logLogin(loginMethod: 'Phone');
      return authResult;
    } on PlatformException catch (e) {
      if (e.message.contains('invalid')) {
        throw Exception('Invalid verification code');
      } else if (e.message.contains('expired')) {
        throw Exception('The verification code has expired');
      } else {
        throw Exception('Verify error: ${e.message}');
      }
    }
  }

  Future<AuthResult> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    GoogleSignInAccount googleSignInAccount;
    if (googleSignInAccount == null) {
      // Start the sign-in process:
      googleSignInAccount = await googleSignIn.signIn();
    }
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    try {
      final AuthResult authResult =
          await _firebaseAuth.signInWithCredential(credential);
      await _analytics.logLogin(loginMethod: 'Google');
      return authResult;
    } on PlatformException catch (e) {
      throw Exception('Error');
    }
  }

  /// create customer in stripe
  Future<void> createCustomer() async {
    final user = await _firebaseAuth.currentUser();
    final token = await user.getIdToken();

    final Map<String, String> headers = new Map();
    headers['Authorization'] = 'Bearer ${token.token}';
    headers['content-type'] = 'application/json';
    final url = BASE_URL + STRIPE_CREATE_CUSTOMER_URL;
    final response = await httpClient.post(url, headers: headers);
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to create customer');
    }
  }

  Future<void> enterReferalCode(String code) async {
    final user = await _firebaseAuth.currentUser();
    final token = await user.getIdToken();
    if (user == null) {
      throw Exception("No user login");
    }

    final url =
        'https://us-central1-chiplusgo-95ec4.cloudfunctions.net/referCodeVerify/';
    final Map<String, String> headers = new Map();
    headers['Authorization'] = 'Bearer ${token.token}';
    headers['content-type'] = 'application/json';
    final body = {"Code": code};
    final response =
        await httpClient.post(url, headers: headers, body: json.encode(body));
    await _analytics.logEarnVirtualCurrency(
      virtualCurrencyName: 'InfiCash',
      value: 5,
    );
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to check invite code. Please try again later.');
    }
  }

  /// user sign out
  Future<void> signOut() async {
    final user = await _firebaseAuth.currentUser();
    if (user == null) {
      return;
    }
    final token = await _firebaseMessaging.getToken();
    await getClientReference(user.uid).updateData({
      'Device_token': FieldValue.arrayRemove([
        {
          'Token': token,
          'Type': Platform.isAndroid ? 'Android' : 'iPhone',
        }
      ]),
      'Point': 1,
    });
    return await _firebaseAuth.signOut();
  }

  /// upload user FAQ
  Future<void> uploadHelpRequest(
      {String name, String email, String phone, String content}) async {
    return await _firestore.collection('Emails').add({
      'Name': name,
      'Email': email,
      'Phone': phone,
      'Text': content,
    });
  }

  /// upload user device's firebase message id token to firebase
  Future<void> uploadCloudMsgToken() async {
    final user = await _firebaseAuth.currentUser();
    if (user == null) {
      throw Exception('No user login');
    }
    final token = await _firebaseMessaging.getToken();
    return await getClientReference(user.uid).updateData({
      'Device_token': FieldValue.arrayUnion([
        {
          'Token': token,
          "Type": Platform.isAndroid ? 'Android' : 'iPhone',
        }
      ])
    });
  }

  /// change user show name
  Future<void> changeShowName(String name) async {
    final user = await _firebaseAuth.currentUser();
    if (user == null) {
      throw Exception('No user login');
    }
    return await getClientReference(user.uid).updateData({"Name": name});
  }

  /// change user email
  Future<void> changeUserInfo(
      {String name,
      String email,
      String phoneNum,
      String addressLine1,
      String addressLine2,
      String city}) async {
    final user = await _firebaseAuth.currentUser();
    if (user == null) {
      throw Exception('No user login');
    }
    return await getClientReference(user.uid).updateData({
      "Name": name,
      "Email": email,
      "Phone": phoneNum,
      "AddressLine1": addressLine1,
      "AddressLine2": addressLine2,
      "City": city
    });
  }

  Future<void> updateUserInfo(
    String name,
    String email,
  ) async {
    final user = await _firebaseAuth.currentUser();
    if (user == null) {
      throw Exception('No user login');
    }
    return await getClientReference(user.uid)
        .updateData({"Name": name, "Email": email});
  }

  Future<void> updateGoogleUserInfo(
      String name, String phone, String email) async {
    final user = await _firebaseAuth.currentUser();
    if (user == null) {
      throw Exception('No user login');
    }
    return await getClientReference(user.uid)
        .updateData({"Name": name, "Phone": phone, "Email": email});
  }

  Future<void> setGoogleSignupType() async {
    final user = await _firebaseAuth.currentUser();
    if (user == null) {
      throw Exception('No user login');
    }
    String type = '';
    user.providerData
        .map((item) => {
              if (item.email != null) {type = item.providerId}
            })
        .toList();
    return await getClientReference(user.uid).updateData({"SignupType": type});
  }

  /// get business category
  Future<List<String>> getBusinessCategories() async {
    final response = await getIndexReference().get();
    if (response.data == null) {
      throw Exception('Can not get business category');
    }

    final categories = response.data['Type'] as List<String>;
    return categories;
  }

  /// get business coupon
  Future<List<Coupon>> getBusinessCoupons(String businessId) async {
    await _analytics.logSelectContent(
      contentType: 'Business',
      itemId: businessId,
    );
    final response = await _firestore
        .collection('Coupons')
        .document(businessId)
        .collection('Coupons')
        .where('IsActive', isEqualTo: true)
        .orderBy('Price', descending: false)
        .getDocuments();
    final coupons = response.documents.map((DocumentSnapshot snapshot) {
      var coupon = Coupon.fromJson(snapshot.data);
      coupon.couponId = snapshot.documentID;
      coupon.locale = _locale;
      return coupon;
    }).toList();
    return coupons;
  }

  /// get inficash charge options
  Future<ChargeOption> getChargeOptions() async {
    final response = await _firestore
        .collection('Charge_options')
        .where('Validatity.Start_date', isLessThanOrEqualTo: Timestamp.now())
        .getDocuments();
    if (response.documents.length > 0) {
      final optionDoc = response.documents.firstWhere((doc) {
        final option = ChargeOption.fromJson(doc.data);
        return option.endDate.isAfter(DateTime.now());
      });

      return ChargeOption.fromJson(optionDoc.data);
    } else {
      throw Exception('No charge option');
    }
  }

  //* get search whats new list
  Future<SearchSuggestions> getWhatsNewList() async {
    final response = await _firestore
        .collection('Index')
        .document('DocumentCategory2')
        .collection('Recommend')
        .document('M7al9OiC0Ahq9cfkCgcF')
        .get();

    if (response.data != null) {
      return SearchSuggestions.fromJson(response.data);
    } else {
      throw Exception('Empty search recommed');
    }
  }

  bool isAfterToday(Timestamp timestamp) {
    return DateTime.now().toUtc().isAfter(
          DateTime.fromMillisecondsSinceEpoch(
            timestamp.millisecondsSinceEpoch,
            isUtc: false,
          ).toUtc(),
        );
  }

  bool isBeforeToday(Timestamp timestamp) {
    return DateTime.now().toUtc().isBefore(
          DateTime.fromMillisecondsSinceEpoch(
            timestamp.millisecondsSinceEpoch,
            isUtc: false,
          ).toUtc(),
        );
  }

  Future<AppBanner> getAppBanner() async {
    final couponResponse = await _firestore
        .collection('Admin')
        .document('Coupons')
        .collection("Coupons")
        .getDocuments();
    final response =
        await _firestore.collection('Ads_Banner').document('Banners').get();
    final bottomBanner = [];
    final topBanner = [];
    var tempItem = {};
    couponResponse.documents.map((jsonObject) {
      if (isBeforeToday(jsonObject.data['Validatity']['End_date']) &&
          isAfterToday(jsonObject.data['Validatity']['Start_date'])) {
        response.data['Home_mid1_banners']
            .map((item) => {
                  // ignore: sdk_version_ui_as_code
                  tempItem = item,

                  if (item['Argument']['CouponId'] == jsonObject.data['id'])
                    {
                      tempItem['Title'] = jsonObject.data['Title'],
                      tempItem['Price'] = jsonObject.data['Price'],
                      tempItem['OriginalPrice'] =
                          jsonObject.data['Original_price'],
                      tempItem['Quantity'] = jsonObject.data['Quantity'],
                      bottomBanner.add(tempItem),
                      print('==========================$tempItem'),
                    }
                })
            .toList();
        response.data['Home_top_banners']
            .map((item) => {
                  // ignore: sdk_version_ui_as_code
                  if (item['Argument']['CouponId'] == jsonObject.data['id'] &&
                      jsonObject.data['Quantity'] >
                          jsonObject.data['Sold_cnts'])
                    {topBanner.add(item)}
                })
            .toList();
      }
    }).toList();
    if (response.data != null) {
      AppBanner appBanner = AppBanner.fromJson(
          {'Home_mid1_banners': bottomBanner, 'Home_top_banners': topBanner});
      return appBanner;
    } else {
      throw Exception('Can not get app banner');
    }
  }

  Future<List<String>> getSearchSuggestions(String queryWord) async {
    AlgoliaQuery query =
        _algolia.instance.index('Search_suggestion').search(queryWord);
    try {
      final response = await query.getObjects();
      return response.hits.map((snapshot) {
        return snapshot.data['Suggestion'] as String;
      }).toList();
    } catch (e) {
      print(e);
      throw Exception('Error fetching business');
    }
  }

  /// change coupon ticket pick items in groups
  Future<void> updateTicketItems(String couponId, CouponDetail detail) async {
    final user = await _firebaseAuth.currentUser();
    if (user == null) {
      throw Exception('No user login');
    }
    await _analytics.logEvent(name: "ChooseCombo", parameters: {
      'user': user.uid,
      'couponId': couponId,
    });
    return await _firestore
        .collection('Coupon_ticket')
        .document(user.uid)
        .collection('Coupon_ticket')
        .document(couponId)
        .updateData({'Details': detail.toJson(), 'Picked': true});
  }

  /// get a tikcet info
  Future<CouponTicket> getTicketInfo(String couponId) async {
    await _analytics.logSelectContent(
      contentType: 'Coupon_Ticket',
      itemId: couponId,
    );
    final user = await _firebaseAuth.currentUser();
    if (user == null) {
      throw Exception('No user logined in');
    }

    final response = await _firestore
        .collection('Coupon_ticket')
        .document(user.uid)
        .collection('Coupon_ticket')
        .document(couponId)
        .get();
    if (response.data == null) {
      throw Exception('Can not fetch ticket info');
    }
    return CouponTicket.fromJson(response.data);
  }

  /// get splash ads from firebase
  Future<SplashInfo> getSplashAds() async {
    final documents = await _firestore.collection('Splash_ads').getDocuments();

    if (documents.documents.length > 0) {
      return SplashInfo.fromJson(documents.documents[0].data);
    } else {
      throw Exception('Empty Splash Ads');
    }
  }

  /// fetch restaurant categorys
  Future<RestaurantCategory> fetchRestaurantCate() async {
    final documet = await _firestore
        .collection('Index')
        .document('DocumentCategory2')
        .collection('Restaurant')
        .document('IJBFQboaiR2S9DH3cQjT')
        .get();
    if (documet.data == null) {
      throw Exception('Empty Category');
    } else {
      return RestaurantCategory.fromJson(documet.data);
    }
  }

  /// client redeem ticket function
  /// not using qrcode scanner in business
  Future<void> selfRedeemTicket(String ticketId) async {
    final Map<String, String> headers = Map();
    final Map<String, dynamic> body = Map();
    final user = await _firebaseAuth.currentUser();
    final token = await user.getIdToken();
    headers['Authorization'] = 'Bearer ${token.token}';
    headers['Content-Type'] = 'application/json';
    print('===================,${user.uid}');
    body['TicketNumber'] = ticketId;
    body['ClientId'] = '';

    final url = BASE_URL + TICKET_VERIFY_URL;
    print('==================================, ${json.encode(body)}');
    var response =
        await httpClient.post(url, headers: headers, body: json.encode(body));
    // await _analytics.logEvent(name: 'SelfRedeem', parameters: {
    //   'ticket': ticketId,
    // });

    if (response.statusCode == 200) {
      return;
    } else {
      throw InfiShareApiError.fromJson(
        json.decode(response.body),
      );
    }

    // final user = await _firebaseAuth.currentUser();

    // if (user == null) {
    //   throw InfiShareApiError.fromJson(
    //       {"error": "E10020105", "message": "write Order And Ticket Failed"});
    // }
    // DocumentSnapshot ticketDoc = await _firestore
    //     .collection("Coupon_ticket")
    //     .document(user.uid)
    //     .collection("Coupon_ticket")
    //     .document(ticketId)
    //     .get();

    // if (!ticketDoc.exists) {
    //   throw InfiShareApiError.fromJson({
    //     "error": "E10020102",
    //     "message": "Coupon Ticket document does not exists!"
    //   });
    // }
    // DocumentSnapshot businessDoc = await _firestore
    //     .collection("Business")
    //     .document(ticketDoc.data['BusinessId'])
    //     .get();
    // if (!businessDoc.exists) {
    //   throw InfiShareApiError.fromJson(
    //       {"error": "E10020102", "message": "Business_document_get_failed!"});
    // }
  }

  ///
  /// Rate business after use coupon
  ///
  Future<void> rateBusiness(String businessId, String rate) async {
    final user = await _firebaseAuth.currentUser();
    if (user == null) throw Exception('No user login');
    await FirebaseAnalytics().logEvent(name: 'rate_business', parameters: {
      'userId': user != null ? user.uid : '',
      'business_id': businessId,
      'rating': rate
    });
    var rateRef = _firestore.collection('Reviews').document(businessId);
    _firestore.runTransaction((transaction) async {
      final businessDoc = await transaction.get(rateRef);
      final oldRate = businessDoc.data[rate] as int;
      await transaction.update(rateRef, {rate: oldRate + 1});
      return;
    });
  }

  ///
  /// Get customer charge history
  ///
  Future<List<ChargeHistory>> getChargeHistory(
      {int limit,
      String filter = 'InfiShare.chargeForBalance',
      String startId}) async {
    final url = BASE_URL + GET_CHARGE_HISTORY_URL;
    final user = await _firebaseAuth.currentUser();
    final token = await user.getIdToken();
    final Map<String, String> headers = Map();
    final Map<String, dynamic> body = Map();
    headers['Authorization'] = 'Bearer ${token.token}';
    headers['content-type'] = 'application/json';

    body['Limit'] = limit;
    body['FilterString'] = filter;
    body['StartId'] = startId;
    final response = await httpClient.post(
      url,
      body: json.encode(body),
      headers: headers,
    );
    if (response.statusCode == 200) {
      var tmp = json.decode(response.body) as Map<String, dynamic>;
      var historys = tmp['result'] as List<dynamic>;
      print(historys);
      return historys.map((jsonMap) {
        return ChargeHistory.fromJson(jsonMap as Map<String, dynamic>);
      }).toList();
    } else {
      throw InfiShareApiError.fromJson(
        json.decode(response.body),
      );
    }
  }

  Future<List<TransactionHistory>> getTransactionHistory() async {
    final user = await _firebaseAuth.currentUser();
    if (user == null) {
      throw Exception('No user logined in');
    }

    final response = await _firestore
        .collection('TranscationHistory')
        .document(user.uid)
        .collection('TransactionHistory')
        .orderBy('Create_date', descending: true)
        .getDocuments();
    if (response.documents == null) {
      throw Exception('Can not fetch ticket info');
    }

    return response.documents.map((jsonMap) {
      return TransactionHistory.fromJson(jsonMap.data);
    }).toList();
  }

  Future<void> chargeWallet({double chargeAmount}) async {
    final user = await _firebaseAuth.currentUser();
    final _user =
        await _firestore.collection('Client').document(user.uid).get();
    DocumentSnapshot _admin =
        await _firestore.collection('Admin').document("Data").get();
    if (user == null) {
      throw Exception('No user logined in');
    }
    await getClientReference(user.uid).updateData({
      'Balance': FieldValue.increment(chargeAmount),
    });

    String documentId = _firestore
        .collection("TranscationHistory")
        .document(user.uid)
        .collection("TransactionHistory")
        .document()
        .documentID;

    await _firestore
        .collection('TranscationHistory')
        .document(user.uid)
        .collection('TransactionHistory')
        .document(documentId)
        .setData({
      "Id": documentId,
      "BusinessId": _admin.data['UID'],
      "Charge_cash": chargeAmount,
      "ClientId": user.uid,
      "ClientName": _user.data['Name'],
      "Create_date": Timestamp.now(),
      "Earned_point": 0,
      "Final_cash_balance": 0.0,
      "Final_credit_balance": 0.0,
      "Final_point_balance": 0.0,
      "OrderId": "",
      "Subtotal": chargeAmount,
      "Title": "CHI+GO RELOAD CHARGE",
      "Type": "Charge",
      "Used_cash": chargeAmount
    });

    await _firestore
        .collection('TranscationHistory')
        .document(_admin.data['UID'])
        .collection('TransactionHistory')
        .document(documentId)
        .setData({
      "Id": documentId,
      "BusinessId": _admin.data['UID'],
      "Charge_cash": chargeAmount,
      "ClientId": user.uid,
      "ClientName": _user.data['Name'],
      "Create_date": Timestamp.now(),
      "Earned_point": 0,
      "Final_cash_balance": 0.0,
      "Final_credit_balance": 0.0,
      "Final_point_balance": 0.0,
      "OrderId": "",
      "Subtotal": chargeAmount,
      "Title": "CHI+GO RELOAD CHARGE",
      "Type": "Charge",
      "Used_cash": chargeAmount
    });
  }

  Future<String> payToBusiness(
      {double amount,
      double finalCashBalance,
      double finalPointsBalance,
      double finalCreditlineBalance,
      Business business,
      Coupon coupon,
      String subAccountId,
      String note,
      String orderId,
      String type}) async {
    final user = await _firebaseAuth.currentUser();
    if (user == null) {
      throw Exception('No user logined in');
    }

    DocumentSnapshot _admin =
        await _firestore.collection('Admin').document("Data").get();

    // Update client balance
    if (type != "Purchase") {
      await getClientReference(user.uid).updateData({
        'Balance': FieldValue.increment(-finalCashBalance),
        'Points_balance': FieldValue.increment(
            -(finalPointsBalance * 100).toInt() +
                (amount * business.cashPointRate).toInt()),
        'CreditLine_balance': FieldValue.increment(-finalCreditlineBalance),
      });
    } else {
      await getClientReference(user.uid).updateData({
        'Balance': FieldValue.increment(-finalCashBalance),
        'Points_balance':
            FieldValue.increment(-(finalPointsBalance * 100).toInt()),
        'CreditLine_balance': FieldValue.increment(-finalCreditlineBalance),
      });
    }

    // Update business account balance
    if (type == "Pay") {
      await _firestore
          .collection('Business')
          .document(business.businessId)
          .updateData({
        "Business_account_balance": FieldValue.increment(
            amount - amount * (business.cashPointRate / 100)),
      });
    }
    if (type == "Purchase") {
      await _firestore.collection('Admin').document('Data').updateData({
        "Business_account_balance": FieldValue.increment(amount),
      });
    }

    // Add Client Trasnaction History
    String documentId = _firestore
        .collection("TranscationHistory")
        .document(user.uid)
        .collection("TransactionHistory")
        .document()
        .documentID;
    DocumentSnapshot _user =
        await _firestore.collection('Client').document(user.uid).get();

    if (type == "Purchase") {
      await _firestore
          .collection('TranscationHistory')
          .document(user.uid)
          .collection('TransactionHistory')
          .document(documentId)
          .setData({
        "Id": documentId,
        "BusinessId": _admin.data['UID'],
        "Charge_cash": 0.0,
        "ClientId": user.uid,
        'BusinessName': business.businessName['English'],
        "ClientName": _user.data['Name'],
        "Create_date": Timestamp.now(),
        "Earned_point": 0.0,
        "Final_cash_balance": finalCashBalance,
        "Final_credit_balance": finalCreditlineBalance,
        "Final_point_balance": finalPointsBalance,
        "OrderId": orderId,
        "Subtotal": amount,
        "Title": type == "Pay" ? ("Paid to Admin") : coupon.name,
        "Type": type,
        "Used_cash": amount,
        "CashPointRate": business.cashPointRate,
        "Note": note,
      });

      // Add Business Transaction History
      await _firestore
          .collection("TranscationHistory")
          .document(_admin.data['UID'])
          .collection("TransactionHistory")
          .document(documentId)
          .setData({
        "BusinessId": _admin.data['UID'],
        "SubaccountId": subAccountId,
        "Charge_cash": amount,
        'BusinessName': business.businessName['English'],
        "Id": documentId,
        "ClientId": user.uid,
        "ClientName": _user.data['Name'],
        "Create_date": Timestamp.now(),
        "Earned_point": 0.0,
        "Final_cash_balance": finalCashBalance,
        "Final_credit_balance": finalCreditlineBalance,
        "Final_point_balance": finalPointsBalance,
        "OrderId": orderId,
        "Subtotal": amount,
        "Title": type == "Pay" ? ("Paid to Admin") : coupon.name,
        "Type": type,
        "Used_cash": amount,
        "Used_creditLine_balance": finalCreditlineBalance,
        "Used_point": finalPointsBalance,
        "CashPointRate": business.cashPointRate,
        "Note": note,
      });
    } else {
      await _firestore
          .collection('TranscationHistory')
          .document(user.uid)
          .collection('TransactionHistory')
          .document(documentId)
          .setData({
        "Id": documentId,
        "BusinessId": business.businessId,
        "Charge_cash": 0.0,
        "ClientId": user.uid,
        'BusinessName': business.businessName['English'],
        "ClientName": _user.data['Name'],
        "Create_date": Timestamp.now(),
        "Earned_point": (amount * business.cashPointRate).toInt(),
        "Final_cash_balance": finalCashBalance,
        "Final_credit_balance": finalCreditlineBalance,
        "Final_point_balance": finalPointsBalance,
        "OrderId": orderId,
        "Subtotal": amount,
        "BuinessRebate":
            type == "Pay" ? amount * (business.cashPointRate / 100) : 0,
        "Title": type == "Pay"
            ? ("Paid to " + business.businessName['English'])
            : ("Purchase from " + business.businessName['English']),
        "Type": type,
        "Used_cash": amount,
        "CashPointRate": business.cashPointRate,
        "Note": note,
      });

      // Add Business Transaction History
      await _firestore
          .collection("TranscationHistory")
          .document(business.businessId)
          .collection("TransactionHistory")
          .document(documentId)
          .setData({
        "BusinessId": business.businessId,
        "SubaccountId": subAccountId,
        "CashPointRate": business.cashPointRate,
        "Charge_cash": amount,
        "Id": documentId,
        "ClientId": user.uid,
        "ClientName": _user.data['Name'],
        'BusinessName': business.businessName['English'],
        "Create_date": Timestamp.now(),
        "Earned_point": (amount * business.cashPointRate).toInt(),
        "Final_cash_balance": finalCashBalance,
        "Final_credit_balance": finalCreditlineBalance,
        "Final_point_balance": finalPointsBalance,
        "OrderId": orderId,
        "Subtotal": amount,
        "BuinessRebate":
            type == "Pay" ? amount * (business.cashPointRate / 100) : 0,
        "Title": type == "Pay"
            ? ("Paid to " + business.businessName['English'])
            : ("Purchase from " + business.businessName['English']),
        "Type": type,
        "Used_cash": amount,
        "Used_creditLine_balance": finalCreditlineBalance,
        "Used_point": finalPointsBalance,
        "Note": note,
      });

      await _firestore
          .collection("TranscationHistory")
          .document(_admin.data['UID'])
          .collection("TransactionHistory")
          .document(documentId)
          .setData({
        "BusinessId": business.businessId,
        "SubaccountId": subAccountId,
        "CashPointRate": business.cashPointRate,
        "Charge_cash": amount,
        "Id": documentId,
        "ClientId": user.uid,
        "ClientName": _user.data['Name'],
        'BusinessName': business.businessName['English'],
        "Create_date": Timestamp.now(),
        "Earned_point": (amount * business.cashPointRate).toInt(),
        "Final_cash_balance": finalCashBalance,
        "Final_credit_balance": finalCreditlineBalance,
        "Final_point_balance": finalPointsBalance,
        "OrderId": orderId,
        "Subtotal": amount,
        "BuinessRebate":
            type == "Pay" ? amount * (business.cashPointRate / 100) : 0,
        "Title": type == "Pay"
            ? ("Paid to " + business.businessName['English'])
            : ("Purchase from " + business.businessName['English']),
        "Type": type,
        "Used_cash": amount,
        "Used_creditLine_balance": finalCreditlineBalance,
        "Used_point": finalPointsBalance,
        "Note": note,
      });
    }

    return documentId;
  }

  Future<String> purchaseCoupon(
      {double amount,
      double finalCashBalance,
      double finalPointsBalance,
      double finalCreditlineBalance,
      Business business,
      Coupon coupon}) async {
    final user = await _firebaseAuth.currentUser();
    DocumentSnapshot _admin =
        await _firestore.collection('Admin').document("Data").get();
    DocumentSnapshot _client =
        await _firestore.collection('Client').document(user.uid).get();
    DocumentSnapshot _coupon = await _firestore
        .collection('Admin')
        .document("Coupons")
        .collection("Coupons")
        .document(coupon.couponId)
        .get();
    if (user == null) {
      throw Exception('No user logined in');
    }
    String couponTicketId = _firestore
        .collection("Coupon_ticket")
        .document(user.uid)
        .collection("Coupon_ticket")
        .document()
        .documentID;

    String orderId = _firestore
        .collection("Orders")
        .document('Orders')
        .collection(user.uid)
        .document()
        .documentID;

    await _firestore
        .collection("Admin")
        .document("Coupons")
        .collection("Coupons")
        .document(coupon.couponId)
        .updateData({"Sold_cnts": _coupon.data['Sold_cnts'] + 1});

    await _firestore
        .collection("Coupon_ticket")
        .document(user.uid)
        .collection("Coupon_ticket")
        .document(couponTicketId)
        .setData({
      "Business": coupon.businessRef,
      "BusinessId": coupon.businessId,
      "Business_name": coupon.businessName,
      "Used_Business_name": [
        {"English": "", "Chinese": ""}
      ],
      "Used_BusinessId": "",
      "Category": business.getCategory(),
      "ClientId": user.uid,
      "CouponId": coupon.couponId,
      "CouponTicketId": couponTicketId,
      "Description": coupon.description,
      "Description_cn": coupon.descriptionCn,
      "Image": coupon.images,
      "Item": coupon.items,
      "OrderId": "",
      "Original_price": coupon.oriPrice,
      "Price": coupon.price,
      "Purchase_date": Timestamp.now(),
      "Rules": coupon.rule.toJson(),
      "Tax": coupon.tax,
      "Title": coupon.name,
      "Title_cn": coupon.nameCn,
      "Used": false,
      "Validatity": {"Start_date": coupon.start, "End_date": coupon.end},
      "Used_date": null,
    });

    await _firestore
        .collection("Orders")
        .document('Orders')
        .collection(user.uid)
        .document(orderId)
        .setData({
      "BusinessId": _admin.data['UID'],
      "BusinessName": business.businessName['English'],
      "ClientId": user.uid,
      "ClientName": _client.data['Name'],
      "CouponTicketId": couponTicketId,
      "CouponId": coupon.couponId,
      "Create_date": Timestamp.now(),
      "Earned_Point": amount ~/ 10,
      "Discount": coupon.oriPrice - coupon.price,
      "Item": coupon.items,
      "OrderId": orderId,
      "Title": coupon.name,
      "Original_price": coupon.oriPrice,
      "Price": coupon.price,
      "Order_type": "PURCHASE",
      "Used_cash": finalCashBalance,
      "Used_creditLine": finalCreditlineBalance,
      "Used_date": null,
      "Used_point": finalPointsBalance,
      "Tax": coupon.tax,
      "Subtotal": coupon.price + coupon.price * coupon.tax
    });

    String activeNumber = await payToBusiness(
        amount: amount,
        business: business,
        subAccountId: "",
        finalCashBalance: finalCashBalance,
        finalPointsBalance: finalPointsBalance,
        finalCreditlineBalance: finalCreditlineBalance,
        note: "",
        coupon: coupon,
        type: "Purchase",
        orderId: orderId);

    return activeNumber;
  }

  /// upload user avatar
  ///
  Future<String> uploadUserAvatar(String filePath) async {
    final user = await _firebaseAuth.currentUser();
    if (user == null) {
      throw Exception('No user login');
    }
    final ref = _firebaseStorage
        .ref()
        .child('Users/${user.uid}/images/Avatar/avatar_${timestamp()}.jpg');
    final File file = File(filePath);
    final uploadtask = ref.putFile(file);
    final snapshot = await uploadtask.onComplete;
    final String url = await snapshot.ref.getDownloadURL();
    await _firestore.collection("Client").document(user.uid).updateData({
      "Avatar": url,
    });
    return url;
  }

  ///
  /// Get business by reference
  ///
  Future<Business> getBusinessByRef(DocumentReference docRef) async {
    final response = await docRef.get();
    var business = Business.fromJson(response.data);
    business.businessId = response.documentID;
    return business;
  }

  Future<Business> getBusinessById(String businessId) async {
    final response =
        await _firestore.collection('Business').document(businessId).get();

    if (!response.exists) {
      return null;
    } else {
      var business = Business.fromJson(response.data);

      business.businessId = response.documentID;
      await _analytics.logSelectContent(
        contentType: 'Business',
        itemId: businessId,
      );

      return business;
    }
  }

  Future<DocumentSnapshot> getAdmin() async {
    final response =
        await _firestore.collection('Admin').document("Data").get();

    if (!response.exists) {
      return null;
    } else {
      return response;
    }
  }

  Future<List> findBusinessById(String businessId) async {
    final response =
        await _firestore.collection('Business').document(businessId).get();

    if (!response.exists) {
      return null;
    } else {
      if (response.data['AccountType'] == "MAIN") {
        var business = Business.fromJson(response.data);
        business.businessId = response.documentID;
        await _analytics.logSelectContent(
          contentType: 'Business',
          itemId: businessId,
        );
        return [business, ""];
      } else {
        final res = await _firestore
            .collection('Business')
            .document(response.data['BusinessId'])
            .get();
        if (!res.exists) {
          return null;
        } else {
          var business = Business.fromJson(res.data);
          business.businessId = res.documentID;
          return [business, response.data['SubaccountId']];
        }
      }
    }
  }

  Future<bool> checkGiftUsed(String giftId) async {
    final response = await _firestore.collection('Gift').document(giftId).get();
    final user = await _firebaseAuth.currentUser();
    await _firestore
        .collection('Gift')
        .document(giftId)
        .updateData({"Used": true, "ScannedClientId": user.uid});
    if (response.exists) {
      if (!response.data['Used']) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<void> cancelGiftCard(String giftId) async {
    final user = await _firebaseAuth.currentUser();
    await _firestore
        .collection('Gift')
        .document(giftId)
        .updateData({"Used": false, "ScannedClientId": ""});
  }

  Future<String> findGiftById(String giftId) async {
    final response = await _firestore.collection('Gift').document(giftId).get();
    final user = await _firebaseAuth.currentUser();
    final _userData =
        await _firestore.collection('Client').document(user.uid).get();
    DocumentSnapshot _admin =
        await _firestore.collection('Admin').document("Data").get();
    if (response.exists) {
      String documentId = _firestore
          .collection("TranscationHistory")
          .document(user.uid)
          .collection("TransactionHistory")
          .document()
          .documentID;

      await _firestore
          .collection('TranscationHistory')
          .document(user.uid)
          .collection('TransactionHistory')
          .document(documentId)
          .setData({
        "Id": documentId,
        "GiftCardId": giftId,
        "BusinessId": _admin.data['UID'],
        "Charge_cash": response.data['Value'],
        "ClientId": user.uid,
        'ClientName': _userData.data['Name'],
        "Create_date": Timestamp.now(),
        "Earned_point": 0,
        "Final_cash_balance": 0.0,
        "Final_credit_balance": 0.0,
        "Final_point_balance": 0.0,
        "OrderId": "",
        "Subtotal": response.data['Value'],
        "Title": "GIFT CARD CHARGE",
        "Type": "Gift Charge",
        "Used_cash": response.data['Value']
      });

      await _firestore
          .collection('TranscationHistory')
          .document(_admin.data['UID'])
          .collection('TransactionHistory')
          .document(documentId)
          .setData({
        "Id": documentId,
        "BusinessId": _admin.data['UID'],
        "Charge_cash": response.data['Value'],
        "ClientId": user.uid,
        'ClientName': _userData.data['Name'],
        "Create_date": Timestamp.now(),
        "Earned_point": 0,
        "Final_cash_balance": 0.0,
        "Final_credit_balance": 0.0,
        "Final_point_balance": 0.0,
        "OrderId": "",
        "Subtotal": response.data['Value'],
        "Title": "GIFT CARD CHARGE",
        "Type": "Gift Charge",
        "Used_cash": response.data['Value']
      });

      await _firestore
          .collection('Gift')
          .document(giftId)
          .updateData({"Used": true});

      await _firestore.collection('Client').document(user.uid).updateData(
          {"Balance": _userData.data['Balance'] + response.data['Value']});
      return documentId;
    } else {
      return "";
    }
  }

  Future<Coupon> getCouponById(String couponId, String businessId) async {
    log(couponId);
    log(businessId);

    final response = await _firestore
        .collection("Admin")
        .document("Coupons")
        .collection('Coupons')
        .document(couponId)
        .get();

    var coupon = Coupon.fromJson(response.data);
    log("=================${coupon}");
    coupon.couponId = response.documentID;
    coupon.locale = _locale;
    // await _analytics.logSelectContent(
    //   contentType: coupon.couponType,
    //   itemId: couponId,
    // );
    return coupon;
  }

  ///
  /// Get document references from firebase
  ///
  ///
  DocumentReference getClientReference(String userId) {
    return _firestore.collection('Client').document(userId);
  }

  DocumentReference getIndexReference() {
    return _firestore
        .collection('Index')
        .document('Z13C7j08p3gsBZ9k8rZP')
        .collection('Restaurant')
        .document('zHAuvbSdAt7R2Yjax1aw');
  }

  ///
  /// get current timestamp as string
  ///
  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  ///
  /// get business from agolia
  ///
  Future<List<Business>> fetchBusiness(
      {int page = 0,
      String queryWord,
      String filters = '',
      String location = '',
      int radius = -1,
      String index = AlgoliaConsts.RESTAURANT_COUPON_INDEX,
      int hitsPerPage = 20}) async {
    // AlgoliaQuery query = _algolia.instance.index(index).search(queryWord);

    // query = query.setHitsPerPage(hitsPerPage);
    // query = query.setPage(page);
    // print(filters);

    // if (filters != '') {
    //   query = query.setFilters(filters);
    // }

    // if (location != '') {
    //   query = query.setAroundLatLng(location);
    // }

    // if (radius != -1) {
    //   query = query.setAroundRadius(radius);
    // }

    Query query = _firestore
        .collection('Business')
        .where("AccountType", isEqualTo: "MAIN");

    try {
      // final response = await query.getObjects();
      final response = await query.getDocuments();
      // if (queryWord.isNotEmpty) {
      //   await _analytics.logSearch(searchTerm: 'Business:' + queryWord);
      // }
      // return response.hits.map((snapshot) {
      //   print(snapshot.objectID);
      //   print(snapshot.data);
      //   Business business = Business.fromJson(snapshot.data);
      //   business.businessId = snapshot.objectID;
      //   return business;
      // }).toList();
      return response.documents.map((doc) {
        Business business = Business.fromJson(doc.data);
        business.businessId = doc.documentID;
        return business;
      }).toList();
    } catch (e) {
      print(e);
      throw Exception('Error fetching business');
    }
  }

  //*
  //* Search coupons from algolia
  //*
  Future<List<CouponThumbnail>> fetchCoupon({
    String queryWord,
    int page = 0,
    int hitsPerPage = 50,
    String index = AlgoliaConsts.COOUPON_INDEX,
  }) async {
    AlgoliaQuery query = _algolia.instance.index(index).search(queryWord);
    query = query.setPage(page);
    query = query.setHitsPerPage(hitsPerPage);
    query = query.setFilters(AlgoliaConsts.ISACTIVE_FILTER);

    try {
      final response = await query.getObjects();
      if (queryWord.isNotEmpty) {
        await _analytics.logSearch(searchTerm: 'Coupon:' + queryWord);
      }
      return response.hits.map((snapshot) {
        print(snapshot.objectID);
        CouponThumbnail couponThumbnail =
            CouponThumbnail.fromJson(snapshot.data);
        couponThumbnail.couponId = snapshot.objectID.split('/')[1];

        return couponThumbnail;
      }).toList();
    } catch (e) {
      print(e);
      throw Exception('Error fetching coupons');
    }
  }

  Future<List<DocumentSnapshot>> fetchUserCoupon({
    int limit,
    DocumentSnapshot lastdoc,
    String type,
    bool used,
  }) async {
    List<DocumentSnapshot> snapshots = [];
    final user = await _firebaseAuth.currentUser();
    if (user == null) {
      throw Exception('No user login');
    }

    Query query = _firestore
        .collection('Coupon_ticket')
        .document(user.uid)
        .collection('Coupon_ticket')
        .where('ClientId', isEqualTo: user.uid);
    var startfulldate = Timestamp.fromDate(DateTime.now());
    // if (type != null) {
    //   query = query.where('Type', isEqualTo: type);
    // }

    // if (lastdoc != null) {
    //   query = query.startAfterDocument(lastdoc);
    // }

    // if (used) {
    //   query = query.orderBy('Used_date', descending: true);
    // } else {
    //   query = query.orderBy('Purchase_date', descending: true);
    // }

    // query = query.where('Used', isEqualTo: used).limit(limit);
    // query = query.where('Validatity.End_date', isGreaterThan: startfulldate);

    if (used) {
      final rawData = await query.getDocuments();
      rawData.documents
          .map((item) => {
                if (item.data['Validatity']['End_date'].millisecondsSinceEpoch <
                        startfulldate.millisecondsSinceEpoch ||
                    item.data['Used'])
                  {snapshots.add(item)}
              })
          .toList();
    } else {
      query = query.where('Used', isEqualTo: used);
      final rawData = await query.getDocuments();
      rawData.documents
          .map((item) => {
                if (item.data['Validatity']['End_date'].millisecondsSinceEpoch >
                    startfulldate.millisecondsSinceEpoch)
                  {snapshots.add(item)}
              })
          .toList();
    }

    // rawData.documents
    //     .map((item) => {
    //           if (item.data['Validatity']['End_date'].millisecondsSinceEpoch >
    //               startfulldate.millisecondsSinceEpoch)
    //             {snapshots.add(item)}
    //         })
    //     .toList();
    // snapshots.addAll(rawData.documents);
    return snapshots;
  }

  Future<ItemCategoryList> fetchItemCategories({String businessId}) async {
    final response = await _firestore
        .collection('Business_catalogs')
        .document(businessId)
        .get();

    if (response.data == null) {
      return ItemCategoryList(category: []);
    } else {
      return ItemCategoryList.fromJson(response.data);
    }
  }

  /// Fetch items from algolia
  Future<List<OrderItem>> fetchItems({
    String category,
    List<String> filters,
    String businessId,
    String queryWord,
    String index,
  }) async {
    AlgoliaQuery query = _algolia.instance.index(index).search(queryWord);
    query = query.setFacetFilter('Business_id:$businessId');
    if (category.isNotEmpty) {
      query = query.setFacetFilter('Category:$category');
    }

    filters.forEach((filter) {
      query = query.setFacetFilter(filter);
    });

    try {
      final response = await query.getObjects();
      return response.hits.map((hit) {
        // print each response data
        print(hit.data.toString());
        // parse to item object
        return OrderItem.fromJson(hit.data);
      }).toList();
    } catch (e) {
      print(e.toString());
      throw Exception('Error fetching items from server');
    }
  }

  /// fetch item from firebase
  Future<List<OrderItem>> fetchItemByCategories({
    String category,
    String businessId,
  }) async {
    final response = await _firestore
        .collection('Business_catalogs')
        .document(businessId)
        .collection('Items')
        .where('Category', isEqualTo: category)
        .getDocuments();

    final items = response.documents.map((snapshot) {
      return OrderItem.fromJson(snapshot.data);
    }).toList();

    return items;
  }
}
