import 'dart:collection';

import 'package:infishare_client/models/models.dart';
import 'package:meta/meta.dart';

@immutable
abstract class OrderMenuState {}

class OrderMenuLoading extends OrderMenuState {}

class OrderMenuLoadError extends OrderMenuState {
  final String errorMsg;

  OrderMenuLoadError({this.errorMsg});
}

class OrderMenuLoaded extends OrderMenuState {
  final HashMap<OrderItemCate, List<OrderItem>> categories;
  final Map<String, bool> filters;
  final int totalCnt;

  OrderMenuLoaded({
    this.categories,
    this.totalCnt,
    this.filters,
  });
}
