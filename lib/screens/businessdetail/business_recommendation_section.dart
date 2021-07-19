import 'package:flutter/material.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:infishare_client/models/models.dart';
import 'package:infishare_client/screens/businessdetail/business_pageview.dart';

class BusinessRecommendationSection extends StatelessWidget {
  final List<Business> businesses;

  BusinessRecommendationSection({this.businesses});
  @override
  Widget build(BuildContext context) {
    return businesses.length > 0
        ? SliverToBoxAdapter(
            child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    AppLocalizations.of(context).translate('Recommendation'),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ShopHorizonListViewSection(
                  business: businesses,
                ),
                SizedBox(
                  height: 32,
                )
              ],
            ),
          ))
        : BusinessEmptyRecommendationTile();
  }
}

class BusinessEmptyRecommendationTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        height: 100,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                AppLocalizations.of(context).translate('Recommendation'),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: Text(
                AppLocalizations.of(context).translate("No business nearby"),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xffacacac),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
