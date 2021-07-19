import 'package:flutter/material.dart';

class MapHeaderButtons extends StatelessWidget {
  final VoidCallback onSearchTap;
  final VoidCallback onBackMeTap;
  final VoidCallback onBackTap;

  MapHeaderButtons({this.onBackMeTap, this.onBackTap, this.onSearchTap});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 16,
      left: 16,
      right: 16,
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: 40,
              height: 40,
              child: RawMaterialButton(
                onPressed: onBackTap,
                child: new Icon(
                  Icons.arrow_back_ios,
                ),
                shape: new CircleBorder(),
                elevation: 5.0,
                fillColor: Colors.white,
              ),
            ),
            RaisedButton(
              elevation: 5.0,
              child: Text('Search Area'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Colors.white,
              onPressed: onSearchTap,
            ),
            Container(
              width: 40,
              height: 40,
              child: RawMaterialButton(
                onPressed: onBackMeTap,
                child: new Icon(
                  Icons.near_me,
                  color: Colors.blue[400],
                ),
                shape: new CircleBorder(),
                elevation: 5.0,
                fillColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
