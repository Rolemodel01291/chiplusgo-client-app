import 'package:meta/meta.dart';

@immutable
abstract class FilterState {}

class BaseFilterState extends FilterState {
  final int sortByIndex;
  final int selectedDis;
  final int selectedCate;
  final List<bool> filters;
  BaseFilterState([
    this.sortByIndex,
    this.selectedDis,
    this.selectedCate,
    this.filters,
  ]);

  @override
  String toString() =>
      'sortByIndex: $sortByIndex, selectedDis: $selectedDis, selectedCate: $selectedCate, wifi${filters[0]}, coupon${filters[1]}, voucher:${filters[2]}, parking:${filters[3]}';
}

class FilterComfirm extends BaseFilterState {
  FilterComfirm([
    int sortByIndex,
    int selectedDis,
    int selectedCate,
    List<bool> filters,
  ]) : super(
          sortByIndex,
          selectedDis,
          selectedCate,
          filters,
        );
}
