import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infishare_client/blocs/main_page_bloc/bloc.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:infishare_client/screens/commen_widgets/error_placeholder_page.dart';
import 'package:infishare_client/screens/commen_widgets/placeholder_widget.dart';
import "home_main_vertical_list_section.dart";
import 'home_background_section.dart';
import 'home_search_bar_widget.dart';

class HomeRoute extends StatefulWidget {
  const HomeRoute();
  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  final double whRatio = 0.5625;
  // sharing with BackGroundView() and MainVerticalListView() and SearchBar()
  ValueNotifier<double> horizonScrollValueNotifier = ValueNotifier(0);
  // sharing with BackGroundView() and MainVerticalListView() and SearchBar()
  ValueNotifier<double> verticalScrollValueNotifier = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    this.initDynamicLinks();
    _pullRefresh();
  }

  void initDynamicLinks() async {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      print('On receive' + deepLink.toString());
      if (deepLink.toString().contains('coupon')) {
        final data = deepLink.path.split("/");
        Navigator.of(context).pushNamed('/single_coupon', arguments: {
          'businessId': data[1],
          'couponId': data[2],
        });
      }
    }

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;

      if (deepLink != null) {
        print("On link " + deepLink.path);
        if (deepLink.toString().contains('coupon')) {
          final data = deepLink.path.split("/");
          Navigator.of(context).pushNamed('/single_coupon', arguments: {
            'businessId': data[1],
            'couponId': data[2],
          });
        }
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });
  }

  Future<void> _pullRefresh() async {
    BlocProvider.of<MainPageBloc>(context).add(
      FetchMainData(),
    );
    // why use freshWords var? https://stackoverflow.com/a/52992836/2301224
  }

  @override
  Widget build(BuildContext context) {
    // FirebaseInAppMessaging firebaseInAppMessaging = FirebaseInAppMessaging();
    // firebaseInAppMessaging.triggerEvent("on_foreground");
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      // the grey background of home_route
      child: BlocBuilder<MainPageBloc, MainPageState>(
        builder: (context, state) {
          if (state is BaseMainPageState) {
            return Stack(
              children: <Widget>[
                //HomeBGView slide up when vertical listview scroll up
                ValueListenableBuilder(
                    valueListenable: verticalScrollValueNotifier,
                    builder:
                        (BuildContext context, double value, Widget child) {
                      return Positioned(
                        right: 0,
                        top: 0,
                        left: 0,
                        // 64 is the app bar container height
                        // 16 is the image bottom to background bottom
                        bottom: verticalScrollValueNotifier.value +
                            MediaQuery.of(context).size.height -
                            (MediaQuery.of(context).padding.top +
                                64 +
                                whRatio *
                                    (MediaQuery.of(context).size.width - 32)) -
                            16,
                        child: HomeBackGroundView(
                            appBanner: state.appBanner,
                            notifier: horizonScrollValueNotifier,
                            whRatio: whRatio),
                      );
                    }),
                Positioned(
                  left: 0,
                  right: 0,
                  // 64 is the app bar container height
                  // top: MediaQuery.of(context).padding.top + 64,
                  top: MediaQuery.of(context).padding.top + 8,
                  bottom: 0,
                  child: MainVerticalListView(
                    appBanner: state.appBanner,
                    horizonNotifier: horizonScrollValueNotifier,
                    verticalNotifier: verticalScrollValueNotifier,
                    whRatio: whRatio,
                    reorders: state.recentOrder,
                    // bestSales: state.bestSell,
                    mostDiscount: state.mostDiscount,
                    // newCoupons: state.newToHere,
                    // recmdBusiness: state.recmdBusiness,
                    // newBusiness: state.newBusiness,
                    // hotBusiness: state.hottestBusiness,
                    // nearByBusiness: state.nearbyBusiness,
                    // category: state.category,
                  ),
                ),
                // Positioned(
                //   left: 0,
                //   right: 0,
                //   top: 0,
                //   child: HomeSearchBarWidget(
                //     title: AppLocalizations.of(context).translate('SearchHint'),
                //     verticalNotifier: verticalScrollValueNotifier,
                //     horizonNotifier: horizonScrollValueNotifier,
                //     whRatio: whRatio,
                //   ),
                // ),
              ],
            );
          }

          if (state is MainPageLocationRequire) {
            return Center(
              child: ErrorPlaceHolder(
                AppLocalizations.of(context).translate('LocationPermission'),
                imageName: 'assets/svg/location_denid.svg',
                onTap: () {
                  BlocProvider.of<MainPageBloc>(context).add(
                    FetchMainData(),
                  );
                },
              ),
            );
          }

          if (state is MainPageError) {
            return Center(
              child: ErrorPlaceHolder(
                state.errorMsg,
                onTap: () {
                  BlocProvider.of<MainPageBloc>(context).add(
                    FetchMainData(),
                  );
                },
              ),
            );
          }

          if (state is MainPageLoading) {
            return ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(16),
                  child: SearchPlaceholderWidget(),
                ),
                SizedBox(
                  height: 32,
                ),
                AdPlaceholderWidget(),
                SizedBox(
                  height: 64,
                ),
                CouponPlaceholderWidget(),
                SizedBox(
                  height: 64,
                ),
                CouponPlaceholderWidget(),
              ],
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    horizonScrollValueNotifier.dispose();
    verticalScrollValueNotifier.dispose();
    super.dispose();
  }
}
