// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusinessCategory _$BusinessCategoryFromJson(Map json) {
  return BusinessCategory(
    name: json['Name_en'] as String,
    nameEn: json['Name_orig'] as String,
  );
}

Map<String, dynamic> _$BusinessCategoryToJson(BusinessCategory instance) =>
    <String, dynamic>{
      'Name_en': instance.name,
      'Name_orig': instance.nameEn,
    };

RestaurantCategory _$RestaurantCategoryFromJson(Map json) {
  return RestaurantCategory(
    cates: (json['All_styles'] as List)
        ?.map((e) => e == null
            ? null
            : BusinessCategory.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList(),
  );
}

Map<String, dynamic> _$RestaurantCategoryToJson(RestaurantCategory instance) =>
    <String, dynamic>{
      'All_styles': instance.cates,
    };
