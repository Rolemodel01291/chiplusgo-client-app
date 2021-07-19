import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infishare_client/blocs/auth_bloc/auth_bloc.dart';
import 'package:infishare_client/blocs/auth_bloc/auth_state.dart';
import 'package:infishare_client/blocs/auth_bloc/bloc.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:infishare_client/screens/auth/auth_email_screen.dart';
import 'package:infishare_client/screens/commen_widgets/custom_button.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:quiver/async.dart';

class AuthVerificationCodeScreen extends StatefulWidget {
  final String phoneNumber;

  AuthVerificationCodeScreen({this.phoneNumber});

  @override
  _AuthVerificationCodeScreenState createState() =>
      _AuthVerificationCodeScreenState();
}

class _AuthVerificationCodeScreenState
    extends State<AuthVerificationCodeScreen> {
  AuthBloc _authBloc;
  String _otpCode = '';
  int _start = 59;
  int _current = 59;
  StreamSubscription<CountdownTimer> _subscription;
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _authBloc = BlocProvider.of<AuthBloc>(context);
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is SmsCodeVerified) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return BlocProvider.value(
                  value: _authBloc,
                  child: AuthEmailScreen(phoneNum: widget.phoneNumber),
                );
              },
            ),
          );
        }

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
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.0,
            leading:
                BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
              return IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Color(0xff242424),
                ),
                onPressed: () {
                  (state is AuthLoading) ? null : Navigator.of(context).pop();
                },
              );
            })),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context).locale.languageCode == 'en'
                          ? 'Please enter the 6-digit code sent to you at ${widget.phoneNumber}'
                          : '请输入手机号${widget.phoneNumber}收到的验证码',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      height: 70,
                      child: PinCodeTextField(
                        pinBoxWidth: 30,
                        pinBoxHeight: 30,
                        autofocus: true,
                        controller: _controller,
                        defaultBorderColor: Colors.grey,
                        hasTextBorderColor: Colors.black,
                        maxLength: 6,
                        wrapAlignment: WrapAlignment.spaceAround,
                        pinBoxDecoration:
                            ProvidedPinBoxDecoration.underlinedPinBoxDecoration,
                        pinTextStyle: TextStyle(fontSize: 25.0),
                        pinTextAnimatedSwitcherTransition:
                            ProvidedPinBoxTextAnimation.scalingTransition,
                        pinTextAnimatedSwitcherDuration:
                            Duration(milliseconds: 300),
                      ),
                    ),
                    // _buildVerificationCodeInput(context),
                    SizedBox(
                      height: 8.0,
                    ),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return Text(
                          state is AuthError ? state.errorMsg : '',
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        );
                      },
                    ),
                    SizedBox(
                      height: 16.0,
                    ),

                    _current == 0
                        ? GestureDetector(
                            onTap: _current == 0 ? _onResendTap : null,
                            child: Text(
                              AppLocalizations.of(context).translate('Resend'),
                              style: TextStyle(
                                  color: Color(0xff1463a0),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                AppLocalizations.of(context)
                                    .translate("AuthNoVcode"),
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                AppLocalizations.of(context)
                                            .locale
                                            .languageCode ==
                                        "en"
                                    ? "Resend code in $_current seconds"
                                    : "重新发送",
                                style: TextStyle(color: Colors.grey),
                              )
                            ],
                          ),
                  ],
                ),
              ),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return CustomButton(
                    text: AppLocalizations.of(context).translate("Next"),
                    inactive: (state is AuthLoading) ? true : false,
                    onPressed: _onNextTapped,
                  );
                },
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void startTimer() {
    _subscription?.cancel();
    CountdownTimer countDownTimer = new CountdownTimer(
      new Duration(seconds: _start),
      new Duration(seconds: 1),
    );

    _subscription = countDownTimer.listen(null);
    _subscription.onData((duration) {
      setState(() {
        _current = _start - duration.elapsed.inSeconds;
      });
    });

    _subscription.onDone(() {
      print("Done");
      _subscription.cancel();
    });
  }

  _onResendTap() {
    startTimer();
    _authBloc.add(SendCodeEvent(phoneNum: widget.phoneNumber));
  }

  _onNextTapped() {
    if (_controller.text.length == 6) {
      _authBloc.add(
        VerifySmscode(smsCode: _controller.text),
      );
    }
  }
}
