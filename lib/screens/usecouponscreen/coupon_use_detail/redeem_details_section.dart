import 'package:flutter/material.dart';
import 'package:infishare_client/models/models.dart';
import 'package:infishare_client/screens/coupondetail/info_section.dart';
import 'title_section.dart';
import 'redeem_about_section.dart';
import 'redeem_use_at_section.dart';
import 'redeem_order_info_section.dart';
import 'redeem_buttons_widget.dart';
import 'redeem_coupon_contains_section.dart';

class RedeemDetailsSection extends StatelessWidget {
  final CouponTicket couponTicket;
  final String title;
  final String businessName;
  final String address;
  final Function tapMap;
  final Function tapPhone;
  final Function tapBuyAgain;
  final List<String> aboutTitles;

  const RedeemDetailsSection({
    Key key,
    @required this.aboutTitles,
    @required this.couponTicket,
    @required this.title,
    @required this.businessName,
    @required this.address,
    @required this.tapMap,
    @required this.tapPhone,
    @required this.tapBuyAgain,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(16),
        width: MediaQuery.of(context).size.width - 32,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: <Widget>[
            TitleSection(
              title: title,
              name: businessName,
            ),
            Container(
              height: 1,
              color: Color(0xFF707070),
            ),

            RedeemPageCouponAboutSection(
              titles: aboutTitles,
              couponTicket: couponTicket,
              periods: [couponTicket.getVaildDate()],
              hours: [couponTicket.rule.availableHours],
              restrictions: couponTicket.description,
            ),

            Container(
              height: 1,
              color: Color(0xFF707070),
            ),

            if (!couponTicket.isExpired())
              RedeemPageCouponUseAtSection(
                  businessName: businessName,
                  address: address,
                  tapMap: tapMap,
                  tapPhone: tapPhone,
                  couponTicket: couponTicket),
            if (!couponTicket.isExpired())
              Container(
                height: 1,
                color: Color(0xFF707070),
              ),
            if (!couponTicket.isExpired())
              RedeemPageOrderInfoSection(
                ticket: couponTicket,
              ),
            if (!couponTicket.isExpired())
              Container(
                height: 1,
                color: Color(0xFF707070),
              ),
            // RedeemBuyAgainButton(tapBuyAgain: tapBuyAgain),
            // Container(
            //   height: 1,
            //   color: Color(0xFF707070),
            // ),
            // couponTicket.picked != null && couponTicket.picked
            //     ? RedeemCouponContainsSection(
            //         detail: couponTicket.detail,
            //       )
            //     : CouponInfoSection(
            //         couponDetail: couponTicket.detail,
            //         vPadding: 16.0,
            //         hPadding: 0.0,
            //       ),
          ],
        ));
  }
}
