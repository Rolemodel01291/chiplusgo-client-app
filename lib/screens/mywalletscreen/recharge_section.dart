import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:infishare_client/blocs/blocs.dart';
import 'package:infishare_client/blocs/recharge_bloc/recharge_inficash_bloc.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:infishare_client/models/models.dart';
import 'package:infishare_client/screens/commen_widgets/decimal_text_input_formatter.dart';
import 'package:infishare_client/screens/commen_widgets/error_placeholder_page.dart';
import 'package:infishare_client/screens/inficashPage/paymentMethod_section.dart';
import 'package:infishare_client/screens/inficashPage/payment_section.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import "package:infishare_client/screens/inficashPage/recharge_bottom_bar_widget.dart"
    as bbWidget;
import 'package:flare_flutter/flare_actor.dart';

class RechargeSection extends StatefulWidget {
  const RechargeSection();
  @override
  RechargeSectionState createState() => RechargeSectionState();
}

class RechargeSectionState extends State<RechargeSection> {
  ProgressDialog _pr;

  @override
  void initState() {
    super.initState();
    _buildLoadingView();
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

  @override
  Widget build(BuildContext context) {
    var f = NumberFormat("#,###,##0.00", "en_US");
    ;
    return BlocListener<RechargeInficashBloc, RechargeInficashState>(
      listener: (context, state) async {
        if (state is ShowCustomInficash) {
          final amount = await _showOtherDialog();
          if (amount != null && amount != 0.0) {
            BlocProvider.of<RechargeInficashBloc>(context).add(
              CustomizeInficash(usage: amount),
            );
          }
        }

        if (state is PaymentProcessing) {
          _pr.show();
        }

        if (state is PaymentSuccess) {
          _showSuccessDialog(context);
        }

        if (state is RechargeOptionLoading) {
          _pr.hide();
        }

        if (state is PaymentError) {
          _pr.hide().then(
            (hide) {
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
            },
          );
        }
      },
      child: BlocBuilder<RechargeInficashBloc, RechargeInficashState>(
        builder: (context, state) {
          if (state is RechargeOptionLoading) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color(0xff242424),
                  ),
                ),
              ),
            );
          }

          if (state is RechargeOptionLoadError) {
            return Scaffold(
              body: ErrorPlaceHolder(state.errorMsg),
            );
          }

          if (state is RechargeOptionLoaded) {
            return Scaffold(
              body: Container(
                color: Color(0xFFF1F2F4),
                child: Column(
                  children: [
                    Expanded(child: _buildBodyView(state)),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: MaterialButton(
                        height: 40,
                        disabledColor: Colors.grey,
                        color: Color(0xff1463a0),
                        minWidth: MediaQuery.of(context).size.width,
                        onPressed: state.paymentInfo.isEmpty
                            ? null
                            : () {
                                BlocProvider.of<RechargeInficashBloc>(context)
                                    .add(
                                  ConfirmChargeInficash(),
                                );
                              },
                        child: Text(
                          AppLocalizations.of(context).translate("Add") +
                              "\$" +
                              (state.selectedIndex == 5
                                  ? f.format(state.customAmount)
                                  : f.format(state
                                      .chargeOptions
                                      .options[state.selectedIndex]
                                      .baseAmount)),
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
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
    Future.delayed(const Duration(seconds: 3), () {
      successdialog.dismiss();
      BlocProvider.of<RechargeInficashBloc>(context).add(
        FetchRechargeOptions(),
      );
      Navigator.of(context).pushReplacementNamed('/home');
    });
  }

  Widget _buildBodyView(RechargeOptionLoaded state) {
    List<Widget> widgets = [];

    widgets.addAll([
      // charge option selection
      // pass "this" to child so that child can modify amount in RechargeSectionState
      InficashPaymentSection(
        chargeOption: state.chargeOptions,
        selectIndex: state.selectedIndex,
        customizeNum: state.customAmount,
      ),
      SizedBox(
        height: 16,
      ),
      // payment methods
      PaymentMethodSection(
        paymentMethod: state.paymentInfo,
      ),
    ]);

    return ListView(
      children: widgets,
    );
  }

  String _getMaxDiscount(ChargeOption chargeOption) {
    double discount = 0.0;
    chargeOption.options.forEach((option) {
      if (option.bouns != 0) {
        discount = max(
            discount, (option.baseAmount) / (option.baseAmount + option.bouns));
      }
    });

    return discount == 0.0
        ? ''
        : ((1 - discount) * 100).toStringAsFixed(0) + '%';
  }

  Future<double> _showOtherDialog() {
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
            height: 180,
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
                  controller: textCon,
                  autovalidateMode: AutovalidateMode.always,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: _isButtonDisabled
                          ? Color(0xFFACACAC)
                          : Color(0xFF1463a0)),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  enableInteractiveSelection: false,
                  validator: _validatePhone,
                  inputFormatters: [
                    // LengthLimitingTextInputFormatter(5),
                    DecimalTextInputFormatter(decimalRange: 2),

                    // LengthLimitingTextInputFormatter(5),
                  ],
                  // validator: (String value) {
                  //   return (validateMyInput(value)) != null
                  //       ? 'Do not use the @ char.'
                  //       : null;
                  // },
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

  String _validatePhone(String phone) {
    if (phone != "") if (double.parse(phone) > 10000) {
      return 'Enter an amount smaller than 10000.';
    }
  }
}
