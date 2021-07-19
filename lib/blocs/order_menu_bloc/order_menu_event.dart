import 'package:meta/meta.dart';

@immutable
abstract class OrderMenuEvent {}

class FetchItems extends OrderMenuEvent {
  final Map<String, bool> filters;
  // represent user choose 'I don't eat', 'vegetarian' or 'vergan'
  final int selectedIndex;

  FetchItems({
    this.filters,
    this.selectedIndex,
  });
}
