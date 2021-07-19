import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infishare_client/blocs/blocs.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:infishare_client/screens/commen_widgets/error_placeholder_page.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'bottom_bar_widgets.dart';
import 'package:infishare_client/models/models.dart';
import 'coupon_widgets.dart';
import 'payment_widgets.dart';
import 'tip_widgets.dart';

class CheckoutScreen extends StatefulWidget {
  final Coupon coupon;
  final Business business;

  CheckoutScreen({this.coupon, this.business});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  ScrollController _scrollController;
  CheckOutBloc _checkOutBloc;
  ProgressDialog _pr;
  final FirebaseAnalytics _analytics = FirebaseAnalytics();

  @override
  void initState() {
    super.initState();
    _buildLoadingView();
    _scrollController = ScrollController();
    _checkOutBloc = BlocProvider.of<CheckOutBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        elevation: 1.0,
        title: Text(
          AppLocalizations.of(context).translate('Checkout'),
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: BlocListener<CheckOutBloc, CheckOutState>(
        listener: (context, state) {
          if (state is CheckOutProcessing) {
            //* show loading view
            _pr.show();
          } else if (state is CheckOutSuccess) {
            _analytics.logEcommercePurchase(
              currency: 'usd',
              value: state.totalAmount,
              tax: state.tax,
              // transactionId: widget.coupon.businessId + widget.coupon.couponId,
              transactionId: widget.coupon.couponId,
            );
            _pr.hide().then((v) {
              if (v) {
                Navigator.of(context).pushReplacementNamed(
                  '/check_out_success',
                  arguments: {
                    'receipt': state.receiptNum,
                    // 'type': widget.coupon.couponType,
                  },
                );
              }
            });
            //* navigate to success page
          } else if (state is CheckOutError) {
            //* show error page
            _pr.hide().then((hide) {
              if (hide) {
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
            });
          } else if (state is CheckOutCancel) {
            _pr.hide();
          }
        },
        child: BlocBuilder<CheckOutBloc, CheckOutState>(
          builder: (context, state) {
            if (state is PaymentDataLoading) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(
                    Color(0xff242424),
                  ),
                ),
              );
            }

            if (state is PaymentDataError) {
              return Center(
                child: ErrorPlaceHolder(state.errorMsg),
              );
            }

            if (state is PaymentDataCacheState) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: _scrollController,
                padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  CouponSection(
                    coupon: widget.coupon,
                    business: widget.business,
                    amount: state.amount,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  PaymentSection(
                    paymentMethod: state.paymentMethod,
                    balance: state.balance,
                    usage: state.infiCash,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  // TipAndDetailSection(
                  //   tipBase: widget.coupon.tips,
                  //   tip: state.tips,
                  //   subtotal: state.subTotal,
                  //   total: state.totalAmount,
                  //   tax: state.tax,
                  //   inficash: state.infiCash,
                  // ),
                ],
              );
            }
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: Colors.white,
        child: BlocBuilder<CheckOutBloc, CheckOutState>(
          builder: (context, state) {
            if (state is PaymentDataCacheState) {
              return BottomBar(
                onCheckOutTapped:
                    (state.paymentMethod == "" && state.totalAmount > 0)
                        ? null
                        : () async {
                            _checkOutBloc.add(
                              CheckOut(),
                            );
                          },
                onDetailTapped: () => _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  curve: Curves.easeOut,
                  duration: const Duration(milliseconds: 300),
                ),
                total: state.totalAmount,
              );
            } else {
              return Container(
                height: 0.0,
              );
            }
          },
        ),
      ),
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
}
