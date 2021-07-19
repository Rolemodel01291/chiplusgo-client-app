import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:infishare_client/models/business.dart';
import 'package:url_launcher/url_launcher.dart';
import 'custom_scroll_physics.dart' as Physics;

class BusinessExploreViewSection extends StatelessWidget {
  final Business business;

  BusinessExploreViewSection({this.business});

  static const exploreHeight = 261.0;
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        height: exploreHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: Row(
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context).translate('Explore'),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
            GestureDetector(
              onTap: () async {
                if (await canLaunch(
                    AppLocalizations.of(context).locale.languageCode == 'en'
                        ? business.businessArticle
                        : business.businessArticleCn)) {
                  await launch(
                      AppLocalizations.of(context).locale.languageCode == 'en'
                          ? business.businessArticle
                          : business.businessArticleCn);
                }
              },
              child: Container(
                child: Container(
                  color: Colors.white,
                  child: Stack(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image(
                          height: 180,
                          width: MediaQuery.of(context).size.width - 32,
                          image: ExtendedNetworkImageProvider(
                            business.images.length > 0
                                ? business.images.last
                                : '',
                            cache: true,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        height: 180,
                        width: MediaQuery.of(context).size.width - 32,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Colors.black38, Colors.transparent],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 16,
                        bottom: 8,
                        right: 16,
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              Text(
                                (AppLocalizations.of(context)
                                            .locale
                                            .languageCode ==
                                        'en'
                                    ? business.businessName['English']
                                    : business.businessName['Chinese']),
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                              Spacer(),
                              Text(
                                '',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BusinessExplorePageView extends StatefulWidget {
  final Business business;

  BusinessExplorePageView({
    Key key,
    this.business,
  }) : super(key: key);

  @override
  _BusinessExploreViewState createState() => _BusinessExploreViewState();
}

class _BusinessExploreViewState extends State<BusinessExplorePageView>
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
          // var dimension = _controller.position.maxScrollExtent /
          //     (widget.listItems.length - 1);
          var dimension = _controller.position.maxScrollExtent / (3 - 1);
          _physics = Physics.CustomScrollPhysics(itemDimension: dimension);
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 198,
        alignment: Alignment.center,
        child: ListView.builder(
          padding: const EdgeInsets.only(left: 8, right: 16),
          controller: _controller,
          physics: _physics,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Row(
              children: <Widget>[
                SizedBox(
                  width: 8,
                ),
                Container(
                  color: Colors.blue,
                  child: Stack(
                    children: <Widget>[
                      Image(
                        height: 180,
                        width: MediaQuery.of(context).size.width - 32,
                        image: ExtendedNetworkImageProvider(
                            "https://upload.wikimedia.org/wikipedia/en/7/7e/Kimetsu_no_Yaiba_Blu-ray_Disc_Box_1_art.jpg",
                            cache: true),
                        fit: BoxFit.cover,
                      ),
                      Container(
                        height: 180,
                        width: MediaQuery.of(context).size.width - 32,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                              Color.fromRGBO(36, 36, 36, 0.8),
                              Colors.transparent
                            ])),
                      ),
                      Positioned(
                        left: 16,
                        bottom: 8,
                        right: 16,
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              Text(
                                'How To Eat Hotpot',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                              Spacer(),
                              Text(
                                '',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          },
          itemCount: 3,
        ));
  }
}
