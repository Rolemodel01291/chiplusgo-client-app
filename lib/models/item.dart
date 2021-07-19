import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'modifier.dart';

part 'item.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class Item extends Equatable {
  @JsonKey(name: 'Item')
  String item;
  @JsonKey(name: 'Item_cn')
  String itemCn;
  @JsonKey(name: 'Amount')
  int amount;
  @JsonKey(name: 'Price')
  double price;
  @JsonKey(name: 'Count')
  int count;
  @JsonKey(name: 'Category')
  String category;
  @JsonKey(name: 'Variations')
  String variations;
  @JsonKey(name: 'Image')
  String imageUrl;
  @JsonKey(name: 'Modifiers')
  List<Modifier> modifiers;

  Item(this.item, this.itemCn, this.amount, this.price, this.count,
      this.category, this.variations, this.imageUrl, this.modifiers);

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);

  @override
  List<Object> get props => [item, itemCn, amount, price, count];
}
