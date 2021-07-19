import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infishare_client/blocs/blocs.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:infishare_client/models/models.dart';
import 'package:extended_image/extended_image.dart';
import 'package:infishare_client/screens/businessdetail/rating_bar.dart';
import 'package:infishare_client/screens/commen_widgets/coupon_business_listTile.dart';

class CheckOutCouponListViewItem extends StatelessWidget {
  final Business business;
  final Coupon coupon;

  const CheckOutCouponListViewItem(
      {Key key, @required this.business, this.coupon})
      : super(key: key);

  // custom the item boarder path
  Path _buildMyCardPath(width) {
    Path path = Path();
    // rectangular configure
    final double cornerRadius = 5;
    final double innerRadius = 8;
    final double topHalfHeight = 180;
    final double height = 250;

    // set the original point
    path.moveTo(cornerRadius, 0);
    // top line
    path.lineTo(width - cornerRadius, 0);
    // top right corner
    path.arcToPoint(Offset(width, cornerRadius),
        clockwise: true, radius: Radius.circular(cornerRadius));
    // top right half line
    path.lineTo(width, topHalfHeight - innerRadius);
    // right inner circle
    path.arcToPoint(Offset(width, topHalfHeight + innerRadius),
        clockwise: false, radius: Radius.circular(innerRadius));
    // bottom right half line
    path.lineTo(width, height - cornerRadius);
    // bottom right corner
    path.arcToPoint(Offset(width - cornerRadius, height),
        clockwise: true, radius: Radius.circular(cornerRadius));
    // bottom line
    path.lineTo(cornerRadius, height);
    // bottom left corner
    path.arcToPoint(Offset(0, height - cornerRadius),
        clockwise: true, radius: Radius.circular(cornerRadius));
    // bottom left half line
    path.lineTo(0, topHalfHeight + innerRadius);
    // left inner circle
    path.arcToPoint(Offset(0, topHalfHeight - innerRadius),
        clockwise: false, radius: Radius.circular(innerRadius));
    // top left half line
    path.lineTo(0, cornerRadius);
    // top left corner
    path.arcToPoint(Offset(cornerRadius, 0),
        clockwise: true, radius: Radius.circular(cornerRadius));
    path.close();
    return path;
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ShadowBoarderPainter(
          _buildMyCardPath(MediaQuery.of(context).size.width - 32)),
      child: ClipPath(
        clipper: SideSunkClipper(
            _buildMyCardPath(MediaQuery.of(context).size.width - 32)),
        child: ClipRRect(
          borderRadius: new BorderRadius.circular(4.0),
          // the whole coupon card
          child: Container(
              height: 250,
              width: MediaQuery.of(context).size.width - 32,
              color: Color(0xFFFDFDFD),
              child: Column(
                children: <Widget>[
                  // top half coupon card
                  Container(
                    width: MediaQuery.of(context).size.width - 32,
                    height: 180,
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          left: 0,
                          right: 0,
                          top: 0,
                          bottom: 0,
                          child: ExtendedImage.network(
                            business.images[0],
                            width: MediaQuery.of(context).size.width - 32,
                            //16:9
                            height: 180,
                            // use fit to fulfill the box
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          top: 0,
                          bottom: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment(0, 0.18),
                                  end: Alignment(0, 1),
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.8)
                                  ]),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 16,
                          bottom: 26,
                          child: Text(
                            AppLocalizations.of(context).locale.languageCode ==
                                    "en"
                                ? business.businessName['English']
                                : business.businessName['Chinese'],
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ),
                        Positioned(
                          left: 16,
                          bottom: 8,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                '${(business.rating * 5).toStringAsFixed(1)}',
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFFFCD300),
                                ),
                              ),
                              SizedBox(
                                width: 4.0,
                              ),
                              StaticRatingBar(
                                colorLight: Color(0xffFCD300),
                                rate: business.rating * 5,
                                size: 14,
                              ),
                              SizedBox(
                                width: 4.0,
                              ),
                              Text(
                                '(${business.reviewCount})',
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  // bottom half coupon card
                  Container(
                    height: 70,
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                AppLocalizations.of(context)
                                            .locale
                                            .languageCode ==
                                        "en"
                                    ? coupon.name
                                    : coupon.nameCn,
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF242424)),
                              ),
                              SizedBox(
                                height: 1,
                              ),
                              Text(
                                AppLocalizations.of(context)
                                            .locale
                                            .languageCode ==
                                        "en"
                                    ? coupon.description
                                    : coupon.descriptionCn,
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 12, color: Color(0xFF242424)),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    "\$${coupon.price}",
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF242424)),
                                  ),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Text(
                                    "\$${coupon.oriPrice}",
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 10,
                                        decoration: TextDecoration.lineThrough,
                                        color: Color(0xFFACACAC)),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Container(
                            height: 60,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(top: 8),
                                  child: Text(
                                    "\$",
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF242424),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 1,
                                ),
                                Container(
                                  child: Text(
                                    coupon.getPriceInt(),
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 50, color: Color(0xFF242424)),
                                  ),
                                ),
                                Container(
                                    padding: EdgeInsets.only(top: 7),
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          coupon.getPriceDecimal(),
                                          textAlign: TextAlign.left,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF242424),
                                          ),
                                        ),
                                        Text(
                                          "",
                                          textAlign: TextAlign.left,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 17,
                                            color: Color(0xFF242424),
                                          ),
                                        ),
                                      ],
                                    ))
                              ],
                            )),
                      ],
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}

class CouponSection extends StatelessWidget {
  final Business business;
  final Coupon coupon;
  final int amount;

  CouponSection({this.business, this.coupon, this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width,
      height: 346,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          CheckOutCouponListViewItem(
            coupon: coupon,
            business: business,
          ),
          SizedBox(
            height: 16,
          ),
          AmountPicker(
            amount: amount,
          ),
        ],
      ),
    );
  }
}

class AmountPicker extends StatelessWidget {
  final int amount;

  AmountPicker({this.amount});

  @override
  Widget build(BuildContext context) {
    final CheckOutBloc checkOutBloc = BlocProvider.of<CheckOutBloc>(context);
    return Container(
      width: 110,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            padding: EdgeInsets.all(0),
            icon: Icon(
              Icons.remove_circle_outline,
              size: 24,
              color: amount == 1 ? Colors.grey : Colors.black,
            ),
            onPressed: () {
              if (amount > 1) {
                HapticFeedback.lightImpact();
                checkOutBloc.add(DecreaseAmount());
              }
            },
          ),
          Text(
            "$amount",
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF242424),
            ),
          ),
          IconButton(
            padding: EdgeInsets.all(0),
            icon: Icon(
              Icons.add_circle_outline,
              size: 24,
              color: amount == 9 ? Colors.grey : Colors.black,
            ),
            onPressed: () {
              if (amount < 10) {
                HapticFeedback.lightImpact();
                checkOutBloc.add(IncreaseAmount());
              }
            },
          ),
        ],
      ),
    );
  }
}
