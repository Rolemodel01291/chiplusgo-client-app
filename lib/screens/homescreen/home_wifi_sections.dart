import 'package:flutter/material.dart';

// // wifi section
class HomeWifiSection extends StatelessWidget {
  const HomeWifiSection();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      height: 136,
      child: Stack(
        children: <Widget>[
          Positioned(
            right: 0,
            top: 0,
            child: Image.asset(
              'assets/images/home.png',
              width: 120.0,
              height: 120.0,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            bottom: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Guess you are at?",
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Regular",
                      color: Color(0xFF242424)),
                ),
                SizedBox(
                  height: 4,
                ),
                GestureDetector(
                  child: Row(
                    children: <Widget>[
                      Text(
                        "A Place by Damao",
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: "Bold",
                            color: Color(0xFF242424)),
                      ),
                      Image.asset(
                        'assets/images/jump.png',
                        width: 20.0,
                        height: 20.0,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                  onTap: () {
                    print("a place by damao tap");
                  },
                ),
              ],
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Row(
              children: <Widget>[
                FlatButton(
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(5.0),
                  ),
                  color: Color(0xFF242424),
                  disabledColor: Colors.grey,
                  padding:
                      EdgeInsets.only(left: 37, right: 37, top: 13, bottom: 13),
                  child: Text(
                    "VIEW BUSINESS",
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 12, fontFamily: "Bold", color: Colors.white),
                  ),
                  onPressed: () {
                    print("tap View Business");
                  },
                ),
                Spacer(),
                FlatButton(
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(5.0),
                  ),
                  color: Color(0xFF242424),
                  disabledColor: Colors.grey,
                  padding:
                      EdgeInsets.only(left: 37, right: 37, top: 13, bottom: 13),
                  child: Text(
                    "GET FREE WI-FI",
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 12, fontFamily: "Bold", color: Colors.white),
                  ),
                  onPressed: () {
                    print("tap View Business");
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

