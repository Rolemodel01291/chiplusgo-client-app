import 'package:app_review/app_review.dart';
import 'package:flutter/material.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutSection extends StatelessWidget {
  final String buildNum;
  final String versionNum;
  const AboutSection({this.buildNum, this.versionNum});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(left: 16, top: 0),
            child: Row(
              children: <Widget>[
                Text(
                  AppLocalizations.of(context).translate('About'),
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF242424),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  'v' + versionNum,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFFACACAC),
                  ),
                ),
              ],
            )),
        SizedBox(
          height: 8,
        ),
        Container(
            padding: EdgeInsets.only(left: 16, right: 0),
            width: MediaQuery.of(context).size.width,
            height: 96,
            color: Colors.white,
            child: Column(
              children: <Widget>[
                AboutItem(
                  title: Text(
                    AppLocalizations.of(context).translate('TERMS OF SERVICE'),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF242424),
                    ),
                  ),
                  voidCallback: () async {
                    //"https://www.infishareapp.com/terms-conditions"
                    //*navigate to terms and conditions
                    // const url = 'https://www.infishareapp.com/terms-conditions';
                    // if (await canLaunch(url)) {
                    //   await launch(url);
                    // } else {
                    //   print('Could not launch $url');
                    // }
                    Navigator.of(context).pushNamed(
                      '/terms',
                    );
                  },
                ),
                Divider(
                  height: 0,
                  thickness: 0.5,
                  color: Color(0xFFACACAC),
                ),
                AboutItem(
                  title: Text.rich(
                    TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: AppLocalizations.of(context).translate('Rate'),
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF242424),
                          ),
                        ),
                        TextSpan(
                          text: 'Chiplusgo',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF242424),
                          ),
                        ),
                      ],
                    ),
                  ),
                  voidCallback: () {
                    //* navigate to rate
                    AppReview.requestReview.then(
                      (onValue) {
                        print(onValue);
                      },
                    );
                  },
                ),
              ],
            ))
      ],
    );
  }
}

class AboutItem extends StatelessWidget {
  final VoidCallback voidCallback;
  final Text title;
  const AboutItem({Key key, @required this.title, this.voidCallback})
      : assert(title != null);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.only(right: 16),
        width: MediaQuery.of(context).size.width,
        height: 48,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: title,
            ),
            SizedBox(
              width: 8,
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 16,
            )
          ],
        ),
      ),
      onTap: voidCallback,
    );
  }
}
