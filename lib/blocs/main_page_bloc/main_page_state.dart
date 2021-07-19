import 'package:infishare_client/models/banner.dart';
import 'package:infishare_client/models/coupon_ticket.dart';
import 'package:infishare_client/models/models.dart';
import 'package:meta/meta.dart';

enum MainPageWifiStatus {
  Connecting,
  Connected,
  ConnectError,
}

@immutable
abstract class MainPageState {}

class BaseMainPageState extends MainPageState {
  final AppBanner appBanner;
  final List<CouponTicket> recentOrder;
  // final List<CouponThumbnail> bestSell;
  final List<CouponThumbnail> mostDiscount;
  // final List<CouponThumbnail> newToHere;
  // final List<Business> recmdBusiness;
  // final List<Business> newBusiness;
  // final List<Business> hottestBusiness;
  // final List<Business> nearbyBusiness;
  // final RestaurantCategory category;

  BaseMainPageState([
    this.appBanner,
    this.recentOrder,
    // this.bestSell,
    this.mostDiscount,
    // this.newToHere,
    // this.recmdBusiness,
    // this.newBusiness,
    // this.hottestBusiness,
    // this.nearbyBusiness,
    // this.category,
  ]);
}

class MainPageLoading extends MainPageState {
  @override
  String toString() => 'Main page loading';
}

class MainPageError extends MainPageState {
  final String errorMsg;

  MainPageError({this.errorMsg});

  @override
  String toString() => 'Main page error $errorMsg';
}

class MainPageLocationRequire extends MainPageState {
  @override
  String toString() => 'Location permission require';
}
