import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infishare_client/blocs/blocs.dart';
import 'package:infishare_client/blocs/transaction_history/bloc.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:infishare_client/repo/payment_repo.dart';
import 'package:infishare_client/screens/commen_widgets/error_placeholder_page.dart';
import 'package:infishare_client/screens/mywalletscreen/wallet_card_section.dart';
import 'package:infishare_client/screens/mywalletscreen/recharge_route.dart';
import 'package:infishare_client/screens/mywalletscreen/transaction_history_route.dart';
import 'package:infishare_client/screens/mywalletscreen/transaction_history_section.dart';

import '../screens.dart';

class WalletRoute extends StatefulWidget {
  const WalletRoute();

  @override
  WalletRouteState createState() => WalletRouteState();
}

class WalletRouteState extends State<WalletRoute> {
  @override
  void initState() {
    super.initState();
  }

  MyAcountBloc _myAcountBloc;
  @override
  Widget build(BuildContext context) {
    return Container(child:
        BlocBuilder<MyAcountBloc, MyAcountState>(builder: (context, state) {
      if (state is MyAccountLoading) {
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Color(0xff242424),
            ),
          ),
        );
      }

      if (state is MyAccountLoadError) {
        return ErrorPlaceHolder(
          state.errorMsg,
          onTap: () {
            _myAcountBloc.add(FetchUserData());
          },
        );
      }

      if (state is NoAcountState) {
        return _buildNoAccountPlaceholder(context);
      }

      if (state is MyAccountLoaded) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              SizedBox(height: 8),
              WalletCardSection(
                amount: state.user.balance,
                creditlineBalance: state.user.creditlineBalance,
                pointsBalance: state.user.pointsBalance,
                history: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return InficashRoute(
                        initIndex: 0,
                      );
                    }),
                  );
                },
                recharge: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return RechargeRoute();
                    }),
                  );
                },
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context).translate("Recent Activity"),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) {
                          return TransactionHistoryRoute();
                        }),
                      );
                    },
                    child: Row(
                      children: [
                        Text(
                          AppLocalizations.of(context).translate("Viewall"),
                          style: TextStyle(color: Color(0xff1463a0)),
                        ),
                        Icon(
                            // Icons.keyboard_arrow_right_outlined,
                            Icons.keyboard_arrow_right,
                            color: Color(0xff1463a0))
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Expanded(
                child: BlocProvider(
                  create: (context) => TransactionHistoryBloc(
                      paymentRepository: PaymentRepository())
                    ..add(
                      FetchTransactionHistory(),
                    ),
                  child: TransactionHistorySection(),
                ),
              ),
            ],
          ),
        );
      }
    }));
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
