import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infishare_client/blocs/auth_bloc/bloc.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:infishare_client/screens/auth/auth_verification_code_screen.dart';
import 'package:infishare_client/screens/commen_widgets/custom_button.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../screens.dart';

class AuthPhoneScreen extends StatefulWidget {
  @override
  _AuthPhoneScreenState createState() => _AuthPhoneScreenState();
}

class _AuthPhoneScreenState extends State<AuthPhoneScreen> {
  TextEditingController _controller;
  final _fieldKey = GlobalKey<FormFieldState>();
  AuthBloc _authBloc;
  String _countryCode = '+1';
  bool showAppbar = true;

  @override
  Widget build(BuildContext context) {
    _controller = TextEditingController();
    _authBloc = BlocProvider.of<AuthBloc>(context);
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is PhoneVerified) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return BlocProvider.value(
                  value: _authBloc,
                  child: AuthVerificationCodeScreen(
                    phoneNumber: _countryCode + _controller.text,
                  ),
                );
              },
            ),
          );
        }

        if (state is SmsCodeVerified) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return BlocProvider.value(
                  value: _authBloc,
                  child: AuthEmailScreen(
                      phoneNum: _countryCode + _controller.text),
                );
              },
            ),
          );
        }

        if (state is AuthLoading) {}

        if (state is Autheticated) {
          var future = new Future.delayed(const Duration(milliseconds: 1000));
          var subscription = future.asStream().listen(doStuffCallback());
          subscription.cancel();

          //* close whole auth process

          // _pr.hide();
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
                  Icons.close,
                  color: Colors.black,
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
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        AppLocalizations.of(context).translate('AuthTitle'),
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        AppLocalizations.of(context)
                            .translate('Enter your phone number'),
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CountryCodePicker(
                            textStyle: TextStyle(fontSize: 18),
                            onChanged: (countrycode) {
                              _countryCode = countrycode.dialCode;
                            },
                            // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                            initialSelection: 'US',
                            favorite: ['+1'],
                            // optional. Shows only country name and flag
                            showCountryOnly: false,
                            // optional. aligns the flag and the Text left
                            alignLeft: false,
                          ),
                          BlocBuilder<AuthBloc, AuthState>(
                            builder: (BuildContext context, AuthState state) {
                              return Expanded(
                                child: TextFormField(
                                  autovalidateMode: AutovalidateMode.always,
                                  autofocus: true,
                                  key: _fieldKey,
                                  validator: _validatePhone,
                                  controller: _controller,
                                  onFieldSubmitted: (val) {
                                    _onSendButtonTapped();
                                  },
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                  keyboardType: TextInputType.number,
                                  keyboardAppearance: Brightness.light,
                                  decoration: InputDecoration(
                                    errorText: state is AuthError
                                        ? state.errorMsg
                                        : null,
                                    errorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 3.0),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xff242424), width: 3.0),
                                    ),
                                    border: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xff242424), width: 3.0),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return CustomButton(
                    text: AppLocalizations.of(context).translate("Next"),
                    inactive: false,
                    onPressed:
                        (state is AuthLoading) ? null : _onSendButtonTapped,
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

  doStuffCallback() {
    Navigator.of(context).popUntil((route) {
      print('=======================================$route');
      if (route.settings.name == '/home' ||
          route.settings.name == '/coupon_detail' ||
          route.settings.name == '/single_coupon' ||
          route.settings.name == '/onboarding') {
        return true;
      }
      return false;
    });
  }

  void _onSendButtonTapped() {
    print(_countryCode + _controller.text);
    final phoneNum = _countryCode + _controller.text;
    if (_fieldKey.currentState.validate()) {
      _authBloc.add(SendCodeEvent(phoneNum: phoneNum));
    }
  }

  String _validatePhone(String phone) {
    print('-----------$phone');
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(pattern);

    if (phone.length == 0) {
      return 'Please enter phone number';
    }

    if (regExp.hasMatch(phone)) {
      return null;
    } else {
      return 'Invalid phone number';
    }
  }
}
