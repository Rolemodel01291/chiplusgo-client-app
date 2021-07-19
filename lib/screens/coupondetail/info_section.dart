import 'package:flutter/material.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:infishare_client/models/coupon_detail.dart';
import 'package:infishare_client/models/item.dart';

class CouponInfoSection extends StatelessWidget {
  final CouponDetail couponDetail;
  final double hPadding;
  final double vPadding;
  Locale locale;

  CouponInfoSection({
    this.couponDetail,
    this.hPadding = 16.0,
    this.vPadding = 16.0,
  });

  // return Row including item name and item price
  Widget _itemPair(Item item) {
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
            locale.languageCode == 'en' ? item.item : item.itemCn,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF555555),
            ),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Text(
          '\$${item.price}',
          textAlign: TextAlign.right,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF555555),
          ),
        ),
      ],
    );
  }
  // return Column including group of item rows and title

  Widget _groupInfo(String title, List<Item> items) {
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
      widgets.add(_itemPair(items[i]));
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
    final groups = couponDetail.groups;
    locale = Localizations.localeOf(context);
    List<Widget> widgets = [];
    widgets.add(Text(
      AppLocalizations.of(context).translate('Use Info'),
      textAlign: TextAlign.left,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Color(0xFF242424),
      ),
    ));
    widgets.add(
      SizedBox(height: 12),
    );
    for (var i = 0; i < groups.length; i++) {
      widgets.add(Container(
        padding: EdgeInsets.only(
            top: 4, bottom: 0), // 4 + 12 = 16 spacing between groups
        child: _groupInfo(
            AppLocalizations.of(context).locale.languageCode == 'en'
                ? groups[i].name
                : groups[i].nameCn,
            groups[i].items),
      ));
    }
    return Container(
      padding: EdgeInsets.fromLTRB(hPadding, vPadding, hPadding, vPadding),
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      ),
    );
  }
}
