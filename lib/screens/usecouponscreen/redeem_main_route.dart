import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infishare_client/blocs/blocs.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'redeemByQR_section.dart';
import 'redeemByMerchant_section.dart';
import 'package:progress_dialog/progress_dialog.dart';

class RedeemMainRoute extends StatefulWidget {
  RedeemMainRoute();

  @override
  RedeemMainRouteState createState() => RedeemMainRouteState();
}

class RedeemMainRouteState extends State<RedeemMainRoute> {
  ProgressDialog _pr;

  @override
  void initState() {
    super.initState();
    _buildLoadingView();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<QrCodeBlocBloc, QrCodeBlocState>(
      listener: (context, state) {
        if (state is QRCodeRedeemLoading) {
          _pr.show();
        } else if (state is QRCodeRedeemFailed) {
          _pr.hide();
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(16.0),
                    ),
                  ),
                  titlePadding: EdgeInsets.all(16.0),
                  contentPadding: EdgeInsets.all(16.0),
                  title: Text('Ooops..'),
                  content: Text(state.errorMsg),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(AppLocalizations.of(context).translate('OK')),
                      onPressed: () {
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        }
                      },
                    )
                  ],
                );
              });
        } else if (state is QRCodeRedeemSuccess) {
          _pr.hide().then((ishide) {
            BlocProvider.of<TicketDetailBloc>(context).add(
              // FetchCouponDetail(couponId: state.ticket.ticketNum),
              FetchCouponDetail(couponId: state.ticket.couponTicketId),
            );
            Navigator.of(context).pushReplacementNamed(
              '/redeem_success',
              // arguments: state.ticket.ticketNum,
              arguments: state.ticket.couponTicketId,
            );
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            AppLocalizations.of(context).translate('Show to business'),
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF242424)),
          ),
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.chevron_left,
              size: 30,
              color: Color(0xff242424),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: BlocBuilder<QrCodeBlocBloc, QrCodeBlocState>(
          builder: (context, state) {
            if (state is QRCodeState) {
              return Container(
                color: Color(0xFFF1F2F4),
                child: ListView(
                  children: <Widget>[
                    RedeemByQRSection(
                      ticket: state.ticket,
                    ),
                    SizedBox(height: 8),
                    RedeemByMerchantSection(
                      confirm: state.redeemMethod == RedeemMethod.Merchant,
                      couponTicket:state.ticket,
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  _buildLoadingView() {
    _pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    _pr.style(
      message: 'Loading',
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
}
