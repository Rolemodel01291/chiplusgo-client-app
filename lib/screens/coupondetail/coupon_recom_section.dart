import 'package:flutter/material.dart';
import 'package:infishare_client/language/app_localization.dart';

class CouponRecomSection extends StatelessWidget {
  const CouponRecomSection();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 16, bottom: 16, right: 0, left: 0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
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
            height: 12,
          ),
          // CouponHorizonListViewSection(
          //   listItems: [{}, {}, {}],
          // )
        ],
      ),
    );
  }
}
