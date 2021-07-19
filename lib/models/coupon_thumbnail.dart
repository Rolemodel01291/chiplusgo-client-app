import 'package:json_annotation/json_annotation.dart';

part 'coupon_thumbnail.g.dart';

@JsonSerializable(nullable: true, anyMap: true)
class CouponThumbnail {
  @JsonKey(name: 'Description')
  final String description;
  @JsonKey(name: 'Description_cn')
  final String descriptionCn;
  @JsonKey(name: 'Ori_price')
  final double oriPrice;
  @JsonKey(name: 'Tips')
  final double tips;
  @JsonKey(name: 'Type')
  final String type;
  @JsonKey(name: 'Tot_cnts')
  final int totCounts;
  @JsonKey(name: 'Business_id')
  final String businessId;
  @JsonKey(name: 'Title')
  final String title;
  @JsonKey(name: 'Title_cn')
  final String titleCn;
  @JsonKey(name: 'Price')
  final double price;
  @JsonKey(name: 'Sold_cnts')
  final int soldCnts;
  @JsonKey(name: 'Tax')
  final double tax;
  @JsonKey(name: 'Image')
  final List<String> image;
  @JsonKey(name: 'Business_name')
  final Map<String, String> businessName;
  @JsonKey(name: 'isActive')
  final bool isActive;
  @JsonKey(name: 'Validatity')
  final Map<String, int> validatity;
  @JsonKey(name: 'Added_time')
  final int addedTime;

  @JsonKey(ignore: true)
  String couponId;

  CouponThumbnail(
      this.description,
      this.descriptionCn,
      this.oriPrice,
      this.tips,
      this.type,
      this.totCounts,
      this.businessId,
      this.title,
      this.titleCn,
      this.price,
      this.soldCnts,
      this.tax,
      this.image,
      this.businessName,
      this.isActive,
      this.validatity,
      this.addedTime);

  factory CouponThumbnail.fromJson(Map<String, dynamic> json) =>
      _$CouponThumbnailFromJson(json);

  Map<String, dynamic> toJson() => _$CouponThumbnailToJson(this);

  String getPriceInt() {
    return price.toStringAsFixed(2).split('.')[0];
  }

  String getPriceDecimal() {
    return price.toStringAsFixed(2).split('.')[1];
  }

  String getDiscountInt() {
    return (oriPrice - price).toStringAsFixed(2).split('.')[0];
  }

  String getDiscountDecimal() {
    return (oriPrice - price).toStringAsFixed(2).split('.')[1];
  }
}
