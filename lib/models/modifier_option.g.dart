// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modifier_option.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModifierOptions _$ModifierOptionsFromJson(Map json) {
  return ModifierOptions(
    json['Name'] as String,
    json['Name_cn'] as String,
    (json['Price_offset'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$ModifierOptionsToJson(ModifierOptions instance) =>
    <String, dynamic>{
      'Name': instance.name,
      'Name_cn': instance.nmaeCn,
      'Price_offset': instance.priceOffset,
    };
