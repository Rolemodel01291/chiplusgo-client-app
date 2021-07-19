import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infishare_client/blocs/blocs.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ReferedCodeScreen extends StatefulWidget {
  final String selfCode;

  ReferedCodeScreen({
    Key key,
    this.selfCode,
  }) : super(key: key);

  @override
  _ReferedCodeScreenState createState() => _ReferedCodeScreenState();
}

class _ReferedCodeScreenState extends State<ReferedCodeScreen> {
  TextEditingController _editingController;
  final _key = GlobalKey<FormFieldState>();

  ProgressDialog _pr;

  @override
  void initState() {
    super.initState();
    _buildLoadingView();
    _editingController = TextEditingController();
  }

  _buildLoadingView() {
    _pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: false);
    _pr.style(
      message: 'Loading...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReferralCodeBloc, ReferralCodeState>(
      listener: (context, state) {
        if (state is CodeChecked) {
          _showSuccessDialog(context);
        }

        if (state is CodeCheckError) {
          _pr.hide();
        }

        if (state is CodeChecking) {
          _pr.show();
        }
      },
      child: BlocBuilder<ReferralCodeBloc, ReferralCodeState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Colors.white,
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.check,
                    color: Colors.black,
                    size: 30,
                  ),
                  onPressed: () {
                    if (_key.currentState.validate()) {
                      BlocProvider.of<ReferralCodeBloc>(context).add(
                        CheckReferralCode(
                          referralCode: _editingController.text,
                        ),
                      );
                    }
                  },
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SvgPicture.asset(
                    'assets/svg/gift.svg',
                    width: 120.0,
                    height: 120.0,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: TextFormField(
                      key: _key,
                      controller: _editingController,
                      validator: checkCode,
                      decoration: InputDecoration(
                        errorText:
                            (state is CodeCheckError) ? state.errorMsg : null,
                        hintText: AppLocalizations.of(context)
                            .translate('Input Referal Code'),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 3.0),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xff242424), width: 3.0),
                        ),
                        border: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xff242424), width: 3.0),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String checkCode(String code) {
    if (widget.selfCode == code) {
      return 'You can not enter your code.';
    } else if (_editingController.text.isEmpty) {
      return 'Referral code can not be empty';
    } else {
      return null;
    }
  }

  void _showSuccessDialog(BuildContext context) {
    _pr.hide();
    final successdialog = YYDialog().build(context)
      ..barrierDismissible = false
      ..width = 200
      ..height = 200
      ..backgroundColor = Colors.black.withOpacity(0.8)
      ..borderRadius = 10.0
      ..widget(Container(
        width: 150,
        height: 150,
        child: FlareActor(
          'assets/flare/successcheck.flr',
          alignment: Alignment.center,
          fit: BoxFit.cover,
          animation: 'Untitled',
        ),
      ))
      ..widget(Padding(
        padding: EdgeInsets.only(top: 10),
        child: Text(
          AppLocalizations.of(context).translate('Success'),
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ))
      ..animatedFunc = (child, animation) {
        return FadeTransition(
          child: child,
          opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
        );
      }
      ..show();
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (successdialog.isShowing) {
        successdialog.dismiss();
        Navigator.of(context).pop();
      }
    });
  }
}
