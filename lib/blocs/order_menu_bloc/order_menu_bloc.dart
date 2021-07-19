import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:infishare_client/models/business.dart';
import 'package:infishare_client/repo/order_repo.dart';
import 'package:infishare_client/repo/utils/algolia_consts.dart';
import './bloc.dart';

class OrderMenuBloc extends Bloc<OrderMenuEvent, OrderMenuState> {
  final Business business;
  final OrderRepo orderRepo;

  OrderMenuBloc({
    this.business,
    this.orderRepo,
  });

  @override
  OrderMenuState get initialState => OrderMenuLoading();

  @override
  Stream<OrderMenuState> mapEventToState(
    OrderMenuEvent event,
  ) async* {
    if (event is FetchItems) {
      yield* _mapFetchItemsToState(event);
    }
  }

  Stream<OrderMenuState> _mapFetchItemsToState(FetchItems event) async* {
    final List<String> filter = [];

    event.filters.forEach((f, isSelected) {
      if (isSelected) {
        filter.add(AlgoliaConsts.INGREDIENTS + '-$f');
      }
    });
  }
}
