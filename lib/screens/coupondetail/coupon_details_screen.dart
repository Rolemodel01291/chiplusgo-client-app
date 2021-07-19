import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infishare_client/blocs/auth_bloc/bloc.dart';
import 'package:infishare_client/blocs/blocs.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:infishare_client/models/models.dart';
import 'package:infishare_client/screens/mywalletscreen/confirm_payment_screen.dart';
import 'package:intl/intl.dart';
import 'vertical_listview.dart';
import 'bottom_bar_section.dart';

class CouponDetailsRoute extends StatefulWidget {
  final String title;
  final List<Coupon> coupons;
  final Business business;
  final int selectIndex;

  CouponDetailsRoute(
      {this.business, this.coupons, this.selectIndex, this.title = 'Coupons'});

  @override
  _CouponDetailsRouteState createState() => _CouponDetailsRouteState();
}

class _CouponDetailsRouteState extends State<CouponDetailsRoute>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  String _price = '';
  var f = NumberFormat("#,###,##0.00", "en_US");
  FirebaseAnalytics _analytics = FirebaseAnalytics();
  @override
  void initState() {
    _controller = TabController(
        initialIndex: widget.selectIndex,
        vsync: this,
        length: widget.coupons.length);
    _controller.addListener(() {
      setState(() {
        _price = f.format(widget.coupons[_controller.index].price);
      });
    });
    super.initState();
    _price = f.format(widget.coupons[widget.selectIndex].price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          widget.title,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: Size(0, 44),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 44,
            padding: EdgeInsets.only(left: 16, right: 16),
            child: TabBar(
              controller: _controller,
              labelColor: Color(0xFF242424),
              labelPadding: EdgeInsets.only(left: 16, right: 16),
              labelStyle: TextStyle(
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: TextStyle(),
              unselectedLabelColor: Color(0xFFacacac),
              indicatorColor: Color(0xFF242424),
              indicatorWeight: 4,
              indicatorSize: TabBarIndicatorSize.tab,
              isScrollable: true,
              tabs: _buildTabs(context),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: _buildTabviews(),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0.0,
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authstate) {
            return BottomAppBar(
                elevation: 0,
                child: BlocBuilder<MyAcountBloc, MyAcountState>(
                    builder: (context, state) {
                  return CouponBottomBar(
                    title: authstate is Autheticated
                        ? AppLocalizations.of(context).translate('Buy now') +
                            " • \$$_price"
                        : AppLocalizations.of(context)
                            .translate('Sign in to buy'),
                    oriPrice: "\$" +
                        f.format(widget.coupons[_controller.index].oriPrice),
                    onPress: state is MyAccountLoaded &&
                            (state.user.balance +
                                    state.user.creditlineBalance +
                                    state.user.pointsBalance / 10) >=
                                double.parse(_price)
                        ? () async {
                            authstate is Autheticated
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => ConfirmPaymentScreen(
                                              amount: double.parse(_price),
                                              client: state.user,
                                              business: widget.business,
                                              coupon: widget
                                                  .coupons[_controller.index],
                                            )))
                                : Navigator.of(context).pushNamed(
                                    '/auth',
                                  );
                            // ? Navigator.of(context).pushNamed(
                            //     '/check_out',
                            //     arguments: {
                            //       'business': widget.business,
                            //       'coupon': widget.coupons[_controller.index],
                            //     },
                            await _analytics.logAddToCart(
                              itemId:
                                  widget.coupons[_controller.index].couponId,
                              itemCategory: '',
                              itemName: widget.coupons[_controller.index].name,
                              quantity: 1,
                              price: widget.coupons[_controller.index].price,
                            );
                          }
                        : null,
                  );
                }));
          },
        ),
      ),
    );
  }

  List<Widget> _buildTabs(BuildContext context) {
    return widget.coupons.map((coupon) {
      return Text(AppLocalizations.of(context).locale.languageCode == 'en'
          ? coupon.name
          : coupon.nameCn);
    }).toList();
  }

  List<Widget> _buildTabviews() {
    return widget.coupons.map((coupon) {
      return CouponDetailsVerticalListview(
        coupon: coupon,
        business: widget.business,
      );
    }).toList();
  }
}
