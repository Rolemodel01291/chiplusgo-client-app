// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nutrition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Nutrition _$NutritionFromJson(Map json) {
  return Nutrition(
    json['Calories_from_fat'] as String,
    json['etc'] as String,
    json['Calories'] as String,
  );
}

Map<String, dynamic> _$NutritionToJson(Nutrition instance) => <String, dynamic>{
      'Calories_from_fat': instance.caloriesFromFat,
      'etc': instance.etc,
      'Calories': instance.calories,
    };
