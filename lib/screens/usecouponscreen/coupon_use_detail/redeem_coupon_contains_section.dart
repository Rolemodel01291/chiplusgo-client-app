import 'package:flutter/material.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:infishare_client/models/coupon_detail.dart';
import 'package:infishare_client/models/item.dart';

class RedeemCouponContainsSection extends StatelessWidget {
  final CouponDetail detail;

  const RedeemCouponContainsSection({Key key, @required this.detail});

  Widget itemPair(Item item, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          "•",
          textAlign: TextAlign.left,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 14, color: Color(0xFF555555)),
        ),
        SizedBox(
          width: 4,
        ),
        Expanded(
          child: Text(
            AppLocalizations.of(context).locale.languageCode == 'en'
                ? item.item
                : item.itemCn,
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 14, color: Color(0xFF555555)),
          ),
        ),
        Text(
          "X ${item.count}",
          textAlign: TextAlign.right,
          style: TextStyle(fontSize: 14, color: Color(0xFF555555)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Item> pickedItems = [];
    detail.groups.forEach((group) {
      group.items.forEach((item) {
        if (item.count > 0) {
          pickedItems.add(item);
        }
      });
    });
    return Container(
      padding: EdgeInsets.only(top: 16, bottom: 16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            AppLocalizations.of(context).translate('Detail'),
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF242424)),
          ),
          SizedBox(
            height: 16,
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: pickedItems.length,
            itemBuilder: (BuildContext context, int index) {
              return itemPair(pickedItems[index], context);
            },
            separatorBuilder: (BuildContext context, int index) => Padding(
              padding: EdgeInsets.only(left: 16),
              child: Container(
                height: 12,
              ),
            ),
          )
        ],
      ),
    );
  }
}
