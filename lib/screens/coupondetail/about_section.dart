import 'package:flutter/material.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:infishare_client/models/models.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class CouponAboutSection extends StatelessWidget {
  final Coupon coupon;
  var f = NumberFormat("#,###,##0.00", "en_US");
  CouponAboutSection({this.coupon});

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
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Color(0xFF242424),
      ),
    ));
    widgets.add(
      SizedBox(height: 12),
    );
    for (var i = 0; i < items.length; i++) {
      widgets.add(
        itemPair(items[i]),
      );
      widgets.add(
        SizedBox(height: 12),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: widgets,
    );
  }

  @override
  Widget build(BuildContext context) {
    // if (coupon.rule.ruleHtml != null &&
    //     coupon.rule.ruleHtml.isNotEmpty) {
    //   return Container(
    //     color: Colors.white,
    //     width: MediaQuery.of(context).size.width,
    //     child: Html(
    //       data: AppLocalizations.of(context).locale.languageCode == "en"
    //           ? coupon.detail.rule.ruleHtml
    //           : coupon.detail.rule.rultHtmlCn,
    //       onLinkTap: (url) {
    //         launch(url);
    //       },
    //       padding: EdgeInsets.symmetric(horizontal: 16.0),
    //     ),
    //   );
    // }

    List<String> titles = [
      AppLocalizations.of(context).translate('Price'),
      AppLocalizations.of(context).translate('Validation'),
      AppLocalizations.of(context).translate('Validation hours'),
      AppLocalizations.of(context).translate('Tax'),
      AppLocalizations.of(context).translate('Description'),
    ];
    List<Widget> widgets = [];
    widgets.add(Text(
      AppLocalizations.of(context).translate('About'),
      textAlign: TextAlign.left,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Color(0xFF242424),
      ),
    ));
    widgets.add(
      SizedBox(height: 16),
    );
    widgets.add(
      groupInfo(titles[0], ["\$${f.format(coupon.price)}"]),
    );
    widgets.add(
      groupInfo(titles[1], [coupon.getVaildDate()]),
    );
    widgets.add(
      groupInfo(titles[2], [coupon.rule.availableHours]),
    );
    widgets.add(
      groupInfo(titles[3], ["\$${f.format(coupon.tax)}"]),
    );
    widgets.add(
      groupInfo(titles[4], [coupon.description]),
    );

    return Container(
      padding: EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      ),
    );
  }
}
