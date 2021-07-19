import 'package:flutter/material.dart';

class ButtonCell extends StatelessWidget {
  final VoidCallback navigateTo;
  final RichText title;
  const ButtonCell({Key key, @required this.title, @required this.navigateTo})
      : assert(title != null),
        assert(navigateTo != null);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        height: 48,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            title,
            Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 16,
            )
          ],
        ),
      ),
      onTap: navigateTo,
    );
  }
}
