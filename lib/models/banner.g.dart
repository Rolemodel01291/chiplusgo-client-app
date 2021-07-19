// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Banner _$BannerFromJson(Map json) {
  return Banner(
    color: json['Background'] as String,
    image: json['Image'] as String,
    url: json['Url'] as String,
    router: json['Router'] as String,
    arguments: (json['Argument'] as Map)?.map(
      (k, e) => MapEntry(k as String, e),
    ),
  );
}

Map<String, dynamic> _$BannerToJson(Banner instance) => <String, dynamic>{
      'Background': instance.color,
      'Image': instance.image,
      'Url': instance.url,
      'Router': instance.router,
      'Argument': instance.arguments,
    };

AppBanner _$AppBannerFromJson(Map json) {
  return AppBanner(
    topBanner: (json['Home_top_banners'] as List)
        ?.map((e) => e == null
            ? null
            : Banner.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList(),
    midBanner: (json['Home_mid1_banners'] as List)
        ?.map((e) => e == null
            ? null
            : Banner.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList(),
  );
}

Map<String, dynamic> _$AppBannerToJson(AppBanner instance) => <String, dynamic>{
      'Home_top_banners': instance.topBanner,
      'Home_mid1_banners': instance.midBanner,
    };
