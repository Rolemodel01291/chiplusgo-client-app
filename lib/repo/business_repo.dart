import 'package:infishare_client/models/search_suggestions.dart';
import 'package:infishare_client/repo/repo.dart';

import './infishare_api.dart';
import 'dart:async';
import 'package:meta/meta.dart';
import '../models/models.dart';

class BusinessRepository {
  final InfiShareApiClient apiClient;

  BusinessRepository({@required this.apiClient}) : assert(apiClient != null);

  Future<SearchSuggestions> fetchSearchRecommed() async {
    return await apiClient.getWhatsNewList();
  }

  Future<List<Business>> fetchBusiness(
      {int page = 0,
      @required String queryWord,
      String filters = '',
      String location = '',
      int radius = -1,
      String index = AlgoliaConsts.RESTAURANT_COUPON_INDEX,
      int hitsPerPage = 20}) async {
    return await apiClient.fetchBusiness(
        page: page,
        queryWord: queryWord,
        filters: filters,
        location: location,
        radius: radius,
        index: index);
  }

  Future<List<String>> getSearchSuggestions(String queryWord) async {
    return await apiClient.getSearchSuggestions(queryWord);
  }

  Future<List<Business>> searchBusiness(String queryWord) async {
    return await apiClient.fetchBusiness(queryWord: queryWord);
  }

  Future<List<Business>> getNearbyBusiness(
      {String location, int radius = 1500}) async {
    return await apiClient.fetchBusiness(
        queryWord: '', location: location, radius: radius, hitsPerPage: 5);
  }

  Future<List<Coupon>> getBusinessCoupon(String businessId) async {
    return await apiClient.getBusinessCoupons(businessId);
  }

  Future<List<CouponThumbnail>> getCouponThumbnail({String query}) async {
    return await apiClient.fetchCoupon(queryWord: query);
  }

  Future<Coupon> getCouponById(String couponId, String businessId) async {
    return await apiClient.getCouponById(couponId, businessId);
  }

  Future<Business> getBusinessById(String businessId) async {
    return await apiClient.getBusinessById(businessId);
  }
}
