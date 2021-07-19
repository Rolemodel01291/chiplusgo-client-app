import 'package:flutter/material.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:infishare_client/models/coupon_ticket.dart';
import 'package:intl/intl.dart';

class RedeemPageOrderInfoSection extends StatelessWidget {
  final CouponTicket ticket;
  const RedeemPageOrderInfoSection({Key key, @required this.ticket});

  Widget itemPair({String name, String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          name,
          textAlign: TextAlign.left,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF242424)),
        ),
        Spacer(),
        Text(
          value,
          textAlign: TextAlign.right,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 14, color: Color(0xFF555555)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var f = NumberFormat("#,###,##0.00", "en_US");

    return Container(
        padding: EdgeInsets.only(top: 16, bottom: 16),
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              AppLocalizations.of(context).translate('Order Info'),
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF242424)),
            ),
            SizedBox(
              height: 16,
            ),
            // itemPair(
            //     name: AppLocalizations.of(context).translate('Order Number') +
            //         " :",
            //     value: ticket.receiptNum.toUpperCase()),
            SizedBox(
              height: 16,
            ),
            itemPair(
                name: AppLocalizations.of(context).translate('Purchase date') +
                    " :",
                value: ticket.getPurchaseDate()),
            SizedBox(
              height: 16,
            ),
            ticket.used
                ? itemPair(
                    name: AppLocalizations.of(context).translate('Used date') +
                        " :",
                    value: ticket.getUsedDate())
                : itemPair(
                    name:
                        AppLocalizations.of(context).translate('Expired date') +
                            " :",
                    value: ticket.getUsedDate()),
            ticket.used
                ? SizedBox(
                    height: 16,
                  )
                : SizedBox(
                    height: 16,
                  ),
            itemPair(
                name: AppLocalizations.of(context).translate('Subtotal') + " :",
                value: '\$${f.format(ticket.price + ticket.tax)}'),
            SizedBox(
              height: 16,
            ),
            itemPair(
                name: AppLocalizations.of(context).translate('Tax') + " :",
                value: '\$${f.format(ticket.tax)}'),
            SizedBox(
              height: 16,
            ),
            // itemPair(
            //     name: AppLocalizations.of(context).translate('Tips') + " :",
            //     value: '\$${ticket.tips.toStringAsFixed(2)}'),
            //* No inficash right now
            // SizedBox(
            //   height: 16,
            // ),
            // itemPair(name: "InfiCash :", value: orderInfo["InfiCash"]),
            SizedBox(
              height: 16,
            ),
            // itemPair(
            //     name: AppLocalizations.of(context).translate('Total') + " :",
            //     value: '\$${ticket.getTotal().toStringAsFixed(2)}'),
          ],
        ));
  }
}
