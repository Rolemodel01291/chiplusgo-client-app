import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infishare_client/blocs/auth_bloc/bloc.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:infishare_client/screens/commen_widgets/custom_button.dart';
import 'package:progress_dialog/progress_dialog.dart';

class AuthEmailScreen extends StatefulWidget {
  final String phoneNum;
  AuthEmailScreen({this.phoneNum});
  @override
  _AuthEmailScreenState createState() => _AuthEmailScreenState();
}

class _AuthEmailScreenState extends State<AuthEmailScreen> {
  // final GlobalKey<FormFieldState> _key = GlobalKey();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  AuthBloc _authBloc;

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  bool acceptTerm = false;
  bool understand = false;
  ProgressDialog _pr;

  @override
  void initState() {
    super.initState();
    _buildLoadingView();
  }

  @override
  Widget build(BuildContext context) {
    _authBloc = BlocProvider.of<AuthBloc>(context);

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Autheticated) {
          // _pr.hide();
        }
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
                            validator: _validEmail,
                            controller: _emailController,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                            keyboardType: TextInputType.emailAddress,
                            keyboardAppearance: Brightness.light,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)
                                  .translate("Email address"),
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
                            initialValue: widget.phoneNum,
                            readOnly: true,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey),
                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.lock_outline),
                              labelText: AppLocalizations.of(context)
                                  .translate("Phone number"),
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
                  onPressed: (state is AuthLoading) ? null : _onUpdateEmail,
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  _buildLoadingView() {
    _pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: false);
    _pr.style(
      message: 'Loading...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: Image.asset(
        'assets/images/shoploading.gif',
        width: 50,
        height: 50,
        fit: BoxFit.contain,
      ),
      elevation: 5.0,
      insetAnimCurve: Curves.easeInOut,
      progress: 0.0,
      maxProgress: 100.0,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w600),
    );
  }

  _onUpdateEmail() {
    if (_key.currentState.validate()) {
      if (understand) {
        if (acceptTerm) {
          _authBloc.add(
            SignUpNewUser(
                name:
                    _firstNameController.text + " " + _lastNameController.text,
                email: _emailController.text),
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

  String _validEmail(String val) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(val))
      return 'Enter Valid Email';
    else
      return null;
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
}
