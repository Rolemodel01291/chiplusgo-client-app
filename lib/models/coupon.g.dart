// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Coupon _$CouponFromJson(Map json) {
  return Coupon(
    json['Description'] as String,
    json['Description_cn'] as String,
    // json['Details'] == null
    //     ? null
    //     : CouponDetail.fromJson((json['Details'] as Map)?.map(
    //         (k, e) => MapEntry(k as String, e),
    //       )),
    (json['Item'] as List)
            ?.map((e) =>
                (e as Map)?.map((k, e) => MapEntry(k as String, e as String)))
            ?.toList() ??
        [],
    json['Rules'] == null
        ? null
        : CouponRule.fromJson((json['Rules'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
    (json['Image'] as List)?.map((e) => e as String)?.toList() ?? [],
    json['Title'] as String,
    json['Title_cn'] as String,
    (json['Original_price'] as num)?.toDouble(),
    (json['Price'] as num)?.toDouble(),
    // json['Type'] as String,
    (json['Business_name'] as List)
            ?.map((e) =>
                (e as Map)?.map((k, e) => MapEntry(k as String, e as String)))
            ?.toList() ??
        [],
    json['Sold_cnts'] as int,
    json['Quantity'] as int,
    // json['Tot_cnts'] as int,
    (json['Tax'] as num)?.toDouble(),

    // (json['Tips'] as num)?.toDouble(),
    (json['BusinessId'] as List)?.map((e) => e as String)?.toList() ?? [],
    (json['Business'] as List)?.map((e) => e as DocumentReference)?.toList() ??
        [],
    // json['BusinessId'] as List<String>,
    json['IsActive'] as bool,
  );
}

Map<String, dynamic> _$CouponToJson(Coupon instance) => <String, dynamic>{
      'Description': instance.description,
      'Description_cn': instance.descriptionCn,
      // 'Details': instance.detail,
      'Item': instance.items,
      'Rules': instance.rule,
      'Image': instance.images,
      'Title': instance.name,
      'Title_cn': instance.nameCn,
      'Original_price': instance.oriPrice,
      'Price': instance.price,
      // 'Type': instance.couponType,
      'Business_name': instance.businessName,
      'Sold_cnts': instance.soldCnt,
      "Quantity": instance.quantity,
      // 'Tot_cnts': instance.totCnt,
      'BusinessId': instance.businessId,

      'Tax': instance.tax,
      // 'Tips': instance.tips,
      'IsActive': instance.isActivce,
    };
