import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infishare_client/blocs/auth_bloc/bloc.dart';
import 'package:infishare_client/blocs/blocs.dart';
import 'package:infishare_client/blocs/tab_bloc/bloc.dart';
import 'package:infishare_client/blocs/tab_bloc/tab_bloc.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:infishare_client/repo/infishare_api.dart';
import 'package:infishare_client/screens/mywalletscreen/qrScan.dart';
import 'package:infishare_client/screens/screens.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'commen_widgets/decimal_text_input_formatter.dart';
import 'mywalletscreen/confirm_payment_screen.dart';

class TabScreen extends StatelessWidget {
  FirebaseMessaging _firebaseMessaging;
  TabScreen({Key key}) : super(key: key);

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  CheckOutBloc _checkOutBloc;
  InfiShareApiClient _infiShareApiClient =
      InfiShareApiClient(httpClient: http.Client());

  @override
  Widget build(BuildContext context) {
    _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {},
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        var data = message['data'] ?? message;
        if (data['link'] != null) {
          _launchURL(data['link'] as String);
        } else if (data['businessId'] != null && data["couponId"] != null) {
          Navigator.of(context).pushNamed(
            '/single_coupon',
            arguments: message,
          );
        } else if (data['businessId'] != null) {
          Navigator.of(context).pushNamed('/business/id', arguments: message);
        }
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        var data = message['data'] ?? message;
        if (data['link'] != null) {
          _launchURL(data['link'] as String);
        } else if (data['businessId'] != null && data["couponId"] != null) {
          Navigator.of(context).pushNamed(
            '/single_coupon',
            arguments: message,
          );
        } else if (data['businessId'] != null) {
          Navigator.of(context).pushNamed('/business/id', arguments: {
            "businessId": data['businessId'],
          });
        }
      },
    );
    return BlocBuilder<TabBloc, TabState>(
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            appBar: _buildAppBar(state, context),
            body: _buildBody(state, context),
            bottomNavigationBar: BottomNavigationBar(
              selectedLabelStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xff242424),
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
              selectedItemColor: Color(0xff242424),
              unselectedItemColor: Colors.grey,
              currentIndex: _currentIndex(state),
              onTap: (index) {
                BlocProvider.of<TabBloc>(context).add(
                  UpdateTabEvent(
                    appTab: AppTab.values[index],
                  ),
                );
              },
              items: [
                BottomNavigationBarItem(
                  title: Text(
                    AppLocalizations.of(context).translate('Home'),
                  ),
                  icon: Icon(
                    Feather.getIconData('home'),
                  ),
                ),
                BottomNavigationBarItem(
                    title: Text(
                      AppLocalizations.of(context).translate("Wallet"),
                    ),
                    icon: Icon(
                      AntDesign.getIconData('wallet'),
                    )),
                BottomNavigationBarItem(
                    title: Text(
                      AppLocalizations.of(context).translate('Orders'),
                    ),
                    icon: Icon(
                      AntDesign.getIconData('shoppingcart'),
                    )),
                BottomNavigationBarItem(
                    title: Text(
                      AppLocalizations.of(context).translate('Me'),
                    ),
                    icon: Icon(
                      Feather.getIconData('user'),
                    )),
              ],
            ),
          ),
        );
      },
    );
  }

  int _currentIndex(TabState state) {
    if (state is HomeTab) {
      return 0;
    } else if (state is WalletTab) {
      return 1;
    } else if (state is OrderTab) {
      return 2;
    } else {
      return 3;
    }
  }

  PreferredSizeWidget _buildAppBar(TabState tabstate, BuildContext context) {
    if (tabstate is HomeTab) {
      return null;
    } else if (tabstate is WalletTab) {
      return AppBar(
          automaticallyImplyLeading: false,
          elevation: 1.0,
          title: Text(
            AppLocalizations.of(context).translate("Wallet"),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF242424),
            ),
          ),
          backgroundColor: Colors.white,
          actions: [
            BlocBuilder<MyAcountBloc, MyAcountState>(builder: (context, state) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => QrScanPage()),
                  ).then((value) async {
                    if (value != null) {
                      if (value.contains('Gift/')) {
                        final result = await _infiShareApiClient
                            .checkGiftUsed(value.replaceAll('Gift/', ''));
                        if (result) {
                          _showConfirmDialog(context, value).then((val) => {});
                        } else {
                          _showUsedDialog(context);
                        }
                      } else if (value.contains('/')) {
                        if (value.split('/')[0].length == 28 &&
                            value.split('/')[1].length == 20) {
                          _showCouponDialog(context);
                        }
                      } else if (!value.contains('//')) {
                        final result =
                            await _infiShareApiClient.findBusinessById(value);
                        final findBusiness = result[0];
                        final subAccountId = result[1];
                        if (findBusiness != null) {
                          if (state is MyAccountLoaded) {
                            _showOtherDialog(
                                    context,
                                    state.user.balance +
                                        state.user.creditlineBalance +
                                        state.user.pointsBalance / 10)
                                .then((value) {
                              if (value != null && value != 0) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ConfirmPaymentScreen(
                                      amount: value,
                                      client: state.user,
                                      business: findBusiness,
                                      subAccountId: subAccountId,
                                    ),
                                  ),
                                );
                              }
                            });
                          } else {}
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                contentPadding: EdgeInsets.all(16),
                                content: Text(
                                  "It is a wrong QR code",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                actions: [
                                  FlatButton(
                                    child: Text("OK"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }
                    }
                  });
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        "assets/svg/qrscan.svg",
                        width: 20,
                        height: 20,
                      ),
                      Text(
                        " ${AppLocalizations.of(context).translate('Scan')}",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ]);
    } else if (tabstate is OrderTab) {
      return AppBar(
        automaticallyImplyLeading: false,
        elevation: 1.0,
        title: Text(
          AppLocalizations.of(context).translate('Orders'),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF242424),
          ),
        ),
        backgroundColor: Colors.white,
      );
    } else {
      // return null;
      return AppBar(
        automaticallyImplyLeading: false,
        title: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return Text(
              AppLocalizations.of(context).translate('Me'),
              style: TextStyle(
                  color: (state is Autheticated) ? Colors.white : Colors.black),
            );
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        // actions: <Widget>[
        //   BlocBuilder<MyAcountBloc, MyAcountState>(
        //     builder: (context, state) {
        //       return IconButton(
        //         icon: Icon(
        //           AntDesign.getIconData('customerservice'),
        //           color: Colors.black,
        //         ),
        //         onPressed: () {
        //           Navigator.of(context).push(
        //             MaterialPageRoute(
        //               builder: (context) {
        //                 return BlocProvider(
        //                   create: (context) => HelpBloc(
        //                       userRepository: BlocProvider.of<AuthBloc>(context)
        //                           .userRepository),
        //                   child: HelpRoute(
        //                     showBusiness: false,
        //                     user: state is MyAccountLoaded ? state.user : null,
        //                   ),
        //                 );
        //               },
        //             ),
        //           );
        //         },
        //       );
        //     },
        //   ),
        //   IconButton(
        //     icon: Icon(
        //       AntDesign.getIconData('setting'),
        //       color: Colors.black,
        //     ),
        //     onPressed: () {
        //       print("press setting button");
        //       Navigator.of(context).push(
        //         MaterialPageRoute(
        //           builder: (context) {
        //             return BlocProvider(
        //               create: (context) => SettingBloc()
        //                 ..add(
        //                   FetchAppVersion(),
        //                 ),
        //               child: SettingRoute(),
        //             );
        //           },
        //         ),
        //       );
        //     },
        //   )
        // ],
      );
    }
  }

  Widget _buildBody(TabState state, BuildContext context) {
    if (state is HomeTab) {
      return HomeRoute();
    } else if (state is WalletTab) {
      return WalletRoute();
    } else if (state is OrderTab) {
      return OrderRoute();
    } else {
      return MyAccountRoute();
    }
  }

  Future<double> _showOtherDialog(BuildContext context, totalBalance) {
    bool _isButtonDisabled = false;
    TextEditingController textCon = TextEditingController();
    double amount = 0.0;
    GlobalKey<FormFieldState> _key = GlobalKey();

    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(16),
          content: Container(
            width: MediaQuery.of(context).size.width - 112 - 32,
            height: 200,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context).translate('EnterAmount'),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF242424),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  key: _key,
                  validator: (value) {
                    return customAmountValidate(value, totalBalance);
                  },
                  controller: textCon,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: _isButtonDisabled
                          ? Color(0xFFACACAC)
                          : Color(0xFF1463a0)),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  enableInteractiveSelection: false,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(6),
                    DecimalTextInputFormatter(decimalRange: 2),
                  ],
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff1463a0),
                        width: 2.0,
                      ),
                    ),
                    hintStyle: TextStyle(
                      fontSize: 32,
                      color: Color(0xFFACACAC),
                    ),
                    errorStyle: TextStyle(fontSize: 13, color: Colors.red),
                  ),
                  onChanged: (value) {
                    if (value != '') {
                      amount = double.parse(value);
                    } else {
                      amount = 0.0;
                    }
                  },
                ),
                SizedBox(
                  height: 14,
                ),
                Spacer(),
                Container(
                  height: 44,
                  child: MaterialButton(
                    textColor: Color(0xFF242424),
                    disabledTextColor: Colors.white,
                    color: Color(0xff1463a0),
                    disabledColor: Color(0xFFACACAC),
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context).translate('Submit'),
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    onPressed: () {
                      if (_key.currentState.validate()) {
                        print('-----------------------------$context');
                        Navigator.of(context).pop(amount);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<double> _showUsedDialog(BuildContext context) {
    bool _isButtonDisabled = false;
    TextEditingController textCon = TextEditingController();
    double amount = 0.0;
    GlobalKey<FormFieldState> _key = GlobalKey();

    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(16),
          content: Container(
            width: MediaQuery.of(context).size.width - 112 - 32,
            height: 100,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 40,
                ),
                Text(
                  AppLocalizations.of(context).translate('Gift card used'),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF242424),
                  ),
                ),
                SizedBox(
                  height: 14,
                ),
                Spacer(),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<double> _showCouponDialog(BuildContext context) {
    bool _isButtonDisabled = false;
    TextEditingController textCon = TextEditingController();
    double amount = 0.0;
    GlobalKey<FormFieldState> _key = GlobalKey();

    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(16),
          content: Container(
            width: MediaQuery.of(context).size.width - 112 - 32,
            height: 120,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 40,
                ),
                Text(
                  AppLocalizations.of(context)
                      .translate('This coupon QR code is only for business'),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF242424),
                  ),
                ),
                SizedBox(
                  height: 14,
                ),
                Spacer(),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<double> _showConfirmDialog(BuildContext context, String value) {
    bool _isButtonDisabled = false;
    TextEditingController textCon = TextEditingController();
    GlobalKey<FormFieldState> _key = GlobalKey();

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(16),
          content: Container(
            width: MediaQuery.of(context).size.width - 112 - 32,
            height: 150,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Text(
                  AppLocalizations.of(context)
                      .translate('Do you want redeem gift card'),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF242424),
                  ),
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: 44,
                      child: MaterialButton(
                        textColor: Color(0xFF242424),
                        disabledTextColor: Colors.white,
                        color: Colors.red[700],
                        disabledColor: Color(0xFFACACAC),
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context).translate('Cancel'),
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        onPressed: () async {
                          await _infiShareApiClient
                              .cancelGiftCard(value.replaceAll('Gift/', ''));
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    Container(
                      height: 44,
                      child: MaterialButton(
                        textColor: Color(0xFF242424),
                        disabledTextColor: Colors.white,
                        color: Color(0xff1463a0),
                        disabledColor: Color(0xFFACACAC),
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context).translate('OK'),
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        onPressed: () async {
                          // Navigator.of(context).pop();

                          final result = await _infiShareApiClient
                              .findGiftById(value.replaceAll('Gift/', ''));

                          if (result != '') {
                            Navigator.of(context).pushReplacementNamed(
                              '/gift_success',
                              // arguments: state.ticket.ticketNum,
                              arguments: result,
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("This gift is used already!"),
                            ));
                          }
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  String customAmountValidate(String value, double totalBalance) {
    var amount = double.tryParse(value);
    if (amount == null) {
      return 'Please enter valid amount';
    }
    if (amount > totalBalance) {
      return 'Amount should be less than $totalBalance';
    } else {
      return null;
    }
  }
}
