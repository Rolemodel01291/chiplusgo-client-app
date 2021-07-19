import 'package:meta/meta.dart';

@immutable
abstract class FilterEvent {}

class FetchBusinessCategory extends FilterEvent {
  @override
  String toString() => 'Fetch Business category';
}

class ChangeSearchIndex extends FilterEvent {
  final int index;

  ChangeSearchIndex({this.index});

  @override
  String toString() => 'ChangeSearchIndex $index';
}

class ChangeRadius extends FilterEvent {
  final int index;

  ChangeRadius({this.index});

  @override
  String toString() => 'ChangeRadius';
}

class ChangeFilters extends FilterEvent {
  final int index;

  ChangeFilters({this.index});

  @override
  String toString() => 'Change filters $index';
}

class ChangeCategory extends FilterEvent {
  final int index;

  ChangeCategory({this.index});

  @override
  String toString() => 'Change category $index';
}

class FilterConfirmEvent extends FilterEvent {
  @override
  String toString() => 'Comfirm filter';
}

class ResetFilter extends FilterEvent {
  @override
  String toString() => 'Reset Filter';
}
