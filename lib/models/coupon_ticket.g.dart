// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupon_ticket.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CouponTicket _$CouponTicketFromJson(Map json) {
  return CouponTicket(
    // json['Details'] == null
    //     ? null
    //     : CouponDetail.fromJson((json['Details'] as Map)?.map(
    //         (k, e) => MapEntry(k as String, e),
    //       )),
    (json['Used_Business_name'] as List)
            ?.map((e) =>
                (e as Map)?.map((k, e) => MapEntry(k as String, e as String)))
            ?.toList() ??
        [],
    json['Description'] as String,
    json['Description_cn'] as String,
    (json['Item'] as List)
            ?.map((e) =>
                (e as Map)?.map((k, e) => MapEntry(k as String, e as String)))
            ?.toList() ??
        [],
    (json['Image'] as List)?.map((e) => e as String)?.toList() ?? [],

    json['Rules'] == null
        ? null
        : CouponRule.fromJson((json['Rules'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
    json['Title'] as String,

    json['Title_cn'] as String,
    (json['Original_price'] as num)?.toDouble(),
    (json['Price'] as num)?.toDouble(),
    // json['Type'] as String,
    (json['BusinessId'] as List)?.map((e) => e as String)?.toList() ?? [],
    // json['Receipt_num'] as String,
    json['Used'] as bool,
    json['ClientId'] as String,
    json['CouponId'] as String,
    json['CouponTicketId'] as String,

    // json['Ticket_num'] as String,
    (json['Business_name'] as List)
            ?.map((e) =>
                (e as Map)?.map((k, e) => MapEntry(k as String, e as String)))
            ?.toList() ??
        [],

    // (json['Tips'] as num)?.toDouble(),
    (json['Tax'] as num)?.toDouble(),
    // )..picked = json['Picked'] as bool;
  );
}

Map<String, dynamic> _$CouponTicketToJson(CouponTicket instance) =>
    <String, dynamic>{
      'Description': instance.description,
      'Description_cn': instance.descriptionCn,
      'Used_Business_name': instance.usedBusinessName,
      // 'Details': instance.detail?.toJson(),
      'Item': instance.items,
      'Image': instance.images,
      'Rules': instance.rule,
      'Title': instance.name,
      'Title_cn': instance.nameCn,
      'Original_price': instance.oriPrice,
      'Price': instance.price,
      // 'Type': instance.couponType,
      'Business_name': instance.businessName,
      'BusinessId': instance.businessId,
      // 'Receipt_num': instance.receiptNum,
      'Used': instance.used,
      'ClientId': instance.clientId,
      'CouponId': instance.couponId,
      'CouponTicketId': instance.couponTicketId,
      // 'Picked': instance.picked,
      // 'Ticket_num': instance.ticketNum,
      // 'Tips': instance.tips,
      'Tax': instance.tax,
    };
