// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Press _$PressFromJson(Map json) {
  return Press(
    title: json['Title'] as String,
    publisher: json['Publisher'] as String,
    content: json['Content'] as String,
    url: json['Url'] as String,
  );
}

Map<String, dynamic> _$PressToJson(Press instance) => <String, dynamic>{
      'Title': instance.title,
      'Publisher': instance.publisher,
      'Content': instance.content,
      'Url': instance.url,
    };

WifiInfo _$WifiInfoFromJson(Map json) {
  return WifiInfo(
    ssid: json['Ssid'] as String,
    password: json['Password'] as String,
  );
}

Map<String, dynamic> _$WifiInfoToJson(WifiInfo instance) => <String, dynamic>{
      'Ssid': instance.ssid,
      'Password': instance.password,
    };

OfferSum _$OfferSumFromJson(Map json) {
  return OfferSum(
    json['Type'] as String,
    json['Summary'] as String,
    json['Summary_cn'] as String,
  );
}

Map<String, dynamic> _$OfferSumToJson(OfferSum instance) => <String, dynamic>{
      'Type': instance.type,
      'Summary': instance.sum,
      'Summary_cn': instance.sumCn,
    };

Label _$LabelFromJson(Map json) {
  return Label(
    json['Group_buy'] as bool,
    json['Parking'] as bool,
    json['Wifi'] as bool,
  );
}

Map<String, dynamic> _$LabelToJson(Label instance) => <String, dynamic>{
      'Group_buy': instance.groupBuy,
      'Parking': instance.parking,
      'Wifi': instance.wifi,
    };

Membership _$MembershipFromJson(Map json) {
  return Membership(
    type: json['Type'] as String,
  );
}

Map<String, dynamic> _$MembershipToJson(Membership instance) =>
    <String, dynamic>{
      'Type': instance.type,
    };

Business _$BusinessFromJson(Map json) {
  return Business(
      json['Addr'] == null
          ? null
          : Address.fromJson((json['Addr'] as Map)?.map(
              (k, e) => MapEntry(k as String, e),
            )),
      json['Business'] as DocumentReference,
      (json['Business_name'] as Map)?.map(
        (k, e) => MapEntry(k as String, e as String),
      ),
      (json['Categories'] as List)?.map((e) => e as String)?.toList(),
      // json['Commerical_zone'] as String,
      json['Email'] as String,
      // json['Followed_num'] as int ?? 0,
      (json['image'] as List)?.map((e) => e as String)?.toList(),
      // (json['Labels'] as Map)?.map(
      //   (k, e) => MapEntry(k as String, e as bool),
      // ),
      json['Labels'] == null
          ? null
          : Label.fromJson((json['Labels'] as Map)?.map(
              (k, e) => MapEntry(k as String, e),
            )),
      json['Open_hours'] == null
          ? null
          : OpenHour.fromJson((json['Open_hours'] as Map)?.map(
              (k, e) => MapEntry(k as String, e),
            )),
      json['Phone'] as String,
      (json['Type'] as List)?.map((e) => e as String)?.toList(),
      json['Wifi'] == null
          ? null
          : WifiInfo.fromJson((json['Wifi'] as Map)?.map(
              (k, e) => MapEntry(k as String, e),
            )),
      (json['Price'] as num)?.toDouble(),
      (json['Offer_summary'] as List)
          ?.map((e) => e == null
              ? null
              : OfferSum.fromJson((e as Map)?.map(
                  (k, e) => MapEntry(k as String, e),
                )))
          ?.toList(),
      json['Business_article'] as String,
      json['Business_article_cn'] as String,
      (json['PN_Ratio'] as num)?.toDouble(),
      (json['_geoloc'] as Map)?.map(
        (k, e) => MapEntry(k as String, (e as num)?.toDouble()),
      ),
      json['Review_counts'] as int,
      (json['Story'] as Map)?.map(
        (k, e) => MapEntry(k as String, e as String),
      ),
      (json['Press'] as List)
          ?.map((e) => e == null
              ? null
              : Press.fromJson((e as Map)?.map(
                  (k, e) => MapEntry(k as String, e),
                )))
          ?.toList(),
      json['Business_logo'] as String,
      json['CashPointRate'] as int
      // json['Membership'] == null
      //     ? null
      //     : Membership.fromJson((json['Membership'] as Map)?.map(
      //         (k, e) => MapEntry(k as String, e),
      //       )),
      );
}

Map<String, dynamic> _$BusinessToJson(Business instance) => <String, dynamic>{
      'Addr': instance.address,
      'Business': instance.business,
      'Business_name': instance.businessName,
      'Categories': instance.categories,
      // 'Commerical_zone': instance.commericalZone,
      'Email': instance.email,
      // 'Followed_num': instance.followedNum,
      'image': instance.images,
      'Labels': instance.labels,
      'Open_hours': instance.openHour,
      'Phone': instance.phone,
      'Type': instance.businessType,
      'Wifi': instance.wifiInfo,
      'Price': instance.price,
      'Offer_summary': instance.offerSums,
      'Business_article': instance.businessArticle,
      'Business_article_cn': instance.businessArticleCn,
      'PN_Ratio': instance.rating,
      '_geoloc': instance.location,
      'Review_counts': instance.reviewCount,
      'Story': instance.story,
      'Press': instance.press,
      'Business_logo': instance.logo,
      "CashPointRate": instance.cashPointRate
      // 'Membership': instance.membership,
    };
