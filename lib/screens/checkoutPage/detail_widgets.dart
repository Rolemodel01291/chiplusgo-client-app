import 'package:flutter/material.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:intl/intl.dart';

class DetailSection extends StatelessWidget {
  final String title;
  final double subTotal;
  final double tax;
  final double tip;
  final double inficash;
  final double total;

  const DetailSection(
      {Key key,
      this.title,
      this.subTotal,
      this.tax,
      this.tip,
      this.inficash,
      this.total});

  @override
  Widget build(BuildContext context) {
    var f = NumberFormat("#,###,##0.00", "en_US");
    ;
    return Container(
      padding: EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF242424),
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: <Widget>[
              Text(
                AppLocalizations.of(context).translate('Subtotal'),
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF242424),
                ),
              ),
              Spacer(),
              Text(
                "\$${f.format(subTotal)}",
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF242424),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: <Widget>[
              Text(
                AppLocalizations.of(context).translate("Tax"),
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF242424),
                ),
              ),
              Spacer(),
              Text(
                "\$${f.format(tax)}",
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF242424),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: <Widget>[
              Text(
                AppLocalizations.of(context).translate("Tips"),
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF242424),
                ),
              ),
              Spacer(),
              Text(
                "\$${f.format(tip)}",
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF242424),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          GestureDetector(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 24,
              color: Colors.transparent,
              child: Row(
                children: <Widget>[
                  Text(
                    "InfiCash",
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF00AC5C),
                    ),
                  ),
                  Spacer(),
                  Text(
                    "- \$${f.format(inficash)}",
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF00AC5C),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              print("jump to Inficash");
            },
          ),
          SizedBox(height: 8),
          Row(
            children: <Widget>[
              Text(
                AppLocalizations.of(context).translate('Total'),
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF242424),
                ),
              ),
              Spacer(),
              Text(
                "\$${f.format(total)}",
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF242424),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
