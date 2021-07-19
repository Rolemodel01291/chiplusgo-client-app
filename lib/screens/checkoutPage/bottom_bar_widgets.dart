import 'package:flutter/material.dart';
import 'package:infishare_client/language/app_localization.dart';

class BottomBar extends StatefulWidget {
  final VoidCallback onDetailTapped;
  final VoidCallback onCheckOutTapped;
  final double total;

  BottomBar({this.onCheckOutTapped, this.onDetailTapped, this.total});

  @override
  State<StatefulWidget> createState() {
    return _BottomBarState();
  }
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 0.5),
      color: Color(0xFFACACAC),
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
                  "\$${widget.total}",
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF242424)),
                ),
                SizedBox(width: 4),
                GestureDetector(
                  child: Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          AppLocalizations.of(context).translate('Detail'),
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFFACACAC),
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Color(0xffacacac),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    widget.onDetailTapped();
                  },
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
                    fontWeight: FontWeight.w600,
                    color: Color(0XFF242424),
                  ),
                ),
              ),
              onPressed: widget.onCheckOutTapped,
            ),
          ],
        ),
      ),
    );
  }
}
