import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:intl/intl.dart';

part 'charge_history.g.dart';

@JsonSerializable()
class ChargeHistory extends Equatable {
  @JsonKey(name: 'Id')
  final String id;
  @JsonKey(name: 'Amount')
  final double amount;
  @JsonKey(name: 'Currency')
  final String currency;
  @JsonKey(name: 'Brand')
  final String brand;
  @JsonKey(name: 'Last4')
  final String lastFour;
  @JsonKey(name: 'Receipt_number')
  final String receiptNum;
  @JsonKey(name: 'Status')
  final String status;

  @JsonKey(ignore: true)
  DateTime startTime;

  ChargeHistory(
      {this.id,
      this.amount,
      this.currency,
      this.brand,
      this.lastFour,
      this.receiptNum,
      this.status});

  factory ChargeHistory.fromJson(Map<String, dynamic> json) {
    var history = _$ChargeHistoryFromJson(json);
    history.startTime =
        DateTime.fromMillisecondsSinceEpoch(json['StartTime'] * 1000);
    return history;
  }

  String getTimeString() {
    return DateFormat('MM/dd/yyyy hh:mm:ss').format(startTime);
  }

  Map<String, dynamic> toJson() => _$ChargeHistoryToJson(this);

  @override
  List<Object> get props => [id, amount, currency];
}
