// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'charge_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChargeHistory _$ChargeHistoryFromJson(Map json) {
  return ChargeHistory(
    id: json['Id'] as String,
    amount: (json['Amount'] as num)?.toDouble(),
    currency: json['Currency'] as String,
    brand: json['Brand'] as String,
    lastFour: json['Last4'] as String,
    receiptNum: json['Receipt_number'] as String,
    status: json['Status'] as String,
  );
}

Map<String, dynamic> _$ChargeHistoryToJson(ChargeHistory instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Amount': instance.amount,
      'Currency': instance.currency,
      'Brand': instance.brand,
      'Last4': instance.lastFour,
      'Receipt_number': instance.receiptNum,
      'Status': instance.status,
    };
