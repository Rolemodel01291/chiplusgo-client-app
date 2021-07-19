import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:infishare_client/blocs/business_map_bloc.dart';
import './bloc.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  int sortByIndex;
  int selectedDis;
  int selectedCate;
  List<bool> filters = [];

  final BusinessMapBloc businessListBloc;

  FilterBloc({
    this.businessListBloc,
  }) {
    sortByIndex = businessListBloc.sortIndex;
    selectedDis = businessListBloc.distanceIndex;
    selectedCate = businessListBloc.cateIndex;
    filters.addAll(businessListBloc.labelFilter);
  }

  @override
  FilterState get initialState => BaseFilterState(
        sortByIndex,
        selectedDis,
        selectedCate,
        filters,
      );

  @override
  Stream<FilterState> mapEventToState(
    FilterEvent event,
  ) async* {
    if (event is FetchBusinessCategory) {
      yield BaseFilterState(
        sortByIndex,
        selectedDis,
        selectedCate,
        filters,
      );
    } else if (event is ChangeSearchIndex) {
      sortByIndex = event.index;
      yield BaseFilterState(
        sortByIndex,
        selectedDis,
        selectedCate,
        filters,
      );
    } else if (event is ChangeRadius) {
      selectedDis = event.index;
      yield BaseFilterState(
        sortByIndex,
        selectedDis,
        selectedCate,
        filters,
      );
    } else if (event is ChangeFilters) {
      filters[event.index] = !filters[event.index];
      yield BaseFilterState(
        sortByIndex,
        selectedDis,
        selectedCate,
        filters,
      );
    } else if (event is ChangeCategory) {
      selectedCate = event.index;
      yield BaseFilterState(sortByIndex, selectedDis, selectedCate, filters);
    } else if (event is ResetFilter) {
      sortByIndex = 0;
      selectedCate = -1;
      selectedDis = 0;
      filters.clear();
      filters.addAll([false, false, false, false]);
      yield BaseFilterState(
        sortByIndex,
        selectedDis,
        selectedCate,
        filters,
      );
    } else if (event is FilterConfirmEvent) {
      businessListBloc.add(
        FetchBusiness(
            sortIndex: sortByIndex,
            label: filters,
            distanceIndex: selectedDis,
            categoryIndex: selectedCate),
      );
    }
  }
}
