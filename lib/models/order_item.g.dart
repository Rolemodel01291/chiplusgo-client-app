// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItem _$OrderItemFromJson(Map json) {
  return OrderItem(
    json['Name'] as String,
    (json['Ingredients'] as List)?.map((e) => e as String)?.toList(),
    json['Category'] as String,
    json['Avaliable'] as bool,
    (json['Available_modifiers'] as List)?.map((e) => e as String)?.toList(),
    (json['Price'] as num)?.toDouble(),
    json['Image'] as String,
    (json['Tax_class'] as List)?.map((e) => e as String)?.toList(),
    (json['Added_date'] as num)?.toDouble(),
    json['Description'] as String,
    json['Name_cn'] as String,
    (json['Sold_cnt'] as num)?.toDouble(),
    json['Nutritions'] == null
        ? null
        : Nutrition.fromJson((json['Nutritions'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
    json['Category_cn'] as String,
    (json['Available_variations'] as List)?.map((e) => e as String)?.toList(),
    (json['Spicy_level'] as num)?.toDouble(),
    json['Business_id'] as String,
  );
}

Map<String, dynamic> _$OrderItemToJson(OrderItem instance) => <String, dynamic>{
      'Name': instance.name,
      'Ingredients': instance.ingredients,
      'Category': instance.category,
      'Avaliable': instance.avaliable,
      'Available_modifiers': instance.avaliableModifiers,
      'Price': instance.price,
      'Image': instance.image,
      'Tax_class': instance.taxClass,
      'Added_date': instance.addedDate,
      'Description': instance.description,
      'Name_cn': instance.nameCN,
      'Sold_cnt': instance.soldCnt,
      'Nutritions': instance.nutritions,
      'Category_cn': instance.categoryCN,
      'Available_variations': instance.availableVariations,
      'Spicy_level': instance.spicyLevel,
      'Business_id': instance.businessID,
    };
