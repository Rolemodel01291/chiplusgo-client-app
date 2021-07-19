import 'package:flutter/material.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsSection extends StatelessWidget {
  const TermsSection();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            AppLocalizations.of(context).locale.languageCode == "en"
                ? "1. When purchase in InfiShare App, InfiCash is taken as the same value of US dollar\n2. InfiCash can be only used to purchase in InfiShare App, can not be withdrawed or transferred"
                : "1. 当使用Inficash时，Inficash与美元价值对等。\n2. Inficash只能在InfiShare App内使用，不可取出或是转账。",
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFFACACAC),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          GestureDetector(
            onTap: () async {
              const url = 'https://www.infishareapp.com/terms-conditions';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                print('Could not launch $url');
              }
            },
            child: Container(
              padding: EdgeInsets.all(0),
              child: Text(
                AppLocalizations.of(context).translate("Terms & Conditions"),
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF266EF6),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
