import 'package:json_annotation/json_annotation.dart';

part 'splash_ad.g.dart';


@JsonSerializable()
class AdsInfo {
  @JsonKey(name: 'Title')
  final String title;
  @JsonKey(name: 'Title_cn')
  final String titleCn;
  @JsonKey(name: 'Descriptions')
  final String description;
  @JsonKey(name: 'Descriptions_cn')
  final String descriptionCn;
  @JsonKey(name: 'Image_url')
  final List<String> images;

  AdsInfo(this.title, this.titleCn, this.description, this.descriptionCn, this.images);

  factory AdsInfo.fromJson(Map<String, dynamic> json) => _$AdsInfoFromJson(json);

  Map<String, dynamic> toJson() => _$AdsInfoToJson(this);
}

@JsonSerializable()
class SplashInfo {
  @JsonKey(name: 'Count')
  final int count;
  @JsonKey(name: 'Ads_info')
  final List<AdsInfo> ads;

  SplashInfo(this.count, this.ads);

  factory SplashInfo.fromJson(Map<String, dynamic> json) => _$SplashInfoFromJson(json);

  Map<String , dynamic> toJson() => _$SplashInfoToJson(this);
}