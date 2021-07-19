import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:intl/intl.dart';

class InfiCashCardSection extends StatelessWidget {
  final double amount;
  final Function history;
  final Function recharge;
  const InfiCashCardSection(
      {@required this.amount, @required this.history, @required this.recharge})
      : assert(amount != null),
        assert(history != null),
        assert(recharge != null);

  @override
  Widget build(BuildContext context) {
    var f = NumberFormat("#,###,##0.00", "en_US");
    ;
    return Container(
      padding: EdgeInsets.all(16),
      height: 155,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xFF95CD5F), Color(0xFF60AC3F)])),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          // title and history button row
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                AppLocalizations.of(context).translate('InficashBalance'),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Spacer(),
              GestureDetector(
                child: Text(
                  AppLocalizations.of(context).translate('History'),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                  ),
                ),
                onTap: history,
              )
            ],
          ),
          SizedBox(
            height: 6,
          ),

          // amount text
          RichText(
            text: TextSpan(children: [
              TextSpan(
                text: "\$",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              TextSpan(
                text: "${f.format(amount)}",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              )
            ]),
            overflow: TextOverflow.ellipsis,
          ),

          Spacer(),

          // bottom row
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              // buttom text
              Text(
                AppLocalizations.of(context).translate('RechargeBenefit'),
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
              Spacer(),

              // recharge button
              GestureDetector(
                child: Container(
                  width: 106,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      color: Colors.white),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context).translate('Recharge'),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF81B72F),
                      ),
                    ),
                  ),
                ),
                onTap: recharge,
              )
            ],
          )
        ],
      ),
    );
  }
}
