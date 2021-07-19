import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:intl/intl.dart';

class WalletCardSection extends StatelessWidget {
  final double amount;
  final double creditlineBalance;
  final int pointsBalance;
  final Function history;
  final Function recharge;
  const WalletCardSection(
      {@required this.amount,
      @required this.creditlineBalance,
      @required this.pointsBalance,
      @required this.history,
      @required this.recharge})
      : assert(amount != null),
        assert(creditlineBalance != null),
        assert(pointsBalance != null),
        assert(history != null),
        assert(recharge != null);

  @override
  Widget build(BuildContext context) {
    var f = NumberFormat("#,###,##0.00", "en_US");
    var fd = NumberFormat("#,###,###", "en_US");
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          height: 180,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xff1463a0), Color(0xff002541)])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // title and history button row
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context).translate('Chi+GoBalance'),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Spacer(),
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

              Row(
                children: [
                  Icon(
                    Icons.star,
                    size: 20,
                    color: Color(0xfffcd300),
                  ),
                  Text(
                    "${fd.format(pointsBalance)} ${AppLocalizations.of(context).translate('points')}",
                    style: TextStyle(color: Color(0xfffcd300), fontSize: 16),
                  ),
                ],
              ),

              Spacer(),

              // bottom row
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  // buttom text
                  Row(
                    children: [
                      if (creditlineBalance != 0)
                        Text(
                          // AppLocalizations.of(context).translate('RechargeBenefit'),
                          "${AppLocalizations.of(context).translate('Credit Line')}: ${f.format(creditlineBalance)}",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      SizedBox(width: 8),
                      // GestureDetector(
                      //   onTap: () {
                      //     showDialog(
                      //       context: context,
                      //       builder: (context) {
                      //         return AlertDialog(
                      //           shape: RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.all(
                      //               Radius.circular(16.0),
                      //             ),
                      //           ),
                      //           title: Text(
                      //             "What is Credit Line",
                      //             textAlign: TextAlign.center,
                      //           ),
                      //           content: Text(
                      //             "A line of credit is a flexible loan from a financial institution that consists of a defined amount of money that you can access as needed and repay either immediately or over time",
                      //             textAlign: TextAlign.center,
                      //           ),
                      //           actions: <Widget>[
                      //             SizedBox(
                      //               width: MediaQuery.of(context).size.width,
                      //               child: Padding(
                      //                 padding: EdgeInsets.symmetric(
                      //                     horizontal: 8, vertical: 8),
                      //                 child: MaterialButton(
                      //                   height: 50,
                      //                   color: Color(0xff1463a0),
                      //                   child: Text(
                      //                     "GOT IT",
                      //                     style: TextStyle(
                      //                         fontSize: 16,
                      //                         color: Colors.white,
                      //                         fontWeight: FontWeight.bold),
                      //                   ),
                      //                   onPressed: () {
                      //                     if (Navigator.of(context).canPop()) {
                      //                       Navigator.of(context).pop();
                      //                     }
                      //                   },
                      //                   shape: RoundedRectangleBorder(
                      //                       borderRadius:
                      //                           BorderRadius.circular(4)),
                      //                 ),
                      //               ),
                      //             )
                      //           ],
                      //         );
                      //       },
                      //     );
                      //   },
                      //   child: Icon(
                      //     Icons.help,
                      //     color: Colors.white,
                      //   ),
                      // ),
                    ],
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
                            color: Color(0xff1463a0),
                          ),
                        ),
                      ),
                    ),
                    onTap: recharge,
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
