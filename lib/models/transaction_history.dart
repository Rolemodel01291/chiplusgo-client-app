import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:intl/intl.dart';
part 'transaction_history.g.dart';

@JsonSerializable()
class TransactionHistory extends Equatable {
  @JsonKey(name: 'Id')
  final String id;
  @JsonKey(name: 'ClientId')
  final String clientId;
  @JsonKey(name: 'BusinessId')
  final String businessId;
  @JsonKey(name: 'Create_date')
  final DateTime createDate;
  @JsonKey(name: 'Earned_point')
  final double earnedPoint;
  @JsonKey(name: 'Charge_cash')
  final double chargeCash;
  @JsonKey(name: 'OrderId')
  final String orderId;
  @JsonKey(name: 'Title')
  final String title;
  @JsonKey(name: 'Final_cash_balance')
  final double finalCashBalance;
  @JsonKey(name: 'Final_credit_balance')
  final double finalCreditBalance;
  @JsonKey(name: 'Final_point_balance')
  final double finalPointBalance;
  @JsonKey(name: 'Used_cash')
  final double usedCash;
  @JsonKey(name: 'Used_creditLine_balance')
  final double usedCreditlineBalance;
  @JsonKey(name: 'Used_point')
  final double usedPoint;
  @JsonKey(name: 'Type')
  final String type;
  @JsonKey(name: 'Subtotal')
  final double subTotal;
  @JsonKey(name: 'CashPointRate')
  final int cashPointRate;
  @JsonKey(name: 'Note')
  final String note;

  @JsonKey(ignore: true)
  DateTime startTime;

  TransactionHistory({
    this.id,
    this.clientId,
    this.businessId,
    this.createDate,
    this.earnedPoint,
    this.chargeCash,
    this.orderId,
    this.title,
    this.finalCashBalance,
    this.finalCreditBalance,
    this.finalPointBalance,
    this.usedCash,
    this.usedCreditlineBalance,
    this.usedPoint,
    this.type,
    this.subTotal,
    this.cashPointRate,
    this.note,
  });

  factory TransactionHistory.fromJson(Map<String, dynamic> json) {
    var history = _$TransactionHistoryFromJson(json);
    return history;
  }

  String getCreateTimeString() {
    // return DateFormat('yyyy-MM-dd hh:mm:ss a').format(createDate);
    return DateFormat.yMEd().add_jms().format(createDate);
  }

  Map<String, dynamic> toJson() => _$TransactionHistoryToJson(this);

  @override
  List<Object> get props => [
        id,
        clientId,
        businessId,
        createDate,
        earnedPoint,
        chargeCash,
        orderId,
        title,
        finalCashBalance,
        finalCreditBalance,
        finalPointBalance,
        usedCash,
        usedCreditlineBalance,
        usedPoint,
        type,
        subTotal,
        cashPointRate,
        note
      ];
}
