import 'package:infishare_client/models/models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'item_cate_list.g.dart';

@JsonSerializable(anyMap: true)
class ItemCategoryList {
  @JsonKey(name: 'Categories')
  final List<OrderItemCate> category;

  ItemCategoryList({this.category});

  factory ItemCategoryList.fromJson(Map<String, dynamic> json) =>
      _$ItemCategoryListFromJson(json);

  Map<String, dynamic> toJson(ItemCategoryList itemCategoryList) =>
      _$ItemCategoryListToJson(this);
}
