// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map json) {
  return User(
      avatar: json['Avatar'] as String,
      balance: (json['Balance'] as num)?.toDouble(),
      creditlineBalance: (json['CreditLine_balance']?.toDouble()),
      customerId: json['Customer_id'] as String,
      email: json['Email'] as String,
      name: json['Name'] as String,
      phone: json['Phone'] as String,
      point: json['Point'] as int,
      pointsBalance: json['Points_balance'] as int,
      referralCode: json['Referral_code'] as String,
      referredCode: json['Refered_code'] as String,
      addressLine1: json['AddressLine1'] as String,
      addressLine2: json['AddressLine2'] as String,
      city: json['City'] as String,
      signupType: json['SignupType'] as String);
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'Balance': instance.balance,
      'CreditLine_balance': instance.creditlineBalance,
      'Customer_id': instance.customerId,
      'Avatar': instance.avatar,
      'Email': instance.email,
      'Name': instance.name,
      'Phone': instance.phone,
      'Point': instance.point,
      'Points_balance': instance.pointsBalance,
      'Referral_code': instance.referralCode,
      'Refered_code': instance.referredCode,
      'AddressLine1': instance.addressLine1,
      'AddressLine2': instance.addressLine2,
      'City': instance.city,
      'SignupType': instance.signupType
    };
