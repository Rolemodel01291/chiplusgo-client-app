import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infishare_client/blocs/blocs.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:infishare_client/models/models.dart';
import 'package:infishare_client/repo/payment_repo.dart';
import 'package:infishare_client/screens/mywalletscreen/payment_success.dart';
import 'package:infishare_client/screens/mywalletscreen/choose_points_screen.dart';
import 'package:infishare_client/screens/mywalletscreen/choose_creditLine_screen.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ConfirmPaymentScreen extends StatefulWidget {
  final double amount;
  final User client;
  final Business business;
  final String subAccountId;
  final Coupon coupon;
  final List<String> businessId;
  ConfirmPaymentScreen(
      {this.amount,
      this.client,
      this.business,
      this.subAccountId,
      this.businessId,
      this.coupon});

  @override
  ConfirmPaymentScreenState createState() => ConfirmPaymentScreenState();
}

class ConfirmPaymentScreenState extends State<ConfirmPaymentScreen> {
  UserProfileBloc _userProfileBloc;
  PaymentRepository _paymentRepository = PaymentRepository();
  double finalCashBalance = 0;
  double finalCreditBalance = 0;
  double finalPointsBalance = 0;
  String activeNumber = "";
  String note = "";
  ProgressDialog _pr;
  var f = NumberFormat("#,###,##0.00", "en_US");

  @override
  void initState() {
    if (widget.amount > widget.client.balance) {
      finalCashBalance = widget.client.balance;
      if ((widget.amount - finalCashBalance) >
          widget.client.pointsBalance / widget.business.cashPointRate) {
        finalPointsBalance =
            widget.client.pointsBalance / widget.business.cashPointRate;
        finalCreditBalance =
            widget.amount - (finalCashBalance + finalPointsBalance);
      } else {
        finalPointsBalance = widget.amount - finalCashBalance;
      }
    } else {
      finalCashBalance = widget.amount;
    }
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
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close),
                      ),
                      Text(
                        widget.coupon == null
                            ? AppLocalizations.of(context)
                                .translate("Confirm Payment")
                            : AppLocalizations.of(context)
                                .translate("Checkout"),
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        onPressed: null,
                        icon: Icon(
                          Icons.close,
                          color: Colors.transparent,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 16),
                  RichText(
                      text: TextSpan(
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          children: <TextSpan>[
                        TextSpan(
                          text:
                              "${AppLocalizations.of(context).translate('Pay')} ",
                        ),
                        TextSpan(
                            text: "\$ ${f.format(widget.amount)} ",
                            style: TextStyle(color: Color(0xff1463a0))),
                        TextSpan(
                          text: AppLocalizations.of(context).translate('to') +
                              " ",
                        ),
                        TextSpan(
                            text: AppLocalizations.of(context)
                                        .locale
                                        .languageCode ==
                                    'en'
                                ? widget.business.businessName['English']
                                : widget.business.businessName['Chinese'],
                            style: TextStyle(color: Color(0xff1463a0))),
                      ])),
                  SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context).locale.languageCode == 'en'
                        ? "You will pay \$${f.format(widget.amount)} from your CHI+GO balance. You may apply points to cover you bill."
                        : "您将从CHI + GO余额中支付\$${f.format(widget.amount)}。您可以支付积分来支付账单。",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 32),
                  Text(
                    AppLocalizations.of(context).translate("Chi+GoBalance"),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        "\$${f.format(finalCashBalance)}",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        " (\$${f.format(widget.client.balance)} ${AppLocalizations.of(context).translate('available')})",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  Divider(
                    color: Color(0xffacacac),
                    thickness: 1,
                  ),
                  SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context).locale.languageCode == 'en'
                        ? "Points"
                        : "积分",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "\$${f.format(finalPointsBalance)}",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            " (${widget.client.pointsBalance} ${AppLocalizations.of(context).translate('points available')})",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          if (widget.client.pointsBalance != 0) {
                            showModalBottomSheet(
                              isDismissible: true,
                              isScrollControlled: true,
                              context: context,
                              builder: (BuildContext context) {
                                return BlocProvider<UserProfileBloc>.value(
                                    value: _userProfileBloc,
                                    child: ChoosePointsScreen(
                                      pointsBalance:
                                          widget.client.pointsBalance,
                                      cashPointRate:
                                          widget.business.cashPointRate,
                                    ));
                              },
                            ).then((value) {
                              if (value != null) {
                                setState(() {
                                  if ((value / 100) > widget.amount) {
                                    finalPointsBalance = widget.amount;
                                    finalCashBalance = 0;
                                    finalCreditBalance = 0;
                                  } else {
                                    finalPointsBalance = value / 100;
                                    if ((finalPointsBalance +
                                            finalCreditBalance) >
                                        widget.amount) {
                                      finalCreditBalance =
                                          widget.amount - finalPointsBalance;
                                      finalCashBalance = 0;
                                    } else {
                                      if ((finalCashBalance +
                                              finalPointsBalance +
                                              finalCreditBalance) >
                                          widget.amount) {
                                        finalCashBalance = widget.amount -
                                            (finalPointsBalance +
                                                finalCreditBalance);
                                      } else {
                                        finalCashBalance = widget.amount -
                                            (finalPointsBalance +
                                                finalCreditBalance);
                                      }
                                    }
                                  }
                                });
                              }
                            });
                          }
                        },
                        child: Text(
                          AppLocalizations.of(context).translate("Change"),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: widget.client.pointsBalance == 0
                                ? Colors.grey
                                : Color(0xff1463a0),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  widget.client.creditlineBalance != 0
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)
                                  .translate("Credit Line"),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "\$${f.format(finalCreditBalance)}",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      " (\$${f.format(widget.client.creditlineBalance)} available)",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (widget.client.creditlineBalance != 0) {
                                      showModalBottomSheet(
                                        isDismissible: true,
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return BlocProvider<
                                                  UserProfileBloc>.value(
                                              value: _userProfileBloc,
                                              child: ChooseCreditlineScreen(
                                                creditLineBalance: widget
                                                    .client.creditlineBalance,
                                              ));
                                        },
                                      ).then((value) {
                                        if (value != null) {
                                          setState(() {
                                            if (value > widget.amount) {
                                              finalCreditBalance =
                                                  widget.amount;
                                              finalCashBalance = 0;
                                              finalPointsBalance = 0;
                                            } else {
                                              finalCreditBalance = value;
                                              if ((finalCreditBalance +
                                                      finalPointsBalance) >
                                                  widget.amount) {
                                                finalCashBalance = 0;
                                                finalPointsBalance =
                                                    widget.amount -
                                                        finalCreditBalance;
                                              } else {
                                                if ((finalCashBalance +
                                                        finalPointsBalance +
                                                        finalCreditBalance) >
                                                    widget.amount) {
                                                  finalCashBalance = widget
                                                          .amount -
                                                      (finalPointsBalance +
                                                          finalCreditBalance);
                                                } else {
                                                  finalCashBalance = widget
                                                          .amount -
                                                      (finalPointsBalance +
                                                          finalCreditBalance);
                                                }
                                              }
                                            }
                                          });
                                        }
                                      });
                                    }
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .translate("Change"),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          widget.client.creditlineBalance == 0
                                              ? Colors.grey
                                              : Color(0xff1463a0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Container(),
                  Divider(
                    color: Color(0xffacacac),
                    thickness: 1,
                  ),
                  SizedBox(height: 8),
                  widget.coupon == null
                      ? Column(
                          children: [
                            Text(
                              "Note",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 16),
                            Container(
                              height: 150,
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: TextFormField(
                                maxLines: null,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                                onChanged: (value) {
                                  note = value;
                                },
                              ),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black, width: 0.5)),
                            ),
                          ],
                        )
                      : Container(),
                ],
              ),
            )),
            MaterialButton(
              height: 40,
              minWidth: MediaQuery.of(context).size.width,
              color: (finalCashBalance +
                          finalPointsBalance +
                          finalCreditBalance) ==
                      widget.amount
                  ? Color(0xff1463a0)
                  : Colors.grey,
              onPressed: () async {
                _pr.show();
                if ((finalCashBalance +
                        finalPointsBalance +
                        finalCreditBalance) ==
                    widget.amount) {
                  if (widget.coupon == null) {
                    DateTime now = DateTime.now();
                    String formattedDate =
                        DateFormat('kk:mm:ss EEE d MMM').format(now);

                    activeNumber = await _paymentRepository.payToBusiness(
                        amount: widget.amount,
                        finalCashBalance: finalCashBalance,
                        finalPointsBalance: finalPointsBalance,
                        finalCreditlineBalance: finalCreditBalance,
                        business: widget.business,
                        subAccountId: widget.subAccountId,
                        coupon: widget.coupon,
                        note: note);
                    if (widget.business.phone != "") {
                      if (widget.subAccountId != "") {
                        DocumentSnapshot BusinessDoc = await Firestore.instance
                            .collection("Business")
                            .document(widget.subAccountId)
                            .get();
                        var response = await http.post(
                            Uri.parse(
                                'https://us-central1-chiplusgo-95ec4.cloudfunctions.net/textmessageV2'),
                            body: {
                              "Phone": "+1${BusinessDoc.data['Phone']}",
                              "Body":
                                  "CHI+GO: \n ===== Time: $formattedDate ===== \n ===== From: ${widget.client.name} ===== \n ===== Money amount: \$${widget.amount} ===== \n ===== Note: $note =====",
                              "From": "+13462331831"
                            });
                        print(
                            '------------------send subaccount--------+1${BusinessDoc.data['Phone']}');
                        print(
                            '------------------send response--------${response.body}');
                      } else {
                        var response = await http.post(
                            Uri.parse(
                                'https://us-central1-chiplusgo-95ec4.cloudfunctions.net/textmessageV2'),
                            body: {
                              "Phone": "+1${widget.business.phone}",
                              "Body":
                                  "CHI+GO: \n ===== Time: $formattedDate ===== \n ===== From: ${widget.client.name} ===== \n ===== Money amount: \$${widget.amount} ===== \n ===== Note: $note =====",
                              "From": "+13462331831"
                            });
                        print(
                            '------------------send mainaccount--------+1${widget.business.phone}');
                        print(
                            '------------------send mainaccount--------${response.body}');
                      }

                      // if (response.body.isEmpty) {
                      //   print(
                      //       '-----------------------------------${response.body.isEmpty}');
                      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //     content: Text("Sent SMS to ${widget.business.phone}"),
                      //   ));
                      // } else {
                      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //     content: Text(
                      //         "Failed sending SMS to ${widget.business.phone}"),
                      //   ));
                      // }
                    }
                  } else {
                    activeNumber = await _paymentRepository.purchaseCoupon(
                        amount: widget.amount,
                        finalCashBalance: finalCashBalance,
                        finalPointsBalance: finalPointsBalance,
                        finalCreditlineBalance: finalCreditBalance,
                        business: widget.business,
                        coupon: widget.coupon);
                  }
                  _pr.hide();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PaymentSuccessScreen(activeNumber)));
                }
              },
              child: Text(
                AppLocalizations.of(context).translate("Confirm"),
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2)),
            )
          ],
        ),
      ),
    );
  }
}
