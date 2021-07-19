import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infishare_client/blocs/blocs.dart';
import 'package:infishare_client/blocs/recharge_bloc/recharge_inficash_bloc.dart';
import 'package:infishare_client/language/app_localization.dart';

class PaymentMethodSection extends StatelessWidget {
  final String paymentMethod;

  const PaymentMethodSection({this.paymentMethod});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width,
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
          paymentMethod != ''
              ? Container(
                  padding: EdgeInsets.all(0),
                  color: Colors.transparent,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        _getBankCardInfo(),
                        width: 24,
                        //16:9
                        height: 16,
                        // use fit to x`fulfill the box
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
                          BlocProvider.of<RechargeInficashBloc>(context).add(
                            ShowChangePayment(),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(0),
                          child: Text(
                            AppLocalizations.of(context)
                                .translate('change payment'),
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
                )
              : GestureDetector(
                  onTap: () {
                    BlocProvider.of<RechargeInficashBloc>(context)
                        .add(ShowChangePayment());
                  },
                  child: Text(
                    AppLocalizations.of(context)
                        .translate("Please add a payment method"),
                    style: TextStyle(
                      color: Color(0xff1463a0),
                      fontWeight: FontWeight.w600
                    ),
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
