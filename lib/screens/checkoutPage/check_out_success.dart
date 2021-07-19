import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:infishare_client/repo/utils/firebase_consts.dart';

import '../screens.dart';

class CheckOutSuccessScreen extends StatelessWidget {
  final String receipNum;
  final String type;

  const CheckOutSuccessScreen({this.receipNum, this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              _buildSuccessSection(context),
              SizedBox(
                height: 16.0,
              ),
              _buttonsSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessSection(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 16.0,
            ),
            Container(
              width: 150,
              height: 150,
              child: FlareActor(
                'assets/flare/successcheck.flr',
                alignment: Alignment.center,
                fit: BoxFit.cover,
                animation: 'Untitled',
              ),
            ),
            Text(
              AppLocalizations.of(context).translate('Success'),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Text(
              AppLocalizations.of(context).translate("Order Number") +
                  ": $receipNum",
              style: TextStyle(
                color: Color(0xffacacac),
              ),
            ),
            SizedBox(
              height: 16.0,
            )
          ],
        ),
      ),
    );
  }

  Widget _buttonsSection(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 48,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: FlatButton(
              child: Text(
                AppLocalizations.of(context).translate('Use now'),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                //* Navigate to my coupon page based on type
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return MyCouponsRoute(
                      title: type == FirestoreConstants.GROUP_BUY
                          ? AppLocalizations.of(context).translate('My Coupons')
                          : AppLocalizations.of(context).translate('MyVoucher'),
                      type: type,
                    );
                  }),
                );
              },
            ),
          ),
          Divider(
            height: 0.5,
            color: Color(0xffacacac),
          ),
          Container(
            height: 48,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: FlatButton(
              child: Text(
                AppLocalizations.of(context).translate("Keep browsing"),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                //* pop to business page
                Navigator.of(context).popUntil(
                  ModalRoute.withName('/home'),
                );
              },
            ),
          ),
          Divider(
            height: 0.5,
            color: Color(0xffacacac),
          ),
          Container(
            height: 48,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: FlatButton(
              child: Text(
                AppLocalizations.of(context).translate('Done'),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
