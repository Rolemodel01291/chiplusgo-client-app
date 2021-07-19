import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infishare_client/models/business.dart';
import 'package:infishare_client/screens/businessdetail/rating_bar.dart';

class ShopVerticalListViewItem extends StatelessWidget {
  final Business business;

  const ShopVerticalListViewItem({Key key, this.business});

  @override
  Widget build(BuildContext context) {
    int sumCount = business.offerSums != null
        ? business.offerSums.length
        : 0; // 16 is the bottom padding, 24 is the height each Icon detail row takes, 8 is unknow overflow
    Locale locale = Localizations.localeOf(context);
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withAlpha(41),
                offset: Offset(0, 3), // affect x, y shadow ratio
                blurRadius: 8,
                spreadRadius: 3 // affect width of shadow
                ),
          ]),
      child: Column(
        children: <Widget>[
          // image and Icon part
          Container(
            height: 188,
            child: Stack(
              children: <Widget>[
                // image column
                Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Column(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                          ),
                          child: business.images.length > 0
                              ? ExtendedImage.network(
                                  business.images.last,
                                  width: MediaQuery.of(context).size.width - 32,
                                  height: 180,
                                  fit: BoxFit.cover,
                                )
                              : SvgPicture.asset(
                                  'assets/svg/imageplaceholder.svg',
                                  height: 180,
                                  width: MediaQuery.of(context).size.width - 32,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Container(
                          height: 8,
                          color: Colors.white,
                        )
                      ],
                    )),
                // shope icon
                Positioned(
                  left: 16,
                  top: 138,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black38,
                            offset: Offset(0, 0),
                            blurRadius: 3.0,
                            spreadRadius: 1.0),
                      ],
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: business.images.length > 0
                            ? AdvancedNetworkImage(
                                business.images[0],
                              )
                            : AssetImage(
                                'assets/images/errorimageplacehold.png'),
                      ),
                    ),
                  ),
                ),
                // Positioned(
                //     right: 0,
                //     top: 16,
                //     child: Visibility(
                //       visible: business.memberShipType == 'New',
                //       child: Container(
                //         width: 120,
                //         height: 40,
                //         color: Color(0xFFC60404),
                //         child: Center(
                //           child: Text(
                //             "NEW !",
                //             style: TextStyle(
                //               fontSize: 20,
                //               fontWeight: FontWeight.w600,
                //               color: Colors.white,
                //             ),
                //           ),
                //         ),
                //       ),
                //     )),
              ],
            ),
          ),

          // information part
          Container(
            padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  locale.languageCode == 'en'
                      ? business.businessName['English']
                      : business.businessName['Chinese'],
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF242424)),
                ),
                // SizedBox(
                //   height: 27.0,
                // ),
                SizedBox(
                  height: 12.0,
                ),
                Row(
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
                      rate: business.rating * 5,
                      size: 14,
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      "(${business.reviewCount})",
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Spacer(),
                    Icon(
                      MaterialCommunityIcons.getIconData("near-me"),
                      color: Color(0xFFACACAC),
                      size: 14,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    // Text(
                    //   business.distance == null ? '-' : '${business.distance}',
                    //   style: TextStyle(
                    //     fontSize: 12,
                    //     color: Color(0xFFACACAC),
                    //   ),
                    // )
                  ],
                ),
                // SizedBox(
                //   height: 16.0,
                // ),
                SizedBox(
                  height: 6.0,
                ),
                Text(
                  // '${business.priceLabel} • ${business.getCategory()}',
                  '• ${business.getCategory()}',
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF242424),
                  ),
                ),
                // SizedBox(
                //   height: 19.0,
                // ),
                SizedBox(
                  height: 6.0,
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
                // SizedBox(
                //   height: 16.0,
                // ),
                SizedBox(
                  height: 6.0,
                ),

                //icons row
                _buildIcons(),
                SizedBox(
                  height: 8,
                ),
                Container(
                  height: 0.5,
                  color: Color(0xFF707070),
                ),
                SizedBox(
                  height: 8,
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: sumCount,
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          Ionicons.getIconData("ios-pricetag"),
                          size: 20,
                          color: Color(0xFFC60404),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Expanded(
                          child: Text(
                            locale.languageCode == 'en'
                                ? business.offerSums[index].sum
                                : business.offerSums[index].sumCn,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFC60404),
                            ),
                          ),
                        )
                      ],
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      SizedBox(
                    height: 4,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcons() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(
          Icons.wifi,
          size: 20,
          color: business.labels.wifi == null
              ? Colors.grey
              : business.labels.wifi
                  ? Colors.green
                  : Colors.grey,
        ),
        SizedBox(
          width: 8.0,
        ),
        Icon(
          FontAwesome5.getIconData("parking", weight: IconWeight.Solid),
          size: 20,
          color: business.labels.parking == null
              ? Colors.grey
              : business.labels.parking
                  ? Colors.blue
                  : Colors.grey,
        ),
        SizedBox(
          width: 8.0,
        ),
        // Icon(
        //   MaterialCommunityIcons.getIconData("ticket"),
        //   size: 22,
        //   color: business.labels['voucher'] == null
        //       ? Colors.grey
        //       : business.labels['voucher']
        //           ? Colors.yellow
        //           : Colors.grey,
        // ),
      ],
    );
  }
}
