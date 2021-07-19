import 'package:flutter/material.dart';

class CouponSoldBottomBar extends StatelessWidget {
  final String title;
  final String oriPrice;
  final VoidCallback onPress;
  const CouponSoldBottomBar({
    Key key,
    @required this.title,
    @required this.onPress,
    this.oriPrice = '',
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      height: 60,
      color: Colors.white,
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        color: Colors.red,
        disabledColor: Colors.grey,
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                title,
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              // SizedBox(
              //   width: 4,
              // ),
              // Text(
              //   oriPrice,
              //   overflow: TextOverflow.ellipsis,
              //   textAlign: TextAlign.right,
              //   style: TextStyle(
              //     fontSize: 12,
              //     color: Colors.grey,
              //     decoration: TextDecoration.lineThrough,
              //   ),
              // )
            ],
          ),
        ),
        onPressed: onPress,
      ),
    );
  }
}
