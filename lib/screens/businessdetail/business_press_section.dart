import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:infishare_client/language/app_localization.dart';

class BusinessPressSection extends StatelessWidget {
  final itemCount = 2;
  static const double pressHeight = 178;
  static const double titleHeight = 54.0;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        if (index == 0) {
          return _buildPressSectionHeader(context);
        } else {
          return _buildPressListTile(width);
        }
      }, childCount: itemCount + 1),
    );
  }

  Widget _buildPressSectionHeader(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.white,
          height: titleHeight,
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                AppLocalizations.of(context).translate('Press'),
                style: TextStyle(
                    color: Color(0xff242424),
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 4.0,
              ),
              Text(
                '(2)',
                style: TextStyle(color: Color(0xffacacac), fontSize: 14),
              ),
              Spacer(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPressListTile(double width) {
    return Container(
      width: width,
      height: pressHeight,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Image(
            image: ExtendedNetworkImageProvider(
                'https://www.conservativedailynews.com/wp-content/uploads/2012/06/CNN-Breaking-News.png',
                cache: true),
            fit: BoxFit.contain,
            width: width,
            height: pressHeight,
          ),
          Container(
            color: Colors.white60,
            height: pressHeight,
            width: width,
          ),
          Column(
            children: <Widget>[
              Divider(
                indent: 16,
                endIndent: 0,
                height: 0.5,
                color: Color(0xffacacac),
              ),
              Container(
                margin: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'A taste of Chicagos Chinatown',
                      style: TextStyle(
                          color: Color(0xff242424),
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      'Anthony Bourdain',
                      style: TextStyle(color: Color(0xffacacac)),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      'Anthony Bourdain gets a taste of “ass-burning Szechuan food” in Chicago. See what dish makes him “so happy.Anthony Bourdain gets a taste of “ass-burning Szechuan food” in Chicago. See what dish makes him “so happy.Anthony Bourdain gets a taste of “ass-burning Szechuan food” in Chicago. See what dish makes him “so happy.”',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            print('view Press');
                          },
                          child: Text(
                            'View Press',
                            style: TextStyle(color: Color(0xff266EF6)),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
