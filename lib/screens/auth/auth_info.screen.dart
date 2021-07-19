import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infishare_client/blocs/auth_bloc/bloc.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:infishare_client/screens/commen_widgets/custom_button.dart';
import 'package:progress_dialog/progress_dialog.dart';

class AuthInfoScreen extends StatefulWidget {
  final String email;
  AuthInfoScreen({this.email});
  @override
  _AuthInfoScreenState createState() => _AuthInfoScreenState();
}

class _AuthInfoScreenState extends State<AuthInfoScreen> {
  // final GlobalKey<FormFieldState> _key = GlobalKey();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  AuthBloc _authBloc;

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  bool acceptTerm = false;
  bool understand = false;

  @override
  Widget build(BuildContext context) {
    _authBloc = BlocProvider.of<AuthBloc>(context);
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.0,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _key,
                      child: Column(
                        children: [
                          Text(
                            AppLocalizations.of(context)
                                .translate('AuthLastStep'),
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            "New user?",
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            "Create an account in seconds!",
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          TextFormField(
                            validator: _validFirstName,
                            controller: _firstNameController,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                labelText: "First Name",
                                labelStyle: TextStyle(color: Colors.grey)),
                          ),
                          TextFormField(
                            validator: _validLastName,
                            controller: _lastNameController,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                labelText: "Last Name",
                                labelStyle: TextStyle(color: Colors.grey)),
                          ),
                          TextFormField(
                            controller: _phoneController,
                            validator: _validPhone,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                            keyboardType: TextInputType.emailAddress,
                            keyboardAppearance: Brightness.light,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)
                                  .translate("Phone number"),
                              labelStyle: TextStyle(color: Colors.grey),
                              errorText:
                                  (state is AuthError) ? state.errorMsg : null,
                              errorBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.red, width: 3.0),
                              ),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xff242424), width: 3.0),
                              ),
                            ),
                          ),
                          TextFormField(
                            initialValue: widget.email,
                            // controller: _emailController,
                            readOnly: true,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey),
                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.lock_outline),
                              labelText: AppLocalizations.of(context)
                                  .translate("Email address"),
                              labelStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          Row(children: [
                            Checkbox(
                              checkColor: Colors.white,
                              value: acceptTerm,
                              onChanged: (value) {
                                setState(() {
                                  print(!value);
                                  acceptTerm = value;
                                });
                              },
                            ),
                            Text(
                              AppLocalizations.of(context)
                                  .translate('I accept to'),
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w300),
                            ),
                            RichText(
                              text: TextSpan(
                                  text: AppLocalizations.of(context)
                                      .translate('Terms Condition'),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      Navigator.of(context).pushNamed(
                                        '/terms',
                                      );
                                    }),
                            )
                          ]),
                          Row(children: [
                            Checkbox(
                              checkColor: Colors.white,
                              value: understand,
                              onChanged: (value) {
                                setState(() {
                                  understand = value;
                                });
                              },
                            ),
                            Expanded(
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate('I understand'),
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                    height: 1.5),
                              ),
                            )
                          ])
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                CustomButton(
                  text: AppLocalizations.of(context).translate("Sign Up"),
                  inactive: _key.currentState == null
                      ? true
                      : (!_key.currentState.validate() &&
                          !understand &&
                          !acceptTerm),
                  onPressed: (state is AuthLoading) ? null :_onUpdatePhone,
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  _onUpdatePhone() {
    if (_key.currentState.validate()) {
      if (understand) {
        if (acceptTerm) {
          _authBloc.add(
            SignUpNewUserFromGoogle(
                name:
                    _firstNameController.text + " " + _lastNameController.text,
                phone: _phoneController.text, email: widget.email),
                
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Please accept terms"),
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Please accept terms"),
        ));
      }
    }
  }

  String _validFirstName(String val) {
    if (val == "") {
      return "Enter First Name";
    } else {
      return null;
    }
  }

  String _validLastName(String val) {
    if (val == "" || val == null) {
      return "Enter Last Name";
    } else {
      return null;
    }
  }

  String _validPhone(String val) {
    if (val == "" || val == null) {
      return "Enter Phone number";
    } else {
      return null;
    }
  }
}
