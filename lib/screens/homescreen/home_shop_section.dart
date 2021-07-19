// shop vertical listview section
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:infishare_client/models/models.dart';
import 'package:infishare_client/screens/businessdetail/business_pageview.dart';

class HomeShopSection extends StatelessWidget {
  final List<Business> recmdBusiness;
  final List<Business> newBusiness;
  final List<Business> hottestBusiness;
  final List<Business> nearbyBusiness;

  HomeShopSection({
    Key key,
    this.recmdBusiness,
    this.newBusiness,
    this.hottestBusiness,
    this.nearbyBusiness,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 16, bottom: 16),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: Text(
                AppLocalizations.of(context).translate('Shops'),
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
              height: 16,
            ),
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: Text(
                AppLocalizations.of(context).translate('Recommendation'),
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF242424),
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            ShopHorizonListViewSection(business: recmdBusiness),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: Text(
                AppLocalizations.of(context).translate('Newest'),
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF242424),
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            ShopHorizonListViewSection(business: newBusiness),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: Text(
                AppLocalizations.of(context).translate('Hottest'),
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF242424),
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            ShopHorizonListViewSection(business: hottestBusiness),
            SizedBox(
              height: 16,
            ),
            nearbyBusiness.length == 0
                ? Container()
                : Padding(
              padding: EdgeInsets.only(left: 16),
              child: Text(
                AppLocalizations.of(context).translate("Nearby business"),
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF242424),
                ),
              ),
            ),
            nearbyBusiness.length == 0
                ? Container()
                : SizedBox(
              height: 8,
            ),
            nearbyBusiness.length == 0
                ? Container()
                : ShopHorizonListViewSection(business: nearbyBusiness)
          ],
        ));
  }
}
