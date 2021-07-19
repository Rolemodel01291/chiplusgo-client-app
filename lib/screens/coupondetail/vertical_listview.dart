import 'package:flutter/material.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:infishare_client/models/models.dart';
import 'package:infishare_client/screens/coupondetail/use_at_section.dart';

import 'about_section.dart';
import 'image_section.dart';
import 'info_section.dart';

class CouponDetailsVerticalListview extends StatelessWidget {
  final Coupon coupon;
  final Business business;

  CouponDetailsVerticalListview({this.coupon, this.business})
      : assert(coupon != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFF1F2F4),
      width: MediaQuery.of(context).size.width,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          CouponImageSection(
            title: AppLocalizations.of(context).locale.languageCode == 'en'
                ? coupon.name
                : coupon.nameCn,
            businessName:
                AppLocalizations.of(context).locale.languageCode == 'en'
                    ? coupon.businessName[0]['English']
                    : coupon.businessName[0]['Chinese'],
            images: coupon.images,
            description:
                AppLocalizations.of(context).locale.languageCode == 'en'
                    ? coupon.description
                    : coupon.descriptionCn,
            soldCnt: coupon.soldCnt,
          ),
          SizedBox(
            height: 16,
          ),
          // CouponInfoSection(
          //   couponDetail: coupon.detail,
          // ),
          // SizedBox(
          //   height: 16,
          // ),
          CouponAboutSection(
            coupon: coupon,
          ),
          SizedBox(
            height: 16,
          ),
          UseAtSection(
            coupon:coupon,
            business: business,
          ),
          // SizedBox(
          //   height: 16,
          // ),
          // CouponRecomSection()
        ],
      ),
    );
  }
}
