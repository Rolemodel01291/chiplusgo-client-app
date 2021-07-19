// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item_cate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItemCate _$OrderItemCateFromJson(Map json) {
  return OrderItemCate(
    cate: json['Category'] as String,
    cateCn: json['Category_cn'] as String,
  );
}

Map<String, dynamic> _$OrderItemCateToJson(OrderItemCate instance) =>
    <String, dynamic>{
      'Category': instance.cate,
      'Category_cn': instance.cateCn,
    };
