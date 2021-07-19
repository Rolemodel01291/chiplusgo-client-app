import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:infishare_client/screens/commen_widgets/utils.dart';

class SuccessRoute extends StatelessWidget {
  const SuccessRoute({this.orderNumber});
  final String orderNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.zero,
          child: Container(
            height: 0.5,
            color: Color(0xFFACACAC),
          ),
        ),
      ),
      body: Container(
        color: Color(0xFFF1F2F4),
        child: ListView(
          children: <Widget>[
            // success card
            Container(
                padding: EdgeInsets.only(top: 32, bottom: 16),
                height: 270,
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // success icon
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
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      AppLocalizations.of(context).translate('Success'),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF242424),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      AppLocalizations.of(context).translate("Order Number") +
                          ": $orderNumber",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFFACACAC),
                      ),
                    ),
                  ],
                )),
            SizedBox(
              height: 16,
            ),
            // navigation inkwells
            GreyInkwell(
              backGroundColor: Colors.white,
              containWidget: Container(
                height: 48,
                child: Center(
                  child: Text(
                    AppLocalizations.of(context).translate('Done'),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF242424),
                    ),
                  ),
                ),
              ),
              tapFunction: () {
                Navigator.of(context).popUntil(
                  ModalRoute.withName('/home'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
