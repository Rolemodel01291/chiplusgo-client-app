import 'package:flutter/material.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:infishare_client/repo/utils/firebase_consts.dart';
import 'package:infishare_client/screens/myvouchers/myVouchers_route.dart';
import 'package:infishare_client/screens/mypasses/myPasses_route.dart';

import '../screens.dart';

class CouponCardWidget extends StatelessWidget {
  final String title;
  //final int amount;
  final String tip;
  final Color startColor;
  final Color endColor;
  final String type;

  const CouponCardWidget(
      {Key key,
      @required this.title,
      @required this.tip,
      @required this.startColor,
      @required this.endColor,
      @required this.type});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(16),
        width: MediaQuery.of(context).size.width - 32,
        height: 150,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6.0,
              offset: Offset(0, 3),
            )
          ],
          borderRadius: BorderRadius.circular(5),
          gradient: LinearGradient(
              begin: Alignment(1, 0),
              end: Alignment(0, 1),
              colors: [startColor, endColor]),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            // RichText(
            //   textAlign: TextAlign.start,
            //   text: TextSpan(
            //     children: <TextSpan>[
            //       TextSpan(
            //           text: '$amount ',
            //           style: TextStyle(
            //               fontSize: 40,
            //               fontFamily: "Regular",
            //               color: Colors.white)),
            //       TextSpan(
            //           text: "Available",
            //           style: TextStyle(
            //               fontSize: 16,
            //               fontFamily: "Regular",
            //               color: Colors.white)),
            //     ],
            //   ),
            // ),
            Row(
              children: <Widget>[
                Icon(
                  Icons.local_activity,
                  size: 60,
                  color: Colors.white,
                ),
                Spacer(),
                SizedBox(
                  width: 106,
                  height: 40,
                  child: FlatButton(
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(22.0),
                    ),
                    color: Colors.white,
                    disabledColor: Colors.grey,
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context).translate('Viewall'),
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: startColor,
                        ),
                      ),
                    ),
                    onPressed: () {
                      if (title ==
                          AppLocalizations.of(context).translate('My Coupons'))
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) {
                            return MyCouponsRoute(
                              title: title,
                              type: type,
                            );
                            // return type == FirestoreConstants.TICKET
                            //     ? MyPassScreen(
                            //         type: type,
                            //         title: title,
                            //       )
                            //     : MyCouponsRoute(
                            //         title: title,
                            //         type: type,
                            //       );
                          }),
                        );
                      if (title ==
                          AppLocalizations.of(context).translate('MyVoucher'))
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) {
                            return MyVouchersRoute(
                              title: title,
                              type: type,
                            );
                            // return type == FirestoreConstants.TICKET
                            //     ? MyPassScreen(
                            //         type: type,
                            //         title: title,
                            //       )
                            //     : MyCouponsRoute(
                            //         title: title,
                            //         type: type,
                            //       );
                          }),
                        );
                      if (title ==
                          AppLocalizations.of(context).translate('MyPasses'))
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) {
                            return MyPassesRoute(
                              title: title,
                              type: type,
                            );
                            // return type == FirestoreConstants.TICKET
                            //     ? MyPassScreen(
                            //         type: type,
                            //         title: title,
                            //       )
                            //     : MyCouponsRoute(
                            //         title: title,
                            //         type: type,
                            //       );
                          }),
                        );
                    },
                  ),
                ),
              ],
            ),
            Text(
              tip,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        if (title == AppLocalizations.of(context).translate('My Coupons'))
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return MyCouponsRoute(
                title: title,
                type: type,
              );
              // return type == FirestoreConstants.TICKET
              //     ? MyPassScreen(
              //         type: type,
              //         title: title,
              //       )
              //     : MyCouponsRoute(
              //         title: title,
              //         type: type,
              //       );
            }),
          );
        if (title == AppLocalizations.of(context).translate('MyVoucher'))
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return MyVouchersRoute(
                title: title,
                type: type,
              );
              // return type == FirestoreConstants.TICKET
              //     ? MyPassScreen(
              //         type: type,
              //         title: title,
              //       )
              //     : MyCouponsRoute(
              //         title: title,
              //         type: type,
              //       );
            }),
          );
        if (title == AppLocalizations.of(context).translate('MyPasses'))
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return MyPassesRoute(
                title: title,
                type: type,
              );
              // return type == FirestoreConstants.TICKET
              //     ? MyPassScreen(
              //         type: type,
              //         title: title,
              //       )
              //     : MyCouponsRoute(
              //         title: title,
              //         type: type,
              //       );
            }),
          );
      },
    );
  }
}
