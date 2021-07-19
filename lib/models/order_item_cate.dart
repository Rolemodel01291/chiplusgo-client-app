import 'package:json_annotation/json_annotation.dart';

part 'order_item_cate.g.dart';

@JsonSerializable(anyMap: true)
class OrderItemCate {
  @JsonKey(name: 'Category')
  final String cate;
  @JsonKey(name: 'Category_cn')
  final String cateCn;

  OrderItemCate({
    this.cate,
    this.cateCn,
  });

  factory OrderItemCate.fromJson(Map<String, dynamic> json) =>
      _$OrderItemCateFromJson(json);

  Map<String, dynamic> toJson(OrderItemCate orderItemCate) =>
      _$OrderItemCateToJson(this);

  @override
  int get hashCode {
    return cate.hashCode;
  }

  bool operator ==(o) =>
      o is OrderItemCate && o.cate == cate && o.cateCn == cateCn;
}
