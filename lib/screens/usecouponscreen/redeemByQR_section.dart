import 'package:flutter/material.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:infishare_client/models/item.dart';
import 'package:infishare_client/models/models.dart';
import 'package:intl/intl.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:convert';

class RedeemByQRSection extends StatelessWidget {
  final CouponTicket ticket;
  const RedeemByQRSection({Key key, this.ticket});

  @override
  Widget build(BuildContext context) {
    List<Item> items = [];
    // ticket.detail.groups.forEach((group) {
    //   group.items.forEach((item) {
    //     if (item.count > 0) {
    //       items.add(item);
    //     }
    //   });
    // });

    // var qrmap = {
    //   'client_id': ticket.clientId,
    //   // 'ticked_id': ticket.ticketNum,
    //   'ticked_id': ticket.couponTicketId,
    // };

    String qrJson = "${ticket.clientId}/${ticket.couponTicketId}";

    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            AppLocalizations.of(context).translate("Redeem by QR code"),
            textAlign: TextAlign.start,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF242424)),
          ),
          SizedBox(height: 18),
          Center(
            child: PrettyQr(
                image: AssetImage("assets/images/logo.png"),
                typeNumber: 4,
                data: qrJson,
                size: 200,
                errorCorrectLevel: QrErrorCorrectLevel.M,
                roundEdges: true),
          ),
          // Center(
          //   child: QrImage(
          //     data: qrJson,
          //     version: QrVersions.auto,
          //     size: 200.0,
          //     // gapless: false,
          //     embeddedImageEmitsError:false,
          //     embeddedImage: AssetImage("assets/images/logo.png"),
          //   ),
          // ),
          // Center(child: PrettyQr()),
          // Center(
          //   child: Text(
          //     AppLocalizations.of(context).translate('Order Number') +
          //         " ${ticket.receiptNum.toUpperCase()}",
          //     textAlign: TextAlign.start,
          //     style: TextStyle(
          //       fontSize: 16,
          //       color: Color(0xFF242424),
          //     ),
          //   ),
          // ),
          SizedBox(
            height: 32,
          ),
          ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: items.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              return PickedItem(
                title: AppLocalizations.of(context).locale.languageCode == 'en'
                    ? items[index].item
                    : items[index].itemCn,
                nums: items[index].count,
                price: items[index].price,
              );
            },
            separatorBuilder: (BuildContext context, int index) => SizedBox(
              height: 16,
            ),
          )
        ],
      ),
    );
  }
}

class PickedItem extends StatelessWidget {
  final String title;
  final int nums;
  final double price;

  const PickedItem({
    Key key,
    @required this.title,
    @required this.nums,
    this.price,
  });
  @override
  Widget build(BuildContext context) {
    var f = NumberFormat("#,###,##0.00", "en_US");
    ;
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "• ",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFFACACAC),
            ),
          ),
          Expanded(
            child: Text(
              "$title",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFFACACAC),
              ),
            ),
          ),
          Text(
            "X $nums  \$${f.format(price)}",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFFACACAC),
            ),
          ),
        ],
      ),
    );
  }
}
