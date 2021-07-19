import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'coupon_detail.dart';
import 'package:intl/intl.dart';

part 'coupon.g.dart';

class CouponType {
  static const String COUPON = 'GroupBuy';
  static const String VOUCHER = 'Voucher';
}

@JsonSerializable(anyMap: true)
class Coupon {
  @JsonKey(name: 'Description')
  final String description;
  @JsonKey(name: 'Description_cn')
  final String descriptionCn;
  // @JsonKey(name: 'Details')
  // CouponDetail detail;
  @JsonKey(name: 'Item', defaultValue: [])
  final List<Map<String, String>> items;
  @JsonKey(name: 'Rules')
  CouponRule rule;
  @JsonKey(name: 'Image', defaultValue: [])
  final List<String> images;
  @JsonKey(name: 'Title')
  final String name;
  @JsonKey(name: 'Title_cn')
  final String nameCn;
  @JsonKey(name: 'Original_price')
  final double oriPrice;
  @JsonKey(name: 'Price')
  final double price;
  // @JsonKey(name: 'Type')
  // final String couponType;
  @JsonKey(name: 'Business_name')
  final List<Map<String, String>> businessName;
  @JsonKey(name: 'Sold_cnts')
  final int soldCnt;
  @JsonKey(name: 'Quantity')
  final int quantity;
  // @JsonKey(name: 'Tot_cnts')
  // final int totCnt;
  @JsonKey(name: 'BusinessId')
  final List<String> businessId;
  @JsonKey(name: 'Tax')
  final double tax;
  // @JsonKey(name: 'Tips')
  // final double tips;
  @JsonKey(name: 'IsActive')
  final bool isActivce;

  @JsonKey(name: 'Business')
  List<DocumentReference> businessRef;
  @JsonKey(ignore: true)
  DateTime start;
  @JsonKey(ignore: true)
  DateTime end;
  @JsonKey(ignore: true)
  String couponId;
  @JsonKey(ignore: true)
  Locale locale = Locale('en');

  Coupon(
      this.description,
      this.descriptionCn,
      // this.detail,
      this.items,
      this.rule,
      this.images,
      this.name,
      this.nameCn,
      this.oriPrice,
      this.price,
      // this.couponType,
      this.businessName,
      this.soldCnt,
      this.quantity,
      // this.totCnt,
      this.tax,
      // this.tips,
      this.businessId,
      this.businessRef,
      this.isActivce);

  factory Coupon.fromJson(Map<String, dynamic> json) {
    var coupon = _$CouponFromJson(json);

    // coupon.businessRef = json['Business'] as List<DocumentReference>;
    coupon.start = (json['Validatity']['Start_date'] as Timestamp).toDate();
    coupon.end = (json['Validatity']['End_date'] as Timestamp).toDate();

    return coupon;
  }

  Map<String, dynamic> toJson() => _$CouponToJson(this);

  String getDiscount() {
    return (((oriPrice - price) / oriPrice) * 100).toStringAsFixed(0);
  }

  String getTitle() {
    return locale.languageCode == 'en' ? name : nameCn;
  }

  String getDescription() {
    return locale.languageCode == 'en' ? description : descriptionCn;
  }

  String getBusinessName() {
    return locale.languageCode == 'en'
        ? businessName[0]['English']
        : businessName[0]['Chinese'];
  }

  String getVaildDate() {
    return DateFormat('MM/dd/yyyy').format(start.toLocal()) +
        '~' +
        DateFormat('MM/dd/yyyy').format(end.toLocal());
  }

  DateTime getEndDate() {
    return end;
  }

  String getDiscountInt() {
    return (oriPrice - price).toStringAsFixed(2).split('.')[0];
  }

  String getDiscountDecimal() {
    return (oriPrice - price).toStringAsFixed(2).split('.')[1];
  }

  String getPriceInt() {
    return price.toStringAsFixed(2).split('.')[0];
  }

  String getPriceDecimal() {
    return price.toStringAsFixed(2).split('.')[1];
  }
}
