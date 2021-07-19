import 'package:meta/meta.dart';

@immutable
abstract class ItemsUpdateEvent {}


class ChangeCouponItems extends ItemsUpdateEvent {
  @override
  String toString() => 'ChangeCouponItems';

}

class AddItemEvent extends ItemsUpdateEvent {
  final int groupIndex;
  final int itemIndex;

  AddItemEvent({this.groupIndex, this.itemIndex});

  @override
  String toString() => 'Add item in group $groupIndex, item $itemIndex';

}

class RemoveItemEvent extends ItemsUpdateEvent {
  final int groupIndex;
  final int itemIndex;

  RemoveItemEvent({this.groupIndex, this.itemIndex});

  @override
  String toString() => 'Remove item in group $groupIndex, item $itemIndex';
}