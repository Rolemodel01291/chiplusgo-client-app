import 'package:flutter/material.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:infishare_client/models/coupon_ticket.dart';
import '../../mycoupon/expiredStampWidget.dart';
import '../../mycoupon/redeemStampWidget.dart';

class RedeemPageCouponAboutSection extends StatelessWidget {
  final List<String> titles;
  final List<String> periods;
  final List<String> hours;
  final String restrictions;
  final CouponTicket couponTicket;
  const RedeemPageCouponAboutSection(
      {Key key,
      @required this.titles,
      @required this.periods,
      @required this.hours,
      @required this.restrictions,
      @required this.couponTicket});

  // return Row including item name and item price
  Widget itemPair(String name) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "•",
          textAlign: TextAlign.left,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF555555),
          ),
        ),
        SizedBox(
          width: 4,
        ),
        Expanded(
          child: Text(
            name,
            textAlign: TextAlign.left,
            // overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF555555),
            ),
          ),
        ),
      ],
    );
  }

  // return Column including group of item rows and title

  Widget groupInfo(String title, List<String> items) {
    List<Widget> widgets = [];
    widgets.add(Text(
      title,
      textAlign: TextAlign.left,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF242424)),
    ));
    widgets.add(
      SizedBox(height: 12),
    );

    for (var i = 0; i < items.length; i++) {
      widgets.add(itemPair(items[i]));
      widgets.add(SizedBox(height: 12));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: widgets,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    widgets.add(Text(
      AppLocalizations.of(context).translate('About'),
      textAlign: TextAlign.left,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF242424)),
    ));
    widgets.add(
      SizedBox(height: 16),
    );
    // widgets.add(Positioned.fill(
    //   right: 20,
    //   bottom: 150,
    //   child: !couponTicket.getExpireState()
    //       ? RedeemStampWidget(
    //           time: couponTicket.getUsedDate(),
    //         )
    //       : couponTicket.getExpire()
    //           ? ExpiredStampWidget(
    //               time: couponTicket.getUsedDate(),
    //             )
    //           : Container(
    //               height: 1,
    //               color: Color(0xFF707070),
    //             ),
    // ));
    widgets.add(groupInfo(titles[0], periods));
    widgets.add(groupInfo(titles[1], hours));
    widgets.add(groupInfo(titles[2], [restrictions]));

    return Container(
      padding: EdgeInsets.only(top: 16, bottom: 4),
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      ),
    );
  }
}
