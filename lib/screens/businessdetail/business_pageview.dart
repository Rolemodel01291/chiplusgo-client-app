// shop vertical listview section

import 'package:extended_image/extended_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:infishare_client/models/business.dart';
import 'package:infishare_client/screens/businessdetail/rating_bar.dart';
import 'custom_scroll_physics.dart' as Physics;

// Shop horizon listview section
class ShopHorizonListViewSection extends StatefulWidget {
  final List<Business> business;

  ShopHorizonListViewSection({Key key, this.business}) : super(key: key);

  @override
  _ShopHorizonListViewSectionState createState() =>
      _ShopHorizonListViewSectionState();
}

class _ShopHorizonListViewSectionState extends State<ShopHorizonListViewSection>
    with TickerProviderStateMixin {
  ScrollController _controller;
  ScrollPhysics _physics;
  FirebaseAnalytics _analytics = FirebaseAnalytics();

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
              (widget.business.length - 1);
          _physics = Physics.CustomScrollPhysics(itemDimension: dimension);
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0),
      color: Colors.white,
      height: 330,
      alignment: Alignment.center,
      child: ListView.builder(
        controller: _controller,
        physics: _physics,
        padding: const EdgeInsets.only(
            left: 8,
            right:
                16), //the padiing 8 leaves space for _HorizonListItem's sizebox
        // itemCount: widget.listItems.length,
        itemCount: widget.business.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              _analytics.logSelectContent(
                contentType: 'Business',
                itemId: widget.business[index].businessId,
              );
              Navigator.of(context).pushNamed(
                '/business',
                arguments: widget.business[index],
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(width: 8),
                ShopHorizonListViewItem(business: widget.business[index]),
              ],
            ),
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
class ShopHorizonListViewItem extends StatelessWidget {
  final Business business;

  const ShopHorizonListViewItem({Key key, this.business}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      height: 309,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4.0),
          boxShadow: [
            new BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 1),
              blurRadius: 6,
            ),
          ]),
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // top half card
                Container(
                  width: 240,
                  height: 173,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4.0),
                      topRight: Radius.circular(4.0),
                    ),
                    image: DecorationImage(
                      image: ExtendedNetworkImageProvider(
                          business.images.length > 0
                              ? business.images.last
                              : '',
                          cache: true),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // bottom half card
                Container(
                  padding: EdgeInsets.all(16.0),
                  width: 240,
                  height: 136,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        AppLocalizations.of(context).locale.languageCode == 'en'
                            ? business.businessName['English']
                            : business.businessName['Chinese'],
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF242424),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            (business.rating * 5).toStringAsFixed(1),
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFFFCD300),
                            ),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          StaticRatingBar(
                            size: 14,
                            rate: business.rating * 5,
                          ),
                          Text(
                            "(${business.reviewCount})",
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        // "${business.priceLabel} • ${business.getCategory()}",
                        "• ${business.getCategory()}",
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF242424),
                        ),
                      ),
                      Text(
                        business.address.getOneLineDisplayAddress(),
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFFACACAC),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.local_offer,
                            size: 20,
                            color: (business.labels.groupBuy != null &&
                                    business.labels.groupBuy)
                                ? Colors.red
                                : Color(0xffacacac),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Icon(
                            Icons.wifi,
                            size: 20,
                            color: (business.labels.wifi != null &&
                                    business.labels.wifi)
                                ? Colors.green
                                : Color(0xffacacac),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Icon(
                            Icons.local_parking,
                            size: 20,
                            color: (business.labels.parking != null &&
                                    business.labels.parking)
                                ? Colors.blue
                                : Color(0xffacacac),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          // Icon(
                          //   Icons.local_activity,
                          //   size: 20,
                          //   color: (business.labels['voucher'] != null &&
                          //           business.labels['voucher'])
                          //       ? Colors.yellow
                          //       : Color(0xffacacac),
                          // ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Positioned(
              left: 16,
              top: 138,
              child: Container(
                decoration: BoxDecoration(boxShadow: [
                  new BoxShadow(
                      color: Colors.black38,
                      offset: Offset(0, 0),
                      blurRadius: 3.0,
                      spreadRadius: 1.0),
                ], shape: BoxShape.circle),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: ExtendedNetworkImageProvider(
                      (business.logo != null && business.logo.isNotEmpty)
                          ? business.logo
                          : business.images.length > 0
                              ? business.images.first
                              : '',
                      cache: true),
                  radius: 25,
                ),
              )),
        ],
      ),
    );
  }
}
