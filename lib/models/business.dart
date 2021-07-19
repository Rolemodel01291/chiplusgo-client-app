import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'open_hours.dart';
import 'address.dart';
import 'dart:math' show cos, sqrt, asin;

part 'business.g.dart';

@JsonSerializable(anyMap: true)
class Press {
  @JsonKey(name: 'Title')
  final String title;
  @JsonKey(name: 'Publisher')
  final String publisher;
  @JsonKey(name: 'Content')
  final String content;
  @JsonKey(name: 'Url')
  final String url;

  Press({this.title, this.publisher, this.content, this.url});

  factory Press.fromJson(Map<String, dynamic> json) => _$PressFromJson(json);

  Map<String, dynamic> toJson() => _$PressToJson(this);
}

@JsonSerializable(anyMap: true)
class WifiInfo {
  @JsonKey(name: 'Ssid')
  final String ssid;
  @JsonKey(name: 'Password')
  final String password;

  WifiInfo({this.ssid, this.password});

  factory WifiInfo.fromJson(Map<String, dynamic> json) =>
      _$WifiInfoFromJson(json);

  Map<String, dynamic> toJson() => _$WifiInfoToJson(this);
}

@JsonSerializable(anyMap: true)
class OfferSum {
  @JsonKey(name: 'Type')
  final String type;
  @JsonKey(name: 'Summary')
  final String sum;
  @JsonKey(name: 'Summary_cn')
  final String sumCn;

  OfferSum(this.type, this.sum, this.sumCn);

  factory OfferSum.fromJson(Map<String, dynamic> json) =>
      _$OfferSumFromJson(json);

  Map<String, dynamic> toJson() => _$OfferSumToJson(this);
}

class Label {
  @JsonKey(name: 'Group_buy')
  final bool groupBuy;
  @JsonKey(name: 'Parking')
  final bool parking;
  @JsonKey(name: 'Wifi')
  final bool wifi;

  Label(this.groupBuy, this.parking, this.wifi);

  factory Label.fromJson(Map<String, dynamic> json) => _$LabelFromJson(json);

  Map<String, dynamic> toJson() => _$LabelToJson(this);
}

@JsonSerializable(anyMap: true)
class Membership {
  @JsonKey(name: 'Type')
  final String type;

  Membership({this.type});

  factory Membership.fromJson(Map<String, dynamic> json) =>
      _$MembershipFromJson(json);

  Map<String, dynamic> toJson() => _$MembershipToJson(this);
}

@JsonSerializable(nullable: true, anyMap: true)
class Business extends Equatable {
  @JsonKey(name: 'Addr')
  final Address address;
  @JsonKey(name: 'Business')
  final DocumentReference business;
  @JsonKey(name: 'Business_name')
  final Map<String, String> businessName;
  @JsonKey(name: 'Categories')
  final List<String> categories;
  // @JsonKey(name: 'Commerical_zone')
  // final String commericalZone;
  @JsonKey(name: 'Email')
  final String email;
  // @JsonKey(name: 'Followed_num', defaultValue: 0)
  // final int followedNum;
  @JsonKey(name: 'image')
  final List<String> images;
  // @JsonKey(name: 'Labels')
  // final Map<bool, bool> labels;
  @JsonKey(name: 'Labels')
  final Label labels;
  @JsonKey(name: 'Open_hours')
  final OpenHour openHour;
  @JsonKey(name: 'Phone')
  final String phone;
  @JsonKey(name: 'Type')
  final List<String> businessType;
  @JsonKey(name: 'Wifi')
  final WifiInfo wifiInfo;
  @JsonKey(name: 'Price')
  final double price;
  @JsonKey(name: 'Offer_summary', nullable: true)
  final List<OfferSum> offerSums;
  @JsonKey(name: 'Business_article', nullable: true)
  final String businessArticle;
  @JsonKey(name: 'Business_article_cn', nullable: true)
  final String businessArticleCn;
  @JsonKey(name: 'PN_Ratio')
  final double rating;
  @JsonKey(name: '_geoloc')
  Map<String, double> location;
  @JsonKey(name: 'Review_counts')
  final int reviewCount;
  @JsonKey(name: 'Story', nullable: true)
  final Map<String, String> story;
  @JsonKey(name: 'Press', nullable: true)
  final List<Press> press;
  @JsonKey(name: 'Business_logo', nullable: true)
  final String logo;
  @JsonKey(name: 'CashPointRate')
  final int cashPointRate;
  // @JsonKey(name: 'Membership')
  // final Membership membership;
  @JsonKey(ignore: true)
  String businessId;
  // @JsonKey(ignore: true)
  // String distance;
  // @JsonKey(ignore: true)
  // String priceLabel;
  // @JsonKey(ignore: true)
  // String memberShipType;
  // @JsonKey(ignore: true)
  // double distanceInKm;

  Business(
      this.address,
      this.business,
      this.businessName,
      this.categories,
      // this.commericalZone,
      this.email,
      // this.followedNum,
      this.images,
      this.labels,
      this.openHour,
      this.phone,
      this.businessType,
      this.wifiInfo,
      this.price,
      this.offerSums,
      this.businessArticle,
      this.businessArticleCn,
      this.rating,
      this.location,
      this.reviewCount,
      this.story,
      this.press,
      this.logo,
      this.cashPointRate
      // this.membership,
      );

  factory Business.fromJson(Map<String, dynamic> json) {
    Business business = _$BusinessFromJson(json);
    // if (business.price == 1.0) {
    //   business.priceLabel = '\$';
    // } else if (business.price == 2.0) {
    //   business.priceLabel = '\$\$';
    // } else if (business.price == 3.0) {
    //   business.priceLabel = '\$\$\$';
    // } else {
    //   business.priceLabel = '\$\$\$\$';
    // }
    // switch (business.price) {
    //   case 1:
    //     business.priceLabel = '\$';
    //     break;
    //   case 2:
    //     business.priceLabel = '\$\$';
    //     break;
    //   case 3:
    //     business.priceLabel = '\$\$\$';
    //     break;
    //   case 4:
    //     business.priceLabel = '\$\$\$\$';
    //     break;
    //   default:
    // }
    // business.memberShipType =
    //     business.membership == null ? '' : business.membership.type;
    return business;
  }

  Map<String, dynamic> toJson() => _$BusinessToJson(this);

  void calculateDistance(double lat1, double lon1) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((location['lat'] - lat1) * p) / 2 +
        c(lat1 * p) *
            c(location['lat'] * p) *
            (1 - c((location['lng'] - lon1) * p)) /
            2;
    // var tmp = 12742 * asin(sqrt(a));
    // this.distanceInKm = tmp;
    // if (tmp >= 1) {
    //   this.distance = tmp.toStringAsFixed(2) + ' km';
    // } else {
    //   this.distance = (tmp * 1000).toStringAsFixed(1) + ' m';
    // }
  }

  double getRealDistance(double lati, double long) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((location['lat'] - lati) * p) / 2 +
        c(lati * p) *
            c(location['lat'] * p) *
            (1 - c((location['lng'] - long) * p)) /
            2;
    var tmp = 12742 * asin(sqrt(a));
    return tmp;
  }

  String getDisplayAddress() {
    return address.getOneLineDisplayAddress();
  }

  String getTwoLineDisplayAddress() {
    return address.street + ',\n' + address.city + ', ' + address.state;
  }

  String getLocationFilterString() {
    var lat = location['lat'];
    var lng = location['lng'];
    print('$lat, $lng');
    return '$lat, $lng';
  }

  String getCategory() {
    return categories[0];
  }

  //* String used for apple map
  String getMapQueryString() {
    String add = address.street.replaceAll(' ', '+');
    return add + ',+${address.city},+${address.state}';
  }

  @override
  List<Object> get props => [
        this.address,
        this.business,
        this.businessName,
        this.categories,
        // this.commericalZone,
        this.email,
        // this.followedNum,
        this.images,
        this.labels,
        this.openHour,
        this.phone,
        this.businessType,
        this.wifiInfo,
        this.price,
        this.offerSums,
        this.businessArticle,
        this.businessArticleCn,
        this.rating,
        this.location,
        this.reviewCount,
        this.story,
        this.press,
        this.logo,
        this.cashPointRate
      ];
}
