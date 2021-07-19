import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:infishare_client/models/business.dart';
import 'package:infishare_client/models/coupon_thumbnail.dart';
import 'package:infishare_client/models/coupon_ticket.dart';
import 'package:infishare_client/models/models.dart';
import 'package:infishare_client/screens/businessdetail/custom_scroll_physics.dart';
import 'package:url_launcher/url_launcher.dart';
import "home_shop_section.dart";
import "home_coupons_section.dart";
import 'home_discover_section.dart';
import 'home_ad_section.dart';
import 'home_top_ads_section.dart';
import 'package:infishare_client/models/banner.dart' as appbanner;

// main vertical listview, contains all sections
class MainVerticalListView extends StatefulWidget {
  final appbanner.AppBanner
      appBanner; // the background images and related background colors
  final ValueNotifier<double>
      horizonNotifier; // notified by the HomeTopHorizonListSection's horizon scroll offset
  final ValueNotifier<double>
      verticalNotifier; // notified by the MainVerticalListView's vertical scroll offset
  final double whRatio;
  final List<CouponTicket> reorders;
  // final List<CouponThumbnail> bestSales;
  final List<CouponThumbnail> mostDiscount;
  // final List<CouponThumbnail> newCoupons;
  // final List<Business> recmdBusiness;
  // final List<Business> newBusiness;
  // final List<Business> hotBusiness;
  // final List<Business> nearByBusiness;
  // final RestaurantCategory category;
  const MainVerticalListView({
    Key key,
    @required this.appBanner,
    @required this.horizonNotifier,
    @required this.verticalNotifier,
    @required this.whRatio,
    // this.category,
    this.reorders,
    // this.bestSales,
    this.mostDiscount,
    // this.newCoupons,
    // this.recmdBusiness,
    // this.newBusiness,
    // this.hotBusiness,
    // this.nearByBusiness,
  }) : super(key: key);

  _MainVerticalListViewState createState() => _MainVerticalListViewState();
}

class _MainVerticalListViewState extends State<MainVerticalListView> {
  ScrollController _controller;
  ScrollController _midController;
  ScrollPhysics _physics;
  @override
  void initState() {
    _controller = ScrollController();
    _midController = ScrollController();
    _controller.addListener(() {
      widget.verticalNotifier.value = _controller.offset;
    });
    _midController.addListener(() {
      // define _physics for pageView effect
      if (_midController.position.haveDimensions && _physics == null) {
        setState(() {
          var dimension = _midController.position.maxScrollExtent /
              (widget.appBanner.midBanner.length - 1);
          _physics = CustomScrollPhysics(itemDimension: dimension);
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final categorys = widget.category
    //     .getCateList(AppLocalizations.of(context).locale.languageCode);
    // return ListView(
    //   physics: const AlwaysScrollableScrollPhysics(),
    //   controller: _controller,
    //   padding: const EdgeInsets.all(0),
    //   scrollDirection: Axis.vertical,
    //   children: _buildMainBody(),
    // );

    return Column(
      children: [
        HomeTopAdsSection(
          appBanner: widget.appBanner,
          notifier: widget.horizonNotifier,
          whRatio: whRatio,
        ),

        Padding(
          padding: EdgeInsets.fromLTRB(20, 40, 10, 10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              child: Text(
                AppLocalizations.of(context).translate('ChiGo Coupons'),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),

        // HomeDiscoverSection(),
        Expanded(
            child: Container(
          child: ListView.builder(
              controller: _midController,
              physics: _physics,
              key: PageStorageKey("home__MidHorizonListSection"),
              itemCount: widget.appBanner.midBanner.length,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 4, right: 4),
              itemBuilder: (BuildContext context, int index) {
                return HomeAdSection(
                  image: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: ExtendedImage.network(
                        widget.appBanner.midBanner[index].image,
                        // width: 100,
                        // height: 120,
                        cache: true,
                        fit: BoxFit.cover,
                      )),
                  onTap: () async {
                    final banner = widget.appBanner.midBanner[index];
                    if (banner.url != '') {
                      if (await canLaunch(banner.url)) {
                        await launch(banner.url);
                      }
                    } else if (banner.router != null &&
                        banner.router.isNotEmpty) {
                      Navigator.of(context).pushNamed(
                        banner.router,
                        arguments: banner.arguments,
                      );
                    }
                  },
                );
              }),
        )),
      ],
    );
  }

  List<Widget> _buildMainBody() {
    List<Widget> widgets = [
      HomeTopAdsSection(
        appBanner: widget.appBanner,
        notifier: widget.horizonNotifier,
        whRatio: whRatio,
      ),

      SizedBox(
        height: 16,
      ),

      HomeDiscoverSection(),
      // widget.nearByBusiness[0].distanceInKm < 0.02
      //     ? HomeWifiSection()
      //     : Container(),
      // SizedBox(
      //   height: 16,
      // ),
      // HomeCouponsSection(
      //   reorders: widget.reorders,
      //   discountCoupon: widget.mostDiscount,
      //   newCoupon: widget.newCoupons,
      //   bestSale: widget.bestSales,
      // ),
      // SizedBox(
      //   height: 16,
      // ),
    ];
    if (widget.appBanner.midBanner != null &&
        widget.appBanner.midBanner.length > 0) {
      widgets.add(Container(
        height: 228,
        child: ListView.builder(
            controller: _midController,
            physics: _physics,
            key: PageStorageKey("home__MidHorizonListSection"),
            itemCount: widget.appBanner.midBanner.length,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 4, right: 4),
            itemBuilder: (BuildContext context, int index) {
              return HomeAdSection(
                image: ExtendedImage.network(
                  widget.appBanner.midBanner[index].image,
                  width: MediaQuery.of(context).size.width - 16,
                  height: 228,
                  cache: true,
                  fit: BoxFit.cover,
                ),
                onTap: () async {
                  final banner = widget.appBanner.midBanner[index];
                  if (banner.url != '') {
                    if (await canLaunch(banner.url)) {
                      await launch(banner.url);
                    }
                  } else if (banner.router != null &&
                      banner.router.isNotEmpty) {
                    Navigator.of(context).pushNamed(
                      banner.router,
                      arguments: banner.arguments,
                    );
                  }
                },
              );
            }),
      ));
    }
    // if (widget.appBanner.midBanner != null &&
    //     widget.appBanner.midBanner.length > 0) {
    //   widgets.add(
    //     HomeAdSection(
    //       image: ExtendedImage.network(
    //         widget.appBanner.midBanner[0].image,
    //         width: MediaQuery.of(context).size.width,
    //         height: 228,
    //         cache: true,
    //         fit: BoxFit.cover,
    //       ),
    //       onTap: () async {
    //         final banner = widget.appBanner.midBanner[0];
    //         if (banner.url != '') {
    //           if (await canLaunch(banner.url)) {
    //             await launch(banner.url);
    //           }
    //         } else if (banner.router != null && banner.router.isNotEmpty) {
    //           Navigator.of(context).pushNamed(
    //             banner.router,
    //             arguments: banner.arguments,
    //           );
    //         }
    //       },
    //     ),
    //   );
    //   widgets.add(
    //     SizedBox(
    //       height: 16,
    //     ),
    //   );
    // }
    // widgets.add(
    //   HomeShopSection(
    //     recmdBusiness: widget.recmdBusiness,
    //     newBusiness: widget.newBusiness,
    //     hottestBusiness: widget.hotBusiness,
    //     nearbyBusiness: widget.nearByBusiness,
    //   ),
    // );

    return widgets;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
