// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionHistory _$TransactionHistoryFromJson(Map json) {
  return TransactionHistory(
      id: json['Id'] as String,
      clientId: json['ClientId'] as String,
      businessId: json['BusinessId'] as String,
      createDate: (json['Create_date'] as Timestamp)?.toDate(),
      earnedPoint: (json['Earned_point'] as num)?.toDouble(),
      chargeCash: (json['Charge_cash'] as num)?.toDouble(),
      orderId: json['OrderId'] as String,
      title: json['Title'] as String,
      finalCashBalance: (json['Final_cash_balance'] as num)?.toDouble(),
      finalCreditBalance: (json['Final_credit_balance'] as num)?.toDouble(),
      finalPointBalance: (json['Final_point_balance'] as num)?.toDouble(),
      usedCash: (json['Used_cash'] as num)?.toDouble(),
      usedCreditlineBalance:
          (json['Used_creditLine_balance'] as num)?.toDouble(),
      usedPoint: (json['Used_point'] as num)?.toDouble(),
      type: json['Type'] as String,
      subTotal: (json['Subtotal'] as num)?.toDouble(),
      cashPointRate: json['CashPointRate'] as int,
      note: json['Note'] as String);
}

Map<String, dynamic> _$TransactionHistoryToJson(TransactionHistory instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'ClientId': instance.clientId,
      'BusinessId': instance.businessId,
      'Create_date': instance.createDate,
      'Earned_point': instance.earnedPoint,
      'Charge_cash': instance.chargeCash,
      'OrderId': instance.orderId,
      'Title': instance.title,
      'Final_cash_balance': instance.finalCashBalance,
      'Final_credit_balance': instance.finalCreditBalance,
      'Final_point_balance': instance.finalPointBalance,
      'Used_cash': instance.usedCash,
      'Used_creditLine_balance': instance.usedCreditlineBalance,
      'Used_point': instance.usedPoint,
      'Type': instance.type,
      'Subtotal': instance.subTotal,
      'CashPointRate': instance.cashPointRate,
      'Note': instance.note
    };
