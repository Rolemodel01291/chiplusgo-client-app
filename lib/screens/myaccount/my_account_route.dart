// import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:infishare_client/blocs/auth_bloc/auth_event.dart';
import 'package:infishare_client/blocs/blocs.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:infishare_client/models/user.dart';
import 'package:infishare_client/repo/infishare_api.dart';
import 'package:infishare_client/screens/commen_widgets/error_placeholder_page.dart';
import 'package:infishare_client/screens/mywalletscreen/recharge_route.dart';
import 'package:infishare_client/screens/settingPage/refered_code_screen.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../screens.dart';
import 'user_profile_section.dart';
import 'infiCash_card_section.dart';
import 'my_account_cells_section.dart';

class MyAccountRoute extends StatelessWidget {
  // button cells data source
  MyAccountRoute();

  MyAcountBloc _myAcountBloc;
  ProgressDialog _pr;

  @override
  Widget build(BuildContext context) {
    _myAcountBloc = BlocProvider.of<MyAcountBloc>(context);
    _buildLoadingView(context);
    return BlocListener<MyAcountBloc, MyAcountState>(
      listener: (context, state) {
        if (state is MyAccountLoadingPayment) {
          _pr.show();
        } else {
          _pr.hide();
          if (state is MyAccountPaymentError) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(16.0),
                    ),
                  ),
                  title: Text('Oops..'),
                  content: Text(state.errorMsg),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(
                        AppLocalizations.of(context).translate('OK'),
                      ),
                      onPressed: () {
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        }
                      },
                    )
                  ],
                );
              },
            );
          }
        }
      },
      child: BlocBuilder<MyAcountBloc, MyAcountState>(
        builder: (context, state) {
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
            // FirebaseInAppMessaging firebaseInAppMessaging = FirebaseInAppMessaging();
            // firebaseInAppMessaging.triggerEvent('login');
            return ListView(
              shrinkWrap: true,
              children: <Widget>[
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Color(0xff1463a0), Color(0xff002541)])),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      //Appbar Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: Text(
                              AppLocalizations.of(context).translate('Me'),
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  AntDesign.getIconData('setting'),
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  print("press setting button");
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return BlocProvider(
                                          create: (context) => SettingBloc()
                                            ..add(
                                              FetchAppVersion(),
                                            ),
                                          child: SettingRoute(),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                              BlocBuilder<MyAcountBloc, MyAcountState>(
                                builder: (context, state) {
                                  return IconButton(
                                    icon: Icon(
                                      AntDesign.getIconData('customerservice'),
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      print('--------------${context}');
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return BlocProvider(
                                              create: (context) => HelpBloc(
                                                  userRepository:
                                                      BlocProvider.of<AuthBloc>(
                                                              context)
                                                          .userRepository),
                                              child: HelpRoute(
                                                showBusiness: false,
                                                user: state is MyAccountLoaded
                                                    ? state.user
                                                    : null,
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      // Profile Section
                      UserProfileSection(
                        avatarUrl: state.user.avatar,
                        name: state.user.name,
                        emailAddress: state.user.email,
                        navigation: () => null,
                      ),
                    ],
                  ),
                ),
                // infiCash card section
                // Padding(
                //   padding: EdgeInsets.all(16),
                //   child: InfiCashCardSection(
                //     amount: state.user.balance,
                //     history: () {
                //       Navigator.of(context).push(
                //         MaterialPageRoute(builder: (context) {
                //           return InficashRoute(
                //             initIndex: 0,
                //           );
                //         }),
                //       );
                //     },
                //     recharge: () {
                //       Navigator.of(context).push(
                //         MaterialPageRoute(builder: (context) {
                //           return InficashRoute(
                //             initIndex: 1,
                //           );
                //         }),
                //       );
                //     },
                //   ),
                // ),
                // cells section
                _buildSettingList(context, state.user),
              ],
            );
          }
        },
      ),
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

  _buildLoadingView(BuildContext context) {
    _pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: false);
    _pr.style(
      message: 'Loading...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
          Color(0xff242424),
        ),
      ),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progress: 0.0,
      maxProgress: 100.0,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w600),
    );
  }

  Widget _buildSettingList(BuildContext context, User user) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          ButtonCell(
            title: RichText(
              text: TextSpan(
                text: AppLocalizations.of(context).translate('Edit Profile'),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            navigateTo: () {
              Navigator.of(context).pushNamed("/change_profile", arguments: {
                'name': user.name,
                'email': user.email,
                'avatar': user.avatar,
                'phoneNum': user.phone,
                'addressLine1': user.addressLine1,
                'addressLine2': user.addressLine2,
                'city': user.city,
                'signupType': user.signupType
              });
            },
          ),

          Divider(
            height: 1,
            indent: 16,
          ),

          // user.referredCode == ''
          //     ? ButtonCell(
          //         title: RichText(
          //           text: TextSpan(
          //             text: AppLocalizations.of(context)
          //                 .translate('Input Referal Code'),
          //             style: TextStyle(
          //               fontSize: 16,
          //               fontWeight: FontWeight.w600,
          //               color: Color(0xFF81B72F),
          //             ),
          //           ),
          //         ),
          //         navigateTo: () {
          //           Navigator.of(context).push(
          //             MaterialPageRoute(
          //               builder: (context) {
          //                 return BlocProvider<ReferralCodeBloc>(
          //                   create: (context) {
          //                     return ReferralCodeBloc(
          //                       client: BlocProvider.of<AuthBloc>(context)
          //                           .userRepository
          //                           .client,
          //                     );
          //                   },
          //                   child: ReferedCodeScreen(
          //                     selfCode: user.referralCode,
          //                   ),
          //                 );
          //               },
          //             ),
          //           );
          //         },
          //       )
          //     : Container(),
          Divider(
            height: 1,
            indent: 16,
          ),
          // ButtonCell(
          //   title: RichText(
          //     text: TextSpan(
          //       text: AppLocalizations.of(context)
          //           .translate('Invite Friends and Get Reward'),
          //       style: TextStyle(
          //         fontSize: 16,
          //         fontWeight: FontWeight.w600,
          //         color: Color(0xFF1463a0),
          //       ),
          //     ),
          //   ),
          //   navigateTo: () {
          //     Navigator.of(context).push(
          //       MaterialPageRoute(
          //         builder: (context) {
          //           return InviteRoute(
          //             referealCode: user.referralCode,
          //             userName: user.name,
          //           );
          //         },
          //       ),
          //     );
          //   },
          // ),
          // Divider(
          //   height: 1,
          //   indent: 16,
          // ),
          ButtonCell(
            title: RichText(
              text: TextSpan(
                text:
                    AppLocalizations.of(context).translate('Recharge account'),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF242424),
                ),
              ),
            ),
            navigateTo: () {
              // Navigator.of(context).push(
              //   MaterialPageRoute(builder: (context) {
              //     return InficashRoute(
              //       initIndex: 1,
              //     );
              //   }),
              // );
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return RechargeRoute();
                }),
              );
            },
          ),
          Divider(
            height: 1,
            indent: 16,
          ),
          ButtonCell(
            title: RichText(
              text: TextSpan(
                text: AppLocalizations.of(context).translate('Payment method'),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF242424),
                ),
              ),
            ),
            navigateTo: () {
              // _myAcountBloc.add(ShowPayment());
              BlocProvider.of<TabBloc>(context).add(
                UpdateTabEvent(
                  appTab: AppTab.values[1],
                ),
              );
            },
          ),
          Divider(
            height: 1,
            indent: 16,
          ),
          // ButtonCell(
          //   title: RichText(
          //       text: TextSpan(
          //     children: [
          //       TextSpan(
          //         text: AppLocalizations.of(context)
          //             .translate('Become A Merchant'),
          //         style: TextStyle(
          //           fontSize: 16,
          //           fontWeight: FontWeight.w600,
          //           color: Color(0xFF242424),
          //         ),
          //       ),
          //     ],
          //   )),
          //   navigateTo: () {
          //     Navigator.of(context).push(
          //       MaterialPageRoute(
          //         builder: (context) {
          //           return BlocProvider(
          //             create: (context) => HelpBloc(
          //                 userRepository: _myAcountBloc.userRepository),
          //             child: HelpRoute(
          //               showBusiness: true,
          //               user: _myAcountBloc.state is MyAccountLoaded
          //                   ? (_myAcountBloc.state as MyAccountLoaded).user
          //                   : null,
          //             ),
          //           );
          //         },
          //       ),
          //     );
          //   },
          // ),
          ButtonCell(
            title: RichText(
              text: TextSpan(
                text: AppLocalizations.of(context).translate('FAQ'),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF242424),
                ),
              ),
            ),
            navigateTo: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return FAQScreen();
              }));
            },
          ),

          Divider(
            height: 0.5,
            indent: 16,
          ),

          ButtonCell(
            title: RichText(
              text: TextSpan(
                text: AppLocalizations.of(context).translate('Logout'),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ),
            navigateTo: () {
              BlocProvider.of<AuthBloc>(context).add(
                SignOut(),
              );
              // Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }
}
