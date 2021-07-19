import 'package:flutter/material.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:infishare_client/models/models.dart';

class RedeemPageCouponUseAtSection extends StatelessWidget {
  final String businessName;
  final String address;
  final Function tapMap;
  final Function tapPhone;
  final CouponTicket couponTicket;
  const RedeemPageCouponUseAtSection(
      {Key key,
      @required this.businessName,
      @required this.address,
      @required this.tapMap,
      @required this.couponTicket,
      @required this.tapPhone});
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

  @override
  Widget build(BuildContext context) {
    final localeCode = Localizations.localeOf(context).languageCode;

    return Container(
      padding: EdgeInsets.only(top: 16, bottom: 16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (!couponTicket.getExpireState())
            Text(
              AppLocalizations.of(context).translate('For business'),
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF242424),
              ),
            ),
          if (couponTicket.getExpireState())
            Text(
              AppLocalizations.of(context).translate('Available At'),
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF242424),
              ),
            ),
          SizedBox(
            height: 8,
          ),
          if (!couponTicket.getExpireState())
            for (final Name in couponTicket.usedBusinessName)
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text(
                  localeCode == 'en' ? Name['English'] : Name['Chinese'],
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF555555),
                    height: 2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          if (couponTicket.getExpireState())
            for (final Name in couponTicket.businessName)
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text(
                  localeCode == 'en' ? Name['English'] : Name['Chinese'],
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF555555),
                    height: 2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          SizedBox(
            height: 16,
          ),
          Text(
            AppLocalizations.of(context).translate('Item'),
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF242424),
            ),
          ),
          SizedBox(
            height: 8,
          ),

          for (final item in couponTicket.items)
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(
                localeCode == 'en' ? item['Item'] : item['Item_cn'],
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF555555),
                  height: 2,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          // Row(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: <Widget>[
          //     Text(
          //       address,
          //       textAlign: TextAlign.left,
          //       overflow: TextOverflow.ellipsis,
          //       style: TextStyle(
          //         fontSize: 14,
          //         color: Color(0xFF555555),
          //       ),
          //     ),
          //     Spacer(),
          //     IconButton(
          //       padding: EdgeInsets.all(0.0),
          //       icon: Icon(
          //         Icons.location_on,
          //         color: Colors.grey,
          //         size: 24,
          //       ),
          //       onPressed: tapMap,
          //     ),
          //     IconButton(
          //       padding: EdgeInsets.all(0.0),
          //       icon: Icon(
          //         Icons.phone,
          //         color: Colors.grey,
          //         size: 24,
          //       ),
          //       onPressed: tapMap,
          //     ),
          //   ],
          // )
        ],
      ),
    );
  }
}
