import 'package:infishare_client/models/coupon_thumbnail.dart';

class CouponWithRating {
  final double businessRate;
  final int rateCnt;
  final CouponThumbnail thumbnail;

  CouponWithRating({
    this.businessRate,
    this.rateCnt,
    this.thumbnail,
  });
}
