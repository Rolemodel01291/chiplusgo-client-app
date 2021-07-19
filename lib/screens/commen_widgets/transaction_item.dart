import 'package:flutter/material.dart';
import 'package:infishare_client/models/transaction_history.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatelessWidget {
  final TransactionHistory transactionHistory;
  final VoidCallback onTap;
  var f = NumberFormat("#,###,##0.00", "en_US");
  TransactionItem({this.transactionHistory, this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
        width: MediaQuery.of(context).size.width,
        color: Colors.transparent,
        child: Column(children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      transactionHistory.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF242424),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      transactionHistory.getCreateTimeString(),
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFFACACAC),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                  ((transactionHistory.type == "Charge" ||
                              transactionHistory.type == "Gift Charge" ||
                              transactionHistory.type == "Refund")
                          ? "+ "
                          : "- ") +
                      "\$" +
                      ((transactionHistory.type == "Charge" ||
                              transactionHistory.type == "Gift Charge" ||
                              transactionHistory.type == "Refund")
                          ? f.format((transactionHistory.chargeCash).abs())
                          : f.format((transactionHistory.usedCash).abs())),
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: (transactionHistory.type == "Charge" ||
                              transactionHistory.type == "Gift Charge" ||
                              transactionHistory.type == "Refund")
                          ? Color(0xFF73B12D)
                          : Color(0xFFC60404))),
            ],
          ),
          SizedBox(
            height: 8.0,
          ),
          Divider(
            height: 0.5,
            color: Color(0xffacacac),
          )
        ]),
      ),
    );
  }
}
