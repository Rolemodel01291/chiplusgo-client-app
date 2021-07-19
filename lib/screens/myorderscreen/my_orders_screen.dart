import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infishare_client/blocs/auth_bloc/auth_bloc.dart';
import 'package:infishare_client/blocs/auth_bloc/bloc.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:infishare_client/repo/utils/firebase_consts.dart';
import 'coupon_card_section.dart';

class OrderRoute extends StatefulWidget {
  const OrderRoute();

  @override
  OrderRouteState createState() => OrderRouteState();
}

class OrderRouteState extends State<OrderRoute> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Autheticated) {
          return ListView(
            padding: EdgeInsets.all(16),
            children: <Widget>[
              CouponCardWidget(
                title: AppLocalizations.of(context).translate('My Coupons'),
                tip: AppLocalizations.of(context).translate('CouponHint'),
                startColor: Color(0xFFCB1935),
                endColor: Color(0xFF720D34),
                type: FirestoreConstants.GROUP_BUY,
              ),
              SizedBox(
                height: 16,
              ),
              CouponCardWidget(
                title: AppLocalizations.of(context).translate('MyVoucher'),
                tip: AppLocalizations.of(context).translate('VoucherHint'),
                startColor: Color(0xFFFFC247),
                endColor: Color(0xFFF8703E),
                type: FirestoreConstants.VOUCHER,
              ),
              SizedBox(
                height: 16,
              ),
              CouponCardWidget(
                title: AppLocalizations.of(context).translate('MyPasses'),
                tip: "",
                startColor: Color(0xFF34C6D2),
                endColor: Color(0xFF5A83BE),
                type: FirestoreConstants.TICKET,
              ),
              SizedBox(
                height: 16,
              ),
            ],
          );
        } else {
          return _buildNoAccountPlaceholder(context);
        }
      },
    );
  }

  Widget _buildNoAccountPlaceholder(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/nouser.png',
                width: 300.0,
                height: 300.0,
                fit: BoxFit.cover,
              ),
              SizedBox(
                height: 16.0,
              ),
              Text(
                AppLocalizations.of(context).translate('Sign up now to get'),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              Text(
                '\$5',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              Container(
                height: 50,
                child: RaisedButton(
                  color: Color(0xff242424),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    AppLocalizations.of(context).translate('Sign In/Sign Up'),
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/auth');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
