//* Data provider for main page

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:infishare_client/models/models.dart';
import 'package:infishare_client/repo/repo.dart';

class MainRepo {
  final InfiShareApiClient infiShareApiClient;

  MainRepo({@required this.infiShareApiClient});

  Future<List<DocumentSnapshot>> fetchRecentOrder() async {
    return await infiShareApiClient.fetchUserCoupon(
      limit: 15,
      used: false,
    );
  }

  Future<List<CouponThumbnail>> fetchNewCoupon() async {
    return await infiShareApiClient.fetchCoupon(
      queryWord: '',
      hitsPerPage: 10,
      index: AlgoliaConsts.COUPON_ADD_INDEX,
    );
  }

  Future<List<CouponThumbnail>> fetchBestSell() async {
    return await infiShareApiClient.fetchCoupon(
      queryWord: '',
      hitsPerPage: 10,
      index: AlgoliaConsts.COUPON_SOLD_INDEX,
    );
  }

  Future<List<CouponThumbnail>> fetchMostDiscount() async {
    return await infiShareApiClient.fetchCoupon(
      queryWord: '',
      hitsPerPage: 30,
      index: AlgoliaConsts.COUPON_DISCOUNT_INDEX,
    );
  }

  Future<List<Business>> fetchRecommend() async {
    return await infiShareApiClient.fetchBusiness(
      queryWord: '',
      hitsPerPage: 10,
    );
  }

  Future<List<Business>> fetchNewBusiness() async {
    return await infiShareApiClient.fetchBusiness(
      queryWord: '',
      hitsPerPage: 10,
      filters: "Membership.Type:New",
    );
  }

  Future<List<Business>> fetchHottest() async {
    return await infiShareApiClient.fetchBusiness(
      queryWord: '',
      hitsPerPage: 10,
      index: AlgoliaConsts.RESTAURANT_REVIEWCNT,
    );
  }

  Future<List<Business>> fetchNearBy({String location, int radius}) async {
    return await infiShareApiClient.fetchBusiness(
      queryWord: '',
      hitsPerPage: 10,
      location: location,
      radius: radius,
    );
  }

  Future<AppBanner> fetchAppBanner() async {
    return await infiShareApiClient.getAppBanner();
  }

  Future<RestaurantCategory> fetchRestaurantCate() async {
    return await infiShareApiClient.fetchRestaurantCate();
  }
}
