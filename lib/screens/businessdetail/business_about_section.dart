import 'package:flutter/material.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:url_launcher/url_launcher.dart';

class BusinessStoryListTile extends StatelessWidget {
  final String content;
  final String url;

  static const storyHeight = 141.0;

  BusinessStoryListTile({
    Key key,
    this.content,
    this.url,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
    child: Container(
      height: storyHeight,
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 4, 0),
            child: Row(
              children: <Widget>[
                Text(
                  AppLocalizations.of(context).translate('Story'),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                url.isNotEmpty
                    ? RawMaterialButton(
                        child: Text(
                          AppLocalizations.of(context).translate('ViewSite'),
                          style: TextStyle(
                            color: Color(0xFF266EF6),
                            fontSize: 14,
                          ),
                        ),
                        onPressed: () async {
                          if (await canLaunch(url)) {
                            await launch(url);
                          }
                        },
                      )
                    : Container(),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              content,
              softWrap: true,
              maxLines: 3,
              style: TextStyle(
                fontSize: 16,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    ),
    );
  }
}
