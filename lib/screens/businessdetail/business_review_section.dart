import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:infishare_client/screens/businessdetail/business_image_review.dart';
import 'package:infishare_client/screens/businessdetail/rating_bar.dart';

class BusinessReviewSection extends StatelessWidget {
  int items = 7;

  @override
  Widget build(BuildContext context) {
    int itemCount = 0;
    if (items <= 5) {
      itemCount = items + 2;
    } else {
      itemCount = 8;
    }
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        if (index == 0) {
          return _buildReviewSectionTitle();
        }

        if (index == 1) {
          return BusinessReviewButton(
              'https://firebasestorage.googleapis.com/v0/b/infishare-client.appspot.com/o/Business%2F1tC5zSkv3zgAoDAsdXFg81rGtYF2%2Fimages%2Fothers%2F6.jpg?alt=media',
              'Gary');
        }

        if (index == 7) {
          return _buildShowMoreReviewButton('1,234');
        }

        return BusinessReviewWithImage();
      }, childCount: itemCount),
    );
  }

  Widget _buildShowMoreReviewButton(String count) {
    return Container(
      height: 48,
      color: Colors.white,
      child: FlatButton(
        onPressed: () {},
        child: Text(
          'View all $count Reviews',
          style: TextStyle(
              color: Color(0xFF266EF6),
              fontWeight: FontWeight.w600,
              fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildReviewSectionTitle() {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.white,
          height: 54,
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Reviews',
                style: TextStyle(
                    color: Color(0xff242424),
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 4.0,
              ),
              Text(
                '(1,234)',
                style: TextStyle(color: Color(0xffacacac), fontSize: 14),
              ),
              Spacer(),
              Icon(
                Icons.chevron_right,
                color: Color(0xffacacac),
              )
            ],
          ),
        ),
        Divider(
          indent: 16,
          endIndent: 0,
          height: 0.5,
          color: Color(0xffacacac),
        )
      ],
    );
  }
}

class BusinessReviewButton extends StatefulWidget {
  final String avatarUrl;
  final String userName;

  BusinessReviewButton(this.avatarUrl, this.userName);

  @override
  State<StatefulWidget> createState() {
    return _BusinessReviewButtonState();
  }
}

class _BusinessReviewButtonState extends State<BusinessReviewButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 72,
          color: Colors.white,
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircleAvatar(
                backgroundImage:
                    ExtendedNetworkImageProvider(widget.avatarUrl, cache: true),
                radius: 20,
              ),
              SizedBox(
                width: 8,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.userName,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  GestureDetector(
                    child: Text(
                      'Tap to Review..',
                      style: TextStyle(color: Colors.blue),
                    ),
                    onTap: () {
                      print('tapped');
                    },
                  ),
                ],
              ),
              Spacer(),
              RatingBar(
                onChange: (rating) {
                  print(rating);
                },
                size: 28,
                count: 5,
                strokeWidth: 1,
                colorLight: Color(0xFFFF8B00),
                colorDark: Color(0xFFFF8B00),
              ),
            ],
          ),
        ),
        Divider(
          indent: 16,
          endIndent: 0,
          height: 0.5,
          color: Color(0xffacacac),
        )
      ],
    );
  }
}
