import 'package:flutter/material.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:infishare_client/models/models.dart';
import 'package:url_launcher/url_launcher.dart';

class UseAtSection extends StatelessWidget {
  final Business business;
  final Coupon coupon;
  UseAtSection({this.business, this.coupon});
  @override
  Widget build(BuildContext context) {
    final localeCode = Localizations.localeOf(context).languageCode;
    return Container(
      padding: EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
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
          for (final Name in coupon.businessName)
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
          for (final item in coupon.items)
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
          //   crossAxisAlignment: CrossAxisAlignment.end,
          //   children: <Widget>[
          //     Text(
          //       business.getTwoLineDisplayAddress(),
          //       textAlign: TextAlign.left,
          //       overflow: TextOverflow.ellipsis,
          //       style: TextStyle(
          //         fontSize: 14,
          //         color: Color(0xFF555555),
          //       ),
          //     ),
          //     Spacer(),
          //     IconButton(
          //       icon: Icon(
          //         Icons.location_on,
          //         color: Color(0xffacacac),
          //       ),
          //       iconSize: 24,
          //       onPressed: () {
          //         _openMap();
          //       },
          //     ),
          //     IconButton(
          //       icon: Icon(
          //         Icons.phone,
          //         color: Color(0xffacacac),
          //       ),
          //       iconSize: 24,
          //       onPressed: () {
          //         _openPhone();
          //       },
          //     ),
          //   ],
          // )
        ],
      ),
    );
  }

  void _openMap() async {
    var lat = business.location['lat'];
    var lng = business.location['lng'];
    String url = 'geo:$lat,$lng';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // iOS
      url =
          'http://maps.apple.com/?daddr=${business.getMapQueryString()}&dirflg=d&t=m';
      print(url);
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  void _openPhone() async {
    // Android
    String uri = 'tel:${business.phone}';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      // iOS
      uri = 'tel:${business.phone}';
      if (await canLaunch(uri)) {
        await launch(uri);
      } else {
        throw 'Could not launch $uri';
      }
    }
  }
}
