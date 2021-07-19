import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:infishare_client/screens/businessdetail/rating_bar.dart';
import 'package:infishare_client/utils/read_more_text.dart';
import 'dart:math' as math;

class BusinessReviewWithImage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BusinessReviewWithImageState();
  }
}

class _BusinessReviewWithImageState extends State<BusinessReviewWithImage> {
  List<String> images = [
    "https://firebasestorage.googleapis.com/v0/b/infishare-client.appspot.com/o/Business%2F1tC5zSkv3zgAoDAsdXFg81rGtYF2%2Fimages%2Fothers%2F6.jpg?alt=media",
    "https://s3-media2.fl.yelpcdn.com/bphoto/s4mO2iTsn8i8N3h_FQ6kmQ/o.jpg",
    "https://s3-media2.fl.yelpcdn.com/bphoto/s4mO2iTsn8i8N3h_FQ6kmQ/o.jpg",
    "https://s3-media2.fl.yelpcdn.com/bphoto/s4mO2iTsn8i8N3h_FQ6kmQ/o.jpg",
    "https://s3-media2.fl.yelpcdn.com/bphoto/s4mO2iTsn8i8N3h_FQ6kmQ/o.jpg",
    "https://s3-media2.fl.yelpcdn.com/bphoto/s4mO2iTsn8i8N3h_FQ6kmQ/o.jpg",
    "https://s3-media2.fl.yelpcdn.com/bphoto/s4mO2iTsn8i8N3h_FQ6kmQ/o.jpg",
    "https://s3-media2.fl.yelpcdn.com/bphoto/s4mO2iTsn8i8N3h_FQ6kmQ/o.jpg",
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(16),
          color: Colors.white,
          child: Column(
            children: <Widget>[
              _buildReviewHeader(),
              _buildReviewComments(),
              images.length > 0 ? _buildReviewImages(context) : Container()
            ],
          ),
        ),
        Divider(
          indent: 16,
          endIndent: 0,
          color: Color(0xffacacac),
          height: 0.5,
        )
      ],
    );
  }

  Widget _buildReviewHeader() {
    return Row(
      children: <Widget>[
        CircleAvatar(
          backgroundImage: ExtendedNetworkImageProvider(
              'https://s3-media2.fl.yelpcdn.com/bphoto/s4mO2iTsn8i8N3h_FQ6kmQ/o.jpg',
              cache: true),
          radius: 20,
        ),
        SizedBox(
          width: 8,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text('User name',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            StaticRatingBar(
              rate: 4,
              size: 16,
              colorLight: Color(0xffFF8B00),
            ),
          ],
        ),
        Spacer(),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              '11 days ago',
              style: TextStyle(fontSize: 14, color: Color(0xffacacac)),
            ),
            Text(
              'Verified Review',
              style: TextStyle(fontSize: 14, color: Color(0xffFF8B00)),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildReviewComments() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ReadMoreText(
        'The Flutter framework builds its layout via the composition of widgets, everything that you construct programmatically is a widget and these are compiled together to create the user interface. ',
        trimLines: 3,
        colorClickableText: Colors.blue,
        trimMode: TrimMode.Line,
        trimCollapsedText: '...Read more',
        trimExpandedText: ' Show less',
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildReviewImages(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: _buildImages(context),
    );
  }

  List<Widget> _buildImages(BuildContext context) {
    int count = math.min(images.length, 4);
    List<Widget> result = [];
    for (int i = 0; i < count; i++) {
      result.add(ClipRRect(
        borderRadius: new BorderRadius.circular(4.0),
        child: Image(
          width: (MediaQuery.of(context).size.width - 24 - 32) / 4,
          height: (MediaQuery.of(context).size.width - 24 - 32) / 4,
          image: ExtendedNetworkImageProvider(images[i], cache: true),
          fit: BoxFit.cover,
        ),
      ));
      if (i != 3) {
        result.add(SizedBox(
          width: 8,
        ));
      }
    }

    return result;
  }
}
