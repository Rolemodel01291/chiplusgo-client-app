import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infishare_client/blocs/blocs.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:infishare_client/screens/checkoutPage/choose_inficash_screen.dart';
import 'dart:math';

import 'package:intl/intl.dart';

class PaymentSection extends StatelessWidget {
  final String paymentMethod;
  final double balance;
  final double usage;
  CheckOutBloc _checkOutBloc;
  var f = NumberFormat("#,###,##0.00", "en_US");
  PaymentSection({this.paymentMethod, this.balance, this.usage});
  @override
  Widget build(BuildContext context) {
    _checkOutBloc = BlocProvider.of<CheckOutBloc>(context);
    return Container(
      padding: EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width,
      height: 178,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            AppLocalizations.of(context).translate('Payment method'),
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF242424),
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Container(
            padding: EdgeInsets.all(0),
            height: 30,
            color: Colors.transparent,
            child: paymentMethod != ''
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        _getBankCardInfo(),
                        width: 24,
                        //16:9
                        height: 16,
                        // use fit to fulfill the box
                        fit: BoxFit.cover,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        paymentMethod,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF555555),
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          BlocProvider.of<CheckOutBloc>(context)
                              .add(ChangePayment());
                        },
                        child: Container(
                          padding: EdgeInsets.all(0),
                          child: Text(
                            AppLocalizations.of(context)
                                .translate('change payment'),
                            textAlign: TextAlign.right,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 14, color: Color(0xFF266EF6)),
                          ),
                        ),
                      )
                    ],
                  )
                : FlatButton(
                    padding: EdgeInsets.all(0.0),
                    onPressed: () {
                      BlocProvider.of<CheckOutBloc>(context)
                          .add(ChangePayment());
                    },
                    child: Text(
                      AppLocalizations.of(context)
                          .translate('Please add a payment method'),
                      style: TextStyle(color: Color(0xFF266EF6)),
                    ),
                  ),
          ),
          SizedBox(
            height: 24,
          ),
          Text(
            "InfiCash",
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF242424),
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Container(
            padding: EdgeInsets.all(0),
            height: 16,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "\$${f.format(usage)} ",
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, color: Color(0xFF00AC5C)),
                ),
                Text(
                  "(\$${f.format(balance)} available)",
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, color: Color(0xFFACACAC)),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return BlocProvider<CheckOutBloc>.value(
                          value: _checkOutBloc,
                          child: ChooseInfiCashScreen(
                            inficash: _checkOutBloc.infiCash,
                            maxUsage: min(
                                _checkOutBloc.subTotal +
                                    _checkOutBloc.tax +
                                    _checkOutBloc.tips,
                                _checkOutBloc.balance),
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(0),
                    child: Text(
                      AppLocalizations.of(context).translate('change payment'),
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF266EF6),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getBankCardInfo() {
    if (paymentMethod.toLowerCase().contains('master')) {
      return 'assets/images/mastercard.png';
    } else if (paymentMethod.toLowerCase().contains('visa')) {
      return 'assets/images/visa.png';
    } else if (paymentMethod.contains('Apple')) {
      return 'assets/images/applepay.png';
    } else {
      return 'assets/images/errorimageplacehold.png';
    }
  }
}
