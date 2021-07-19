import 'package:flutter/foundation.dart';
import 'package:infishare_client/models/models.dart';
import 'package:infishare_client/repo/repo.dart';

class OrderRepo {
  final InfiShareApiClient infiShareApiClient;

  OrderRepo({@required this.infiShareApiClient});

  Future<ItemCategoryList> fetchItemCategories({String businessId}) async {
    return await infiShareApiClient.fetchItemCategories(
      businessId: businessId,
    );
  }

  Future<List<OrderItem>> fetchItems({
    String category = '',
    List<String> filters = const [],
    String businessId,
    String queryWord = '',
    String index = AlgoliaConsts.TEST_ITEM,
  }) async {
    return await infiShareApiClient.fetchItems(
      category: category,
      filters: filters,
      businessId: businessId,
      queryWord: queryWord,
      index: index,
    );
  }
}
