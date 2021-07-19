// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupon_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CouponRule _$CouponRuleFromJson(Map json) {
  return CouponRule(
    (json['Rule'] as List)?.map((e) => e as String)?.toList(),
    json['Available_date'] as String,
    json['Available_hours'] as String,
    json['Unavailable_date'] as String,
    // json['RuleHtml'] as String,
    // json['RultHtml_cn'] as String,
  );
}

Map<String, dynamic> _$CouponRuleToJson(CouponRule instance) =>
    <String, dynamic>{
      'Rule': instance.rules,
      'Available_date': instance.availableDate,
      'Available_hours': instance.availableHours,
      'Unavailable_date': instance.unavailableDate,
      // 'RuleHtml': instance.ruleHtml,
      // 'RultHtml_cn': instance.rultHtmlCn,
    };

CouponDetail _$CouponDetailFromJson(Map json) {
  return CouponDetail(
    json['Rules'] == null
        ? null
        : CouponRule.fromJson((json['Rules'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
    (json['Groups'] as List)
        ?.map((e) => e == null
            ? null
            : MultiChoose.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList(),
  );
}

Map<String, dynamic> _$CouponDetailToJson(CouponDetail instance) =>
    <String, dynamic>{
      'Rules': instance.rule?.toJson(),
      'Groups': instance.groups?.map((e) => e?.toJson())?.toList(),
    };
