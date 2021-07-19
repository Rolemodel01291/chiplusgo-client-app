import 'dart:async';

import 'package:extended_image/extended_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:infishare_client/models/banner.dart' as appbanner;
import 'package:infishare_client/screens/commen_widgets/utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:developer';

// top ads horizon listview section
class HomeTopAdsSection extends StatefulWidget {
  final appbanner.AppBanner appBanner;
  final ValueNotifier<double>
      notifier; // notified by the HomeTopHorizonListSection's horizon scroll offset
  final double whRatio;

  HomeTopAdsSection(
      {Key key,
      @required this.appBanner,
      @required this.notifier,
      @required this.whRatio})
      : super(key: key);

  @override
  _TopHorizonListSectionState createState() => _TopHorizonListSectionState();
}

class _TopHorizonListSectionState extends State<HomeTopAdsSection>
    with TickerProviderStateMixin {
  ScrollController _controller;
  ScrollPhysics _physics;

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(() {
      // define _physics for pageView effect
      if (_controller.position.haveDimensions && _physics == null) {
        setState(() {
          var dimension = _controller.position.maxScrollExtent /
              (widget.appBanner.topBanner.length - 1);
          _physics = CustomScrollPhysics(itemDimension: dimension);
        });
      }
      // share horizon scroll value
      widget.notifier.value = _controller.offset;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0.0),
      height: (MediaQuery.of(context).size.width - 32) * widget.whRatio,
      child: ListView.builder(
        key: PageStorageKey("home__TopHorizonListSection"),
        controller: _controller,
        physics: _physics,
        padding: const EdgeInsets.only(
            left: 8,
            right:
                16), //the padiing 8 leaves space for _HorizonListItem's sizebox
        itemCount: widget.appBanner.topBanner.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return _HorizonListItem(
              banner: widget.appBanner.topBanner[index],
              whRatio: widget.whRatio);
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _HorizonListItem extends StatelessWidget {
  final appbanner.Banner banner;
  final double whRatio;
  const _HorizonListItem({
    Key key,
    @required this.banner,
    @required this.whRatio,
  })  : assert(banner != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return WhiteInkwell(
      containWidget: Container(
        padding: const EdgeInsets.only(left: 0, right: 0),
        color: Colors.transparent,
        width: (MediaQuery.of(context).size.width - 32) +
            8, // total 16 with listview's left padding
        height: (MediaQuery.of(context).size.width - 32) * whRatio,
        child: Row(children: <Widget>[
          SizedBox(width: 8),
          ClipRRect(
            borderRadius: new BorderRadius.circular(15.0),
            child: ExtendedImage.network(
              banner.image,
              width: (MediaQuery.of(context).size.width - 32),
              //16:9
              height: (MediaQuery.of(context).size.width - 32) * whRatio,
              // use fit to fulfill the box
              fit: BoxFit.cover,
              cache: true,
            ),
          )
        ]),
      ),
      // tapFunction: () async {
      //   // log('data: ======================== ${banner.arguments['BusinessId'][0]}');
      //   Navigator.of(context).pushNamed(
      //     banner.router,
      //     arguments: banner.arguments,
      //   );
      //   // if (banner.url != '') {
      //   //   FirebaseAnalytics().logViewItem(itemId: banner.url, itemName: 'URL',itemCategory: 'URL');
      //   //   if (await canLaunch(banner.url)) {
      //   //     await launch(banner.url);
      //   //   }
      //   // } else if (banner.router != null && banner.router.isNotEmpty) {
      //   //   FirebaseAnalytics().logViewItem(itemId: banner.router, itemName: 'ROUTER',itemCategory: 'ROUTER');
      //   //   Navigator.of(context).pushNamed(
      //   //     banner.router,
      //   //     arguments: banner.arguments,
      //   //   );
      //   // }
      // },
      backGroundColor: Colors.transparent,
    );
  }
}
