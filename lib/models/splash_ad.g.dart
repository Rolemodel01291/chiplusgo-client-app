// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'splash_ad.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdsInfo _$AdsInfoFromJson(Map json) {
  return AdsInfo(
    json['Title'] as String,
    json['Title_cn'] as String,
    json['Descriptions'] as String,
    json['Descriptions_cn'] as String,
    (json['Image_url'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$AdsInfoToJson(AdsInfo instance) => <String, dynamic>{
      'Title': instance.title,
      'Title_cn': instance.titleCn,
      'Descriptions': instance.description,
      'Descriptions_cn': instance.descriptionCn,
      'Image_url': instance.images,
    };

SplashInfo _$SplashInfoFromJson(Map json) {
  return SplashInfo(
    json['Count'] as int,
    (json['Ads_info'] as List)
        ?.map((e) => e == null
            ? null
            : AdsInfo.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList(),
  );
}

Map<String, dynamic> _$SplashInfoToJson(SplashInfo instance) =>
    <String, dynamic>{
      'Count': instance.count,
      'Ads_info': instance.ads,
    };
