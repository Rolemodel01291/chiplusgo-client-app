import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:intl/intl.dart';

part 'charge_option.g.dart';

@JsonSerializable()
class ChargeItem {
  @JsonKey(name: 'Base_amount')
  final double baseAmount;
  @JsonKey(name: 'Bonus')
  final double bouns;

  ChargeItem(this.baseAmount, this.bouns);

  factory ChargeItem.fromJson(Map<String, dynamic> json) =>
      _$ChargeItemFromJson(json);

  Map<String, dynamic> toJson() => _$ChargeItemToJson(this);
}

@JsonSerializable()
class ChargeOption {
  @JsonKey(name: 'Charge_options')
  final List<ChargeItem> options;
  @JsonKey(name: 'IsSpecial')
  final bool isSpecial;
  @JsonKey(ignore: true)
  DateTime startDate;
  @JsonKey(ignore: true)
  DateTime endDate;

  ChargeOption(this.options, this.isSpecial);

  factory ChargeOption.fromJson(Map<String, dynamic> json) {
    var option = _$ChargeOptionFromJson(json);
    option.startDate = (json['Validatity']['Start_date'] as Timestamp).toDate();
    option.endDate = (json['Validatity']['End_date'] as Timestamp).toDate();
    return option;
  }

  String getStartDate() {
    return DateFormat('MM/dd/yyyy hh:mm:ss').format(startDate);
  }

  String getEndDate() {
    return DateFormat('MM/dd/yyyy hh:mm:ss').format(endDate);
  }

  Map<String, dynamic> toJson() => _$ChargeOptionToJson(this);
}
