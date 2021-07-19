import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:infishare_client/models/models.dart';
import 'package:infishare_client/screens/commen_widgets/utils.dart';
import 'package:intl/intl.dart';

import 'home_coupons_section.dart';

class ReoderListViewSection extends StatefulWidget {
  final List<CouponTicket> coupons;

  ReoderListViewSection({Key key, @required this.coupons}) : super(key: key);

  @override
  _ReoderListViewSectionState createState() => _ReoderListViewSectionState();
}

class _ReoderListViewSectionState extends State<ReoderListViewSection>
    with TickerProviderStateMixin {
  ScrollController _controller;
  ScrollPhysics _physics;

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(() {
      // define _physics for pageView effect
      if (_controller.position.haveDimensions && _physics == null) {
        setState(() {
          // var dimension = _controller.position.maxScrollExtent /
          //     (widget.listItems.length - 1);
          var dimension = _controller.position.maxScrollExtent /
              (widget.coupons.length - 1);
          _physics = CustomScrollPhysics(itemDimension: dimension);
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0),
      color: Colors.transparent,
      height: 257,
      child: ListView.builder(
        controller: _controller,
        physics: _physics,
        padding: const EdgeInsets.only(
            left: 8,
            right: 16,
            top: 0), //the padiing 8 leaves space for _HorizonListItem's sizebox
        itemCount: widget.coupons.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              //* navigate to business page
              Navigator.of(context).pushNamed("/business/id", arguments: {
                'businessId': widget.coupons[index].businessId,
                'name': widget.coupons[index].businessName,
              });
            },
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(width: 8),
                  ReoderListViewItem(
                    couponTicket: widget.coupons[index],
                  ),
                ]),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

// coupon horizon listview item
class ReoderListViewItem extends StatelessWidget {
  final CouponTicket couponTicket;

  const ReoderListViewItem({Key key, @required this.couponTicket})
      : assert(couponTicket != null),
        super(key: key);

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
    var f = NumberFormat("#,###,##0.00", "en_US");
    ;
    return CustomPaint(
      painter: ShadowBoarderPainter(
        _buildMyCardPath(MediaQuery.of(context).size.width - 64),
      ),
      child: ClipPath(
        clipper: SideSunkClipper(
          _buildMyCardPath(MediaQuery.of(context).size.width - 64),
        ),
        child: ClipRRect(
          borderRadius: new BorderRadius.circular(4.0),
          // the whole coupon card
          child: Container(
              height: 250,
              width: MediaQuery.of(context).size.width - 64,
              color: Color(0xFFFDFDFD),
              child: Column(
                children: <Widget>[
                  // top half coupon card
                  Container(
                    width: MediaQuery.of(context).size.width - 64,
                    height: 180,
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          left: 0,
                          right: 0,
                          top: 0,
                          bottom: 0,
                          child: couponTicket.images.length > 0
                              ? ExtendedImage.network(
                                  couponTicket.images[0],
                                  width: MediaQuery.of(context).size.width - 64,
                                  //16:9
                                  height: 180,
                                  // use fit to fulfill the box
                                  fit: BoxFit.cover,
                                )
                              : SvgPicture.asset(
                                  'assets/svg/imageplaceholder.svg',
                                  width: MediaQuery.of(context).size.width - 64,
                                  height: 180,
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
                                    'en'
                                ? couponTicket.businessName[0]['English']
                                : couponTicket.businessName[0]['Chinese'],
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ),
                        //TODO: Can not get business rating based on performce
                        // Positioned(
                        //   left: 16,
                        //   bottom: 8,
                        //   child: Row(
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     children: <Widget>[
                        //       Text(
                        //         "4.0",
                        //         textAlign: TextAlign.left,
                        //         overflow: TextOverflow.ellipsis,
                        //         style: TextStyle(
                        //             fontSize: 12,
                        //             fontFamily: "Regular",
                        //             color: Color(0xFFFCD300)),
                        //       ),
                        //       SizedBox(
                        //         width: 4.0,
                        //       ),
                        //       Image.asset(
                        //         'assets/images/star.png',
                        //         width: 14,
                        //         height: 14,
                        //         fit: BoxFit.cover,
                        //       ),
                        //       SizedBox(
                        //         width: 2.0,
                        //       ),
                        //       Image.asset(
                        //         'assets/images/star.png',
                        //         width: 14,
                        //         height: 14,
                        //         fit: BoxFit.cover,
                        //       ),
                        //       SizedBox(
                        //         width: 2.0,
                        //       ),
                        //       Image.asset(
                        //         'assets/images/star.png',
                        //         width: 14,
                        //         height: 14,
                        //         fit: BoxFit.cover,
                        //       ),
                        //       SizedBox(
                        //         width: 2.0,
                        //       ),
                        //       Image.asset(
                        //         'assets/images/star.png',
                        //         width: 14,
                        //         height: 14,
                        //         fit: BoxFit.cover,
                        //       ),
                        //       SizedBox(
                        //         width: 2.0,
                        //       ),
                        //       Image.asset(
                        //         'assets/images/emptystar.png',
                        //         width: 14,
                        //         height: 14,
                        //         fit: BoxFit.cover,
                        //       ),
                        //       SizedBox(
                        //         width: 4.0,
                        //       ),
                        //       Text(
                        //         "(1,234)",
                        //         textAlign: TextAlign.left,
                        //         overflow: TextOverflow.ellipsis,
                        //         style: TextStyle(
                        //             fontSize: 12,
                        //             fontFamily: "Regular",
                        //             color: Colors.white),
                        //       ),
                        //     ],
                        //   ),
                        // )
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
                                        'en'
                                    ? couponTicket.name
                                    : couponTicket.nameCn,
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF242424),
                                ),
                              ),
                              SizedBox(
                                height: 1,
                              ),
                              Text(
                                AppLocalizations.of(context)
                                            .locale
                                            .languageCode ==
                                        'en'
                                    ? couponTicket.description
                                    : couponTicket.descriptionCn,
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF242424),
                                ),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    "\$${f.format(couponTicket.price)}",
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF242424),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Text(
                                    "\$${f.format(couponTicket.oriPrice)}",
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 10,
                                      decoration: TextDecoration.lineThrough,
                                      color: Color(0xFFACACAC),
                                    ),
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
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF242424),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 1,
                              ),
                              Container(
                                child: Text(
                                  couponTicket.getPriceInt(),
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 50,
                                    color: Color(0xFF242424),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 7),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      couponTicket.getPriceDecimal(),
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF242424),
                                      ),
                                    ),
                                    Text(
                                      "OFF",
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: Color(0xFF242424),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
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
