import 'package:json_annotation/json_annotation.dart';
import 'nutrition.dart';
part 'order_item.g.dart';

@JsonSerializable(anyMap: true)
class OrderItem {
  @JsonKey(name: 'Name')
  final String name;
  @JsonKey(name: 'Ingredients')
  final List<String> ingredients;
  @JsonKey(name: 'Category')
  final String category;
  @JsonKey(name: 'Avaliable')
  final bool avaliable;
  @JsonKey(name: 'Available_modifiers')
  final List<String> avaliableModifiers;
  @JsonKey(name: 'Price')
  final double price;
  @JsonKey(name: 'Image')
  final String image;
  @JsonKey(name: 'Tax_class')
  final List<String> taxClass;
  @JsonKey(name: 'Added_date')
  final double addedDate;
  @JsonKey(name: 'Description')
  final String description;
  @JsonKey(name: 'Name_cn')
  final String nameCN;
  @JsonKey(name: 'Sold_cnt')
  final double soldCnt;
  @JsonKey(name: 'Nutritions')
  final Nutrition nutritions;
  @JsonKey(name: 'Category_cn')
  final String categoryCN;
  @JsonKey(name: 'Available_variations')
  final List<String> availableVariations;
  @JsonKey(name: 'Spicy_level')
  final double spicyLevel;
  @JsonKey(name: 'Business_id')
  final String businessID;

  OrderItem(
    this.name,
    this.ingredients,
    this.category,
    this.avaliable,
    this.avaliableModifiers,
    this.price,
    this.image,
    this.taxClass,
    this.addedDate,
    this.description,
    this.nameCN,
    this.soldCnt,
    this.nutritions,
    this.categoryCN,
    this.availableVariations,
    this.spicyLevel,
    this.businessID,
  );

  factory OrderItem.fromJson(Map<String, dynamic> json) => _$OrderItemFromJson(json);

  Map<String, dynamic> toJson(OrderItem item) => _$OrderItemToJson(this);
}
