import 'package:flutter/material.dart';
import 'package:infishare_client/language/app_localization.dart';

class RedeemBuyAgainButton extends StatelessWidget {
  final Function tapBuyAgain;
  const RedeemBuyAgainButton({Key key, @required this.tapBuyAgain});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 60,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              AppLocalizations.of(context).translate('Buy again'),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF242424),
              ),
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color(0xFFACACAC),
            ),
          ],
        ),
      ),
      onTap: tapBuyAgain,
    );
  }
}
