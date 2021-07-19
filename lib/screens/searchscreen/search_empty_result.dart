import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchEmptyResult extends StatelessWidget {
  final String imageName;
  final String description;

  SearchEmptyResult({this.description, this.imageName});

  @override
  Widget build(BuildContext context) {
    final Widget svgImage = new SvgPicture.asset(
      imageName,
    );
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            svgImage,
            Text(
              description,
              style: TextStyle(fontSize: 18, color: Color(0xffacacac)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
