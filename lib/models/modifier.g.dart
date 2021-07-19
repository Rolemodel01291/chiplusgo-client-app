// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modifier.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Modifier _$ModifierFromJson(Map json) {
  return Modifier(
    multiChoices: json['Multi_choices'] as bool,
    name: json['Name'] as String,
    nameCn: json['Name_cn'] as String,
    options: (json['Options'] as List)
        ?.map((e) => e == null
            ? null
            : ModifierOptions.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList(),
  );
}

Map<String, dynamic> _$ModifierToJson(Modifier instance) => <String, dynamic>{
      'Name': instance.name,
      'Name_cn': instance.nameCn,
      'Multi_choices': instance.multiChoices,
      'Options': instance.options,
    };
