import 'package:flutter/material.dart';

class TitleSection extends StatelessWidget {
  final String title;
  final String name;
  const TitleSection(
      {Key key, @required this.title, @required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF242424)),
          ),
          // SizedBox(
          //   height: 16,
          // ),
          // Text(
          //   name,
          //   textAlign: TextAlign.center,
          //   style: TextStyle(
          //       fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFFACACAC)),
          // ),
        ],
      ),
    );
  }
}
