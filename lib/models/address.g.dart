// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Address _$AddressFromJson(Map json) {
  return Address(
    city: json['City'] as String,
    state: json['State'] as String,
    street: json['Street'] as String,
    zipCode: json['Zipcode'] as String,
  );
}

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'City': instance.city,
      'State': instance.state,
      'Street': instance.street,
      'Zipcode': instance.zipCode,
    };
