import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class BusinessFullMenuListTile extends StatelessWidget {
  static const fullMenuHeight = 342.0;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        height: fullMenuHeight,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 0, 10),
              child: Row(
                children: <Widget>[
                  Text(
                    'Full Menu',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  FlatButton(
                    textColor: Color(0xFF266EF6),
                    child: Text('View All'),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Container(
              height: 250,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Container(
                    padding: index == 0 ? EdgeInsets.only(left: 12.0) : null,
                    child: BusinessMenuItemListTile(),
                  );
                },
                itemCount: 4,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BusinessMenuItemListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: Container(
        width: 200,
        height: 250,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4.0),
                  topRight: Radius.circular(4.0)),
              child: Image(
                width: 200.0,
                height: 140.0,
                image: ExtendedNetworkImageProvider(
                    "https://upload.wikimedia.org/wikipedia/en/7/7e/Kimetsu_no_Yaiba_Blu-ray_Disc_Box_1_art.jpg",
                    cache: true),
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(8, 8, 8, 4),
              child: Text(
                "Chongqing style roast chicken ",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
              child: Text(
                'Chincken, chili, vege',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xff555555),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(8, 4, 8, 8),
              child: Text(
                '\$24.95',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
