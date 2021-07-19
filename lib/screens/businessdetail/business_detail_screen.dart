import 'package:extended_image/extended_image.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infishare_client/blocs/blocs.dart';
import 'package:infishare_client/blocs/business_detail_bloc.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:infishare_client/models/coupon.dart';
import 'package:infishare_client/models/models.dart';
import 'package:infishare_client/screens/businessdetail/business_about_section.dart';
import 'package:infishare_client/screens/businessdetail/business_basicInfo_listtile.dart';
import 'package:infishare_client/screens/businessdetail/business_coupon_section.dart';
import 'package:infishare_client/screens/businessdetail/business_header_image.dart';
import 'package:infishare_client/screens/businessdetail/business_press_section.dart';
import 'package:infishare_client/screens/businessdetail/business_recommendation_section.dart';
import 'package:url_launcher/url_launcher.dart';

import 'business_basicinfo_title.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'business_explore_section.dart';
import 'business_hour_list.dart';

class BusinessDetailScreen extends StatefulWidget {
  //final Map<String, String> title;

  BusinessDetailScreen();

  @override
  State<StatefulWidget> createState() {
    return _BusinessDetailState();
  }
}

class _BusinessDetailState extends State<BusinessDetailScreen>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollController;
  TabController _tabController;
  bool showShadow = false;
  WifiBloc _wifiBloc;

  // List<Coupon> coupons = [];
  // List<Coupon> vouchers = [];
  // List<Business> nearbyBusiness = [];

  //*business header height(including basic info list view)
  double _headerHeight = 718;
  //*business full menu height
  double _fullMenuHeight = 342.0;
  //*business explore section height
  double exploreSectionHeight = 261.0;
  //* press section height
  double _pressHeight = 0;
  //* story section height
  double _storyHeight = 0;

  //* separator height
  final double _separatorHeight = 16.0;
  double couponSectionHeight = 0.0;
  double voucherSectionHeight = 0.0;
  double aboutSectionHeight = 0.0;

  //*
  //* Function Touch tabbar to navigate to sections (Deals, About, Reviews)
  //*
  _scrollListener() {
    if (_scrollController.offset < _headerHeight) {
      if (showShadow) {
        setState(() {
          showShadow = false;
        });
      }
    } else {
      if (!showShadow) {
        setState(() {
          showShadow = true;
        });
      }
    }
    if (_scrollController.offset < _caculateDealsBottomOffset()) {
      _tabController.animateTo(0);
    }

    if (_scrollController.offset >= _caculateDealsBottomOffset() &&
        _scrollController.offset < _caculateAboutBottomOffset()) {
      _tabController.animateTo(1);
    }

    // if (_scrollController.offset >= _caculateAboutBottomOffset()) {
    //   _tabController.animateTo(2);
    // }
  }

  _onCouponHeightChanged(double height) {
    couponSectionHeight = height;
  }

  _onVoucherHeightChanged(double height) {
    voucherSectionHeight = height;
  }

  double _caculateDealsBottomOffset() {
    return couponSectionHeight + voucherSectionHeight + _headerHeight;
  }

  double _caculateAboutBottomOffset() {
    return _caculateDealsBottomOffset() +
        _separatorHeight +
        _storyHeight +
        _pressHeight;
    // _fullMenuHeight +
    // exploreSectionHeight;
  }
  //*
  //* End
  //*

  @override
  void initState() {
    _scrollController = ScrollController();
    _tabController = TabController(length: 2, vsync: this);
    _scrollController.addListener(_scrollListener);
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.black));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _wifiBloc = BlocProvider.of<WifiBloc>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: showShadow ? 0.0 : 1.0,
        backgroundColor: Colors.white,
        // title: Text(
        //   AppLocalizations.of(context).locale.languageCode == "en"
        //       ? widget.title["English"]
        //       : widget.title["Chinese"],
        //   style: TextStyle(color: Colors.black),
        // ),
      ),
      body: BlocBuilder<BusinessDetailBloc, BusinessDetailState>(
        builder: (context, state) {
          if (state is BusinessDetailLoading) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(
                  Color(0xff242424),
                ),
              ),
            );
          }
          if (state is BusinessDetailError) {
            return _buildErrorPage(
                'assets/svg/search_error.svg', state.errorMsg, null);
          }
          if (state is BusinessDetailLoaded) {
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              controller: _scrollController,
              slivers: _buildDetailBody(
                state.business,
                state.coupons,
                state.vouchers,
                state.nearbyBusinesses,
              ),
            );
          }
        },
      ),
    );
  }

  List<Widget> _buildDetailBody(Business business, List<Coupon> coupons,
      List<Coupon> vouchers, List<Business> nearbyBusinesses) {
    List<Widget> retVal = [];
    retVal.add(_buildHeaderDetailView(business));
    retVal.add(_buildBasicInfoList(business));
    retVal.add(_buildHeadTab());

    if (coupons.length > 0) {
      retVal.add(BusinessCouponSection(
        business: business,
        onHeightChanged: _onCouponHeightChanged,
        coupon: coupons,
        title: AppLocalizations.of(context).translate('Coupon'),
      ));
      retVal.add(_buildSepartor());
    }

    if (vouchers.length > 0) {
      retVal.add(BusinessCouponSection(
        business: business,
        onHeightChanged: _onVoucherHeightChanged,
        coupon: vouchers,
        title: AppLocalizations.of(context).translate('Voucher'),
      ));
      retVal.add(_buildSepartor());
    }

    if (business.story != null) {
      _storyHeight = BusinessStoryListTile.storyHeight + _separatorHeight;
      retVal.add(
        BusinessStoryListTile(
          content: business.story['Content'],
          url: business.story['Url'],
        ),
      );
      retVal.add(_buildSepartor());
    }

    //TODO: Check if business have full menu
    //TODO: Check if business have explore

    if (business.press != null && business.press.length > 0) {
      _pressHeight = BusinessPressSection.titleHeight +
          business.press.length * BusinessPressSection.pressHeight +
          _separatorHeight;
      retVal.add(BusinessPressSection());
      retVal.add(_buildSepartor());
    }

    if (business.businessArticle != null &&
        business.businessArticle.isNotEmpty) {
      retVal.add(
        BusinessExploreViewSection(
          business: business,
        ),
      );
      retVal.add(_buildSepartor());
    }

    retVal.addAll([
      // BusinessReviewSection(),
      // _buildSepartor(),
      BusinessRecommendationSection(
        businesses: nearbyBusinesses,
      )
    ]);

    return retVal;
  }

  Widget _buildErrorPage(
      String imageName, String description, VoidCallback onTap) {
    final Widget svgImage = new SvgPicture.asset(
      imageName,
    );
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            svgImage,
            Text(
              description,
              style: TextStyle(fontSize: 18, color: Color(0xffacacac)),
              textAlign: TextAlign.center,
            ),
            onTap != null
                ? FlatButton.icon(
                    //shape: ,
                    icon: Icon(Icons.refresh),
                    label: Text(
                      AppLocalizations.of(context).translate('Retry'),
                      style: TextStyle(fontSize: 16),
                    ),
                    onPressed: onTap,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderDetailView(Business business) {
    return SliverToBoxAdapter(
      child: Container(
        height: 445,
        margin: EdgeInsets.only(bottom: 16),
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                BusinessHeaderImage(
                  imageUrls: business.images.length > 0 ? business.images : [],
                ),
                Flexible(
                  child: BusinessDetailTitle(
                    business: business,
                  ),
                )
              ],
            ),
            Positioned(
              left: 16,
              top: 230,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 2.0, // has the effect of softening the shadow
                      spreadRadius:
                          0.0, // has the effect of extending the shadow
                      offset: Offset(
                        0.0, // horizontal, move right 10
                        0.0, // vertical, move down 10
                      ),
                    )
                  ],
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: ExtendedNetworkImageProvider(
                        (business.logo != null && business.logo.isNotEmpty)
                            ? business.logo
                            : business.images.length > 0
                                ? business.images.first
                                : '',
                        cache: true),
                  ),
                ),
              ),
            ),
          ],
          fit: StackFit.expand,
        ),
      ),
    );
  }

  Widget _buildBasicInfoList(Business business) {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.only(bottom: 16),
        child: Column(
          children: <Widget>[
            BusinessHourListTile(
              isOpenNow: business.openHour.isOpen,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return BusinessHourList(
                        openHour: business.openHour,
                      );
                    },
                  ),
                );
              },
            ),
            Container(
              color: Colors.grey,
              height: 0.5,
              margin: EdgeInsets.only(left: 56),
            ),
            BusinessInfoTile(
              iconData: Icons.pin_drop,
              content: business.getDisplayAddress(),
              onTap: () async {
                _openMap(business);
              },
            ),
            Container(
              color: Colors.grey,
              height: 0.5,
              margin: EdgeInsets.only(left: 56),
            ),
            BusinessInfoTile(
              iconData: Icons.phone,
              content: business.phone == ""
                  ? AppLocalizations.of(context).translate('Unavaliable')
                  : business.phone,
              onTap: () async {
                _openPhone(business);
              },
            ),
            Container(
              color: Colors.grey,
              height: 0.5,
              margin: EdgeInsets.only(left: 56),
            ),
            BlocBuilder<WifiBloc, WifiState>(
              builder: (context, state) {
                return BusinessWifiInfoTile(
                  status: state,
                  wifiSsid:
                      (business.labels.wifi != null && business.labels.wifi)
                          ? business.wifiInfo.ssid
                          : '',
                  onTap: () {
                    _wifiBloc.add(
                      ChangeWifiState(
                          ssid: business.wifiInfo.ssid,
                          pwd: business.wifiInfo.password),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeadTab() {
    return SliverPersistentHeader(
      delegate: _SliverAppBarDelegate(
          TabBar(
            indicatorPadding: EdgeInsets.only(left: 16.0),
            controller: _tabController,
            labelColor: Colors.black87,
            unselectedLabelColor: Colors.grey,
            isScrollable: true,
            onTap: (index) {
              if (index == 0) {
                _scrollController.animateTo(_headerHeight,
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeInOut);
              }

              if (index == 1) {
                _scrollController.animateTo(
                    couponSectionHeight +
                        voucherSectionHeight +
                        _separatorHeight * 2 +
                        _headerHeight,
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeInOut);
              }

              // if (index == 2) {
              //   _scrollController.animateTo(_caculateAboutBottomOffset(),
              //       duration: const Duration(milliseconds: 600),
              //       curve: Curves.easeInOut);
              // }
            },
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.local_offer),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      AppLocalizations.of(context).translate('Deals'),
                    ),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.store),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      AppLocalizations.of(context).translate('About'),
                    ),
                  ],
                ),
              ),
              // Tab(
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: <Widget>[
              //       Icon(Icons.rate_review),
              //       SizedBox(
              //         width: 8,
              //       ),
              //       Text('Reviews'),
              //     ],
              //   ),
              // ),
            ],
          ),
          showShadow),
      pinned: true,
    );
  }

  Widget _buildSepartor() {
    return SliverToBoxAdapter(
      child: Container(
        height: 16,
      ),
    );
  }

  void _openMap(Business business) async {
    var lat = business.location['lat'];
    var lng = business.location['lng'];
    String url = 'geo:$lat,$lng';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // iOS
      url =
          'http://maps.apple.com/?daddr=${business.getMapQueryString()}&dirflg=d&t=m';
      print(url);
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  void _openPhone(Business business) async {
    // Android
    String uri = 'tel:${business.phone}';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      // iOS
      uri = 'tel:${business.phone}';
      if (await canLaunch(uri)) {
        await launch(uri);
      } else {
        throw 'Could not launch $uri';
      }
    }
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar, this._showShadow);
  final TabBar _tabBar;
  final bool _showShadow;

  @override
  double get minExtent => _tabBar.preferredSize.height + 0.5;
  @override
  double get maxExtent => _tabBar.preferredSize.height + 0.5;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _tabBar,
            Container(
              height: 0.5,
              color: _showShadow ? Color(0xffacacac) : Colors.white,
            )
          ],
        ));
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
