import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:infishare_client/blocs/auth_bloc/auth_bloc.dart';
import 'package:infishare_client/blocs/auth_bloc/bloc.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:http/http.dart' as http;
import 'package:infishare_client/screens/auth/auth_info.screen.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  GoogleSignInAccount googleSignInAccount;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  AuthBloc _authBloc;

  @override
  Widget build(BuildContext context) {
    _authBloc = BlocProvider.of<AuthBloc>(context);
    return BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Autheticated) {
            //* close whole auth process
            Navigator.of(context).popUntil((route) {
              if (route.settings.name == '/home' ||
                  route.settings.name == '/coupon_detail' ||
                  route.settings.name == '/single_coupon' ||
                  route.settings.name == '/onboarding') {
                return true;
              }
              return false;
            });
          }

          if (state is GmailVerified) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return BlocProvider.value(
                    value: _authBloc,
                    child: AuthInfoScreen(email: state.email),
                  );
                },
              ),
            );
          }

          if (state is FacebookVerified) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return BlocProvider.value(
                    value: _authBloc,
                    child: AuthInfoScreen(email: state.email),
                  );
                },
              ),
            );
          }
        },
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.0,
              leading: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            body: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: [
                        Image.asset(
                          "assets/images/logo.png",
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          AppLocalizations.of(context).locale.languageCode ==
                                  'en'
                              ? "Sign in/sign up through SMS verification or sign in using Google or Facebook."
                              : "通过短信验证登录/注册或使用 Google 或 Facebook 登录",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                          return SocialButton(
                            title: AppLocalizations.of(context)
                                .translate('Sign In/Sign Up'),
                            color: Color(0xff1463a0),
                            onPressed: () {
                              (state is AuthLoading)
                                  ? null
                                  : Navigator.of(context)
                                      .pushNamed('/phoneauth');
                            },
                          );
                        }),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Color(0xffacacac),
                                thickness: 1,
                              ),
                            ),
                            Text(
                              "  Or  ",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xffacacac),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Color(0xffacacac),
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                          return SocialButton(
                            icon: "assets/svg/google.svg",
                            title: "Continue with Google",
                            color: Color(0xff3e82f1),
                            onPressed: () {
                              (state is AuthLoading)
                                  ? null
                                  : signInWithGoogle();
                            },
                          );
                        }),
                        SizedBox(height: 8),
                        BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                          return SocialButton(
                            icon: "assets/svg/facebook.svg",
                            title: "Continue with Facebook",
                            color: Color(0xff4d68a5),
                            onPressed: () {
                              (state is AuthLoading)
                                  ? null
                                  : signInWithFacebook();
                            },
                          );
                        }),
                        SizedBox(height: 8),
                        // SocialButton(
                        //   icon: "assets/svg/apple.svg",
                        //   title: "Continue with Apple",
                        //   color: Color(0xff242424),
                        // ),
                        Padding(
                            padding: EdgeInsets.only(top: 16, bottom: 32),
                            child: RichText(
                                text: TextSpan(
                                    text: "CHI +GO User Terms & Conditions",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff1463a0),
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                        Navigator.of(context).pushNamed(
                                          '/terms',
                                        );
                                      }))),
                      ],
                    ),
                  ],
                ),
              );
            })));
  }

  Future<void> signInWithGoogle() async {
    try {
      _authBloc.add(AuthGoogleEvent());
    } catch (e) {
      print(e.message);
    }
  }

  Future<void> signInWithFacebook() async {
    try {
      print("Sing in with facebook");
      _authBloc.add(AuthFacebookEvent());
    } catch (e) {
      print(e.message);
    }
  }
}

class SocialButton extends StatelessWidget {
  final String icon;
  final String title;
  final Color color;
  final Function onPressed;
  const SocialButton(
      {Key key, this.icon, this.title, this.color, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () => onPressed(),
      height: 50,
      color: color,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon != null
              ? SvgPicture.asset(
                  icon,
                )
              : Container(),
          SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 16),
          )
        ],
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
