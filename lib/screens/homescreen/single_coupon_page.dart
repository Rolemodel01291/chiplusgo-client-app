import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infishare_client/blocs/auth_bloc/bloc.dart';
import 'package:infishare_client/blocs/blocs.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:infishare_client/screens/commen_widgets/error_placeholder_page.dart';
import 'package:infishare_client/screens/coupondetail/bottom_bar_section.dart';
import 'package:infishare_client/screens/coupondetail/bottom_sold_bar_section.dart';
import 'package:infishare_client/screens/coupondetail/vertical_listview.dart';
import 'package:infishare_client/screens/mywalletscreen/confirm_payment_screen.dart';
import 'package:intl/intl.dart';

class SingleCouponPage extends StatefulWidget {
  final String title;

  SingleCouponPage({this.title = 'Coupons'});

  @override
  _SingleCouponPageState createState() => _SingleCouponPageState();
}

bool isBeforeToday(DateTime timestamp) {
  print(timestamp);
  return DateTime.now().toUtc().isBefore(
        DateTime.fromMillisecondsSinceEpoch(
          timestamp.millisecondsSinceEpoch,
          isUtc: false,
        ).toUtc(),
      );
}

class _SingleCouponPageState extends State<SingleCouponPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  var f = NumberFormat("#,###,##0.00", "en_US");

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SingleCouponDetailBloc, SingleCouponDetailState>(
      builder: (context, state) {
        if (state is SingleCouponLoading) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              title: Text(
                widget.title,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              backgroundColor: Colors.white,
            ),
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color(0xff242424),
                ),
              ),
            ),
          );
        }

        if (state is SingleCouponLoadError) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              title: Text(
                widget.title,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              backgroundColor: Colors.white,
            ),
            body: Center(
              child: ErrorPlaceHolder(
                state.errorMsg,
                onTap: () {
                  BlocProvider.of<SingleCouponDetailBloc>(context).add(
                    FetchCouponAndBusiness(),
                  );
                },
              ),
            ),
          );
        }

        if (state is SingleCouponLoaded) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              title: Text(
                AppLocalizations.of(context).locale.languageCode == 'en'
                    ? state.coupon.name
                    : state.coupon.nameCn,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              backgroundColor: Colors.white,
            ),
            body: CouponDetailsVerticalListview(
              coupon: state.coupon,
              business: state.business,
            ),
            bottomNavigationBar: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, authstate) {
                if (state.coupon.soldCnt < state.coupon.quantity)
                  return BottomAppBar(
                      elevation: 0,
                      child: BlocBuilder<MyAcountBloc, MyAcountState>(
                          builder: (context, accountState) {
                        return CouponBottomBar(
                          title: authstate is Autheticated
                              ? AppLocalizations.of(context)
                                      .translate('Buy now') +
                                  " • \$${f.format(state.coupon.price + state.coupon.tax)}"
                              : AppLocalizations.of(context)
                                  .translate('Sign in to buy'),
                          oriPrice: "\$" + f.format(state.coupon.oriPrice),
                          onPress: isBeforeToday(state.coupon.getEndDate()) &&
                                  accountState is MyAccountLoaded &&
                                  (accountState.user.balance +
                                          accountState.user.creditlineBalance +
                                          accountState.user.pointsBalance /
                                              10) >=
                                      (state.coupon.price + state.coupon.tax)
                              ? () {
                                  authstate is Autheticated
                                      ? Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  ConfirmPaymentScreen(
                                                      amount:
                                                          state.coupon.price +
                                                              state.coupon.tax,
                                                      client: accountState.user,
                                                      business: state.business,
                                                      businessId: state
                                                          .coupon.businessId,
                                                      coupon: state.coupon)))
                                      : Navigator.of(context).pushNamed(
                                          '/auth',
                                        );
                                  // authstate is Autheticated
                                  //     ? Navigator.of(context).pushNamed(
                                  //         '/check_out',
                                  //         arguments: {
                                  //           'business': state.business,
                                  //           'coupon': state.coupon,
                                  //         },
                                  //       )
                                  //     : Navigator.of(context).pushNamed(
                                  //         '/auth',
                                  //       );
                                }
                              : null,
                        );
                      }));
                if (state.coupon.soldCnt >= state.coupon.quantity)
                  return BottomAppBar(
                      elevation: 0,
                      child: BlocBuilder<MyAcountBloc, MyAcountState>(
                          builder: (context, accountState) {
                        return CouponSoldBottomBar(
                          title: authstate is Autheticated
                              ? AppLocalizations.of(context)
                                  .translate('Sold Out')
                              : AppLocalizations.of(context)
                                  .translate('Sign in to buy'),
                          oriPrice: "\$" + f.format(state.coupon.oriPrice),
                          onPress: () {},
                        );
                      }));
              },
            ),
          );
        }
      },
    );
  }
}
