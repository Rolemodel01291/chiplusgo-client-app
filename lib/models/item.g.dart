// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map json) {
  return Item(
    json['Item'] as String,
    json['Item_cn'] as String,
    json['Amount'] as int,
    (json['Price'] as num)?.toDouble(),
    json['Count'] as int,
    json['Category'] as String,
    json['Variations'] as String,
    json['Image'] as String,
    (json['Modifiers'] as List)
        ?.map((e) => e == null
            ? null
            : Modifier.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList(),
  );
}

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'Item': instance.item,
      'Item_cn': instance.itemCn,
      'Amount': instance.amount,
      'Price': instance.price,
      'Count': instance.count,
      'Category': instance.category,
      'Variations': instance.variations,
      'Image': instance.imageUrl,
      'Modifiers': instance.modifiers?.map((e) => e?.toJson())?.toList(),
    };
