// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_cate_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemCategoryList _$ItemCategoryListFromJson(Map json) {
  return ItemCategoryList(
    category: (json['Categories'] as List)
        ?.map((e) => e == null
            ? null
            : OrderItemCate.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList(),
  );
}

Map<String, dynamic> _$ItemCategoryListToJson(ItemCategoryList instance) =>
    <String, dynamic>{
      'Categories': instance.category,
    };
