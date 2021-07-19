import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infishare_client/blocs/blocs.dart';
import 'package:infishare_client/language/app_localization.dart';

class BottomBar extends StatelessWidget {
  final VoidCallback checkOut;
  final num amount;
  const BottomBar({
    Key key,
    @required this.amount,
    @required this.checkOut,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 0.5, bottom: MediaQuery.of(context).padding.bottom),
      color: Colors.white,
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 7, bottom: 7),
        height: 54,
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "\$$amount",
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF242424),
                  ),
                ),
                SizedBox(width: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context).translate('Total'),
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFFACACAC),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Spacer(),
            FlatButton(
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(22.0),
              ),
              color: Color(0xFFFCD300),
              disabledColor: Colors.grey,
              child: Center(
                child: Text(
                  AppLocalizations.of(context).translate('Checkout'),
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0XFF242424),
                  ),
                ),
              ),
              onPressed: checkOut,
            ),
          ],
        ),
      ),
    );
  }
}
