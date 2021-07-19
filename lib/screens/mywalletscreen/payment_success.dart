import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infishare_client/language/app_localization.dart';

class PaymentSuccessScreen extends StatelessWidget {
  String activeNumber;

  PaymentSuccessScreen(this.activeNumber);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 100,
                height: 100,
                child: SvgPicture.asset(
                  "assets/svg/payment_completed.svg",
                  color: Color(0xff1463a0),
                ),
              ),
              SizedBox(height: 32),
              Text(
                AppLocalizations.of(context).translate("Payment completed"),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "${AppLocalizations.of(context).translate('Activity Number')}: #${activeNumber.substring(12,20)}",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 56.0,
              ),
              MaterialButton(
                minWidth: MediaQuery.of(context).size.width * 0.6,
                color: Color(0xff1463a0),
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/home');
                },
                child: Text(
                  AppLocalizations.of(context).translate("Done"),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
