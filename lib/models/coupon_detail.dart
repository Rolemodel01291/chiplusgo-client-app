import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'multichoose.dart';

part 'coupon_detail.g.dart';

@JsonSerializable(nullable: true, anyMap: true, explicitToJson: true)
class CouponRule extends Equatable {
  @JsonKey(name: 'Rule')
  final List<String> rules;
  @JsonKey(name: 'Available_date')
  final String availableDate;
  @JsonKey(name: 'Available_hours')
  final String availableHours;
  @JsonKey(name: 'Unavailable_date')
  final String unavailableDate;
  // @JsonKey(name: 'RuleHtml', nullable: true)
  // final String ruleHtml;
  // @JsonKey(name: 'RultHtml_cn', nullable: true)
  // final String rultHtmlCn;

  CouponRule(
    this.rules,
    this.availableDate,
    this.availableHours,
    this.unavailableDate,
    // this.ruleHtml,
    // this.rultHtmlCn,
  );

  factory CouponRule.fromJson(Map<String, dynamic> json) =>
      _$CouponRuleFromJson(json);

  Map<String, dynamic> toJson() => _$CouponRuleToJson(this);

  @override
  List<Object> get props => [
        rules,
        availableDate,
        availableHours,
        unavailableDate,
      ];
}

@JsonSerializable(anyMap: true, explicitToJson: true)
class CouponDetail extends Equatable {
  @JsonKey(name: 'Rules')
  final CouponRule rule;
  @JsonKey(name: 'Groups')
  List<MultiChoose> groups;

  CouponDetail(this.rule, this.groups);

  factory CouponDetail.fromJson(Map<String, dynamic> json) =>
      _$CouponDetailFromJson(json);

  Map<String, dynamic> toJson() => _$CouponDetailToJson(this);

  @override
  List<Object> get props => [groups, rule];
}
