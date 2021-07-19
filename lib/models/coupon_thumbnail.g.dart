// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupon_thumbnail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CouponThumbnail _$CouponThumbnailFromJson(Map json) {
  return CouponThumbnail(
    json['Description'] as String,
    json['Description_cn'] as String,
    (json['Ori_price'] as num)?.toDouble(),
    (json['Tips'] as num)?.toDouble(),
    json['Type'] as String,
    json['Tot_cnts'] as int,
    json['Business_id'] as String,
    json['Title'] as String,
    json['Title_cn'] as String,
    (json['Price'] as num)?.toDouble(),
    json['Sold_cnts'] as int,
    (json['Tax'] as num)?.toDouble(),
    (json['Image'] as List)?.map((e) => e as String)?.toList(),
    (json['Business_name'] as Map)?.map(
      (k, e) => MapEntry(k as String, e as String),
    ),
    json['isActive'] as bool,
    (json['Validatity'] as Map)?.map(
      (k, e) => MapEntry(k as String, e as int),
    ),
    json['Added_time'] as int,
  );
}

Map<String, dynamic> _$CouponThumbnailToJson(CouponThumbnail instance) =>
    <String, dynamic>{
      'Description': instance.description,
      'Description_cn': instance.descriptionCn,
      'Ori_price': instance.oriPrice,
      'Tips': instance.tips,
      'Type': instance.type,
      'Tot_cnts': instance.totCounts,
      'Business_id': instance.businessId,
      'Title': instance.title,
      'Title_cn': instance.titleCn,
      'Price': instance.price,
      'Sold_cnts': instance.soldCnts,
      'Tax': instance.tax,
      'Image': instance.image,
      'Business_name': instance.businessName,
      'isActive': instance.isActive,
      'Validatity': instance.validatity,
      'Added_time': instance.addedTime,
    };
