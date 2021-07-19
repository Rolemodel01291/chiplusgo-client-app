// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'charge_option.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChargeItem _$ChargeItemFromJson(Map json) {
  return ChargeItem(
    (json['Base_amount'] as num)?.toDouble(),
    (json['Bonus'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$ChargeItemToJson(ChargeItem instance) =>
    <String, dynamic>{
      'Base_amount': instance.baseAmount,
      'Bonus': instance.bouns,
    };

ChargeOption _$ChargeOptionFromJson(Map json) {
  return ChargeOption(
    (json['Charge_options'] as List)
        ?.map((e) => e == null
            ? null
            : ChargeItem.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList(),
    json['IsSpecial'] as bool,
  );
}

Map<String, dynamic> _$ChargeOptionToJson(ChargeOption instance) =>
    <String, dynamic>{
      'Charge_options': instance.options,
      'IsSpecial': instance.isSpecial,
    };
