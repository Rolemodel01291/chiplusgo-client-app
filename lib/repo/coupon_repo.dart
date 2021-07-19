import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:infishare_client/models/models.dart';
import 'package:infishare_client/repo/repo.dart';
import 'package:infishare_client/repo/utils/firebase_consts.dart';

class CouponRepository {
  final InfiShareApiClient client;
  final Firestore _firestore;
  final FirebaseAuth _firebaseAuth;

  CouponRepository(
      {@required this.client, Firestore firestore, FirebaseAuth firebaseAuth})
      : _firestore = firestore ?? Firestore.instance,
        _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        assert(client != null);

  Future<List<DocumentSnapshot>> fetchUserCouponTicket(
      {int limit = 10,
      DocumentSnapshot lastdoc,
      String type = FirestoreConstants.GROUP_BUY,
      bool used = false}) async {
    return await client.fetchUserCoupon(
        limit: limit, lastdoc: lastdoc, type: type, used: used);
  }

  Future<Business> getBusinessByRef(DocumentReference ref) async {
    return await client.getBusinessByRef(ref);
  }

  Future<CouponTicket> getTicketWithId(String ticketNum) async {
    return await client.getTicketInfo(ticketNum);
  }

  Future<Stream<QuerySnapshot>> getRealTimeCoupon() async {
    final user = await _firebaseAuth.currentUser();
    if (user == null) {
      throw Exception('Can not fetch user info');
    }
    return _firestore
        .collection('Coupon_ticket')
        .document(user.uid)
        .collection('Coupon_ticket')
        .where('ClientId', isEqualTo: user.uid)
        .snapshots();
  }

  Future<void> selfRedeemUserTicket(String ticketNum) async {
    return await client.selfRedeemTicket(ticketNum);
  }

  Future<void> updateTicketItems(String ticketNum, CouponDetail detail) async {
    return await client.updateTicketItems(ticketNum, detail);
  }
}
