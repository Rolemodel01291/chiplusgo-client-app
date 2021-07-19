import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:infishare_client/models/coupon.dart';
import 'package:infishare_client/screens/commen_widgets/image_loader.dart';
import 'package:infishare_client/utils/clip_shadow_path.dart';

class CouponListTile extends StatelessWidget {
  final Coupon coupon;
  final VoidCallback onTapped;

  CouponListTile({@required this.coupon, this.onTapped});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapped,
      behavior: HitTestBehavior.opaque,
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            ClipShadowPath(
              clipper: CouponHalfCircleClipper(),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(6.0)),
                ),
                height: 120,
                child: Row(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(6.0),
                            bottomLeft: Radius.circular(6.0)),
                      ),
                      width: 8,
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                            top: 16, bottom: 16, left: 16, right: 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                AppLocalizations.of(context)
                                            .locale
                                            .languageCode ==
                                        'en'
                                    ? coupon.name
                                    : coupon.nameCn,
                                softWrap: true,
                                maxLines: 2,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Color(0xFF242424),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              AppLocalizations.of(context)
                                          .locale
                                          .languageCode ==
                                      'en'
                                  ? coupon.description
                                  : coupon.descriptionCn,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    '\$${coupon.price}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    '\$${coupon.oriPrice}',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFFACACAC),
                                        decoration: TextDecoration.lineThrough),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    '${coupon.getDiscount()}% OFF',
                                    style: TextStyle(
                                        color: Color(0xFF00AC5C),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(6.0),
                          bottomRight: Radius.circular(6.0)),
                      child: ImageLoader(
                        url: coupon.images.length > 0 ? coupon.images[0] : '',
                        width: 120,
                        height: 120,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 16,
              margin: EdgeInsets.only(right: 0, top: 4, bottom: 0),
              child: Text(
                AppLocalizations.of(context).translate('Sold') +
                    ' ${coupon.soldCnt}',
                style: TextStyle(color: Color(0xffacacac), fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CouponHalfCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 6);
    path.lineTo(0, (size.height / 2) - 8);
    path.arcToPoint(Offset(0, (size.height / 2) + 8),
        clockwise: true, radius: Radius.circular(8));
    path.lineTo(0, size.height - 6);
    path.arcToPoint(Offset(6, size.height),
        clockwise: false, radius: Radius.circular(6.0));
    path.lineTo(size.width - 6, size.height);
    path.arcToPoint(Offset(size.width, size.height - 6),
        clockwise: false, radius: Radius.circular(6.0));
    path.lineTo(size.width, 6);
    path.arcToPoint(Offset(size.width - 6, 0),
        clockwise: false, radius: Radius.circular(6.0));
    path.lineTo(6, 0);
    path.arcToPoint(Offset(0, 6),
        clockwise: false, radius: Radius.circular(6.0));
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
