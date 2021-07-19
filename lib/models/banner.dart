import 'package:json_annotation/json_annotation.dart';

part 'banner.g.dart';

@JsonSerializable(anyMap: true)
class Banner {
  @JsonKey(name: 'Background')
  final String color;
  @JsonKey(name: 'Image')
  final String image;
  @JsonKey(name: 'Url')
  final String url;
  @JsonKey(name: 'Router', nullable: true)
  final String router;
  @JsonKey(name: 'Argument', nullable: true)
  final Map<String, dynamic> arguments;

  Banner({
    this.color,
    this.image,
    this.url,
    this.router,
    this.arguments
  });

  factory Banner.fromJson(Map<String, dynamic> json) => _$BannerFromJson(json);

  Map<String, dynamic> toJson() => _$BannerToJson(this);
}

@JsonSerializable(anyMap: true)
class AppBanner {
  @JsonKey(name: 'Home_top_banners')
  final List<Banner> topBanner;
  @JsonKey(name: 'Home_mid1_banners')
  final List<Banner> midBanner;

  AppBanner({
    this.topBanner,
    this.midBanner,
  });

  factory AppBanner.fromJson(Map<String, dynamic> json) =>
      _$AppBannerFromJson(json);

  Map<String, dynamic> toJson() => _$AppBannerToJson(this);
}
