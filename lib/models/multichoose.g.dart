// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multichoose.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MultiChoose _$MultiChooseFromJson(Map json) {
  return MultiChoose(
    json['Name'] as String,
    json['Name_cn'] as String,
    (json['Items'] as List)
        ?.map((e) => e == null
            ? null
            : Item.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList(),
    json['Pick'] as int,
    json['Total'] as int,
  );
}

Map<String, dynamic> _$MultiChooseToJson(MultiChoose instance) =>
    <String, dynamic>{
      'Total': instance.total,
      'Pick': instance.pick,
      'Items': instance.items?.map((e) => e?.toJson())?.toList(),
      'Name': instance.name,
      'Name_cn': instance.nameCn,
    };
