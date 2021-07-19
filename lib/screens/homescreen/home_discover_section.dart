import 'package:flutter/material.dart';
import 'package:infishare_client/language/app_localization.dart';

class HomeDiscoverSection extends StatelessWidget {
  // final List<String> categorys;

  // const HomeDiscoverSection({this.categorys});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            AppLocalizations.of(context).translate('Discover'),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF242424),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    '/home_discover',
                    arguments: {
                      'categorys': List<String>(0),
                      'prefix': 'Restaurant',
                      'title':
                          AppLocalizations.of(context).translate('Restaurant'),
                    },
                  );
                },
                child: _DiscoverItem(
                  iconImgName: "restaurant",
                  iconName:
                      AppLocalizations.of(context).translate('Restaurant'),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    '/home_discover',
                    arguments: {
                      'categorys': List<String>(0),
                      'prefix': 'Active',
                      'title':
                          AppLocalizations.of(context).translate('ActiveLife'),
                    },
                  );
                },
                child: _DiscoverItem(
                  iconImgName: "life",
                  iconName:
                      AppLocalizations.of(context).translate('ActiveLife'),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    '/home_discover',
                    arguments: {
                      'categorys': List<String>(0),
                      'prefix': 'Beauty',
                      'title': AppLocalizations.of(context).translate('Beauty'),
                    },
                  );
                },
                child: _DiscoverItem(
                  iconImgName: "beauty",
                  iconName: AppLocalizations.of(context).translate('Beauty'),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    '/home_discover',
                    arguments: {
                      'categorys': List<String>(0),
                      'prefix': 'Tourism',
                      'title':
                          AppLocalizations.of(context).translate('Tourism'),
                    },
                  );
                },
                child: _DiscoverItem(
                  iconImgName: "tourism",
                  iconName: AppLocalizations.of(context).translate('Tourism'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _DiscoverItem extends StatelessWidget {
  final String iconImgName;
  final String iconName;
  const _DiscoverItem({@required this.iconImgName, @required this.iconName});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/images/$iconImgName.png',
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            iconName,
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF242424),
            ),
          ),
        ],
      ),
    );
  }
}
