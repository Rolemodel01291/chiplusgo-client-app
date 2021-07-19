import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infishare_client/blocs/blocs.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:infishare_client/repo/repo.dart';
import 'package:infishare_client/screens/mywalletscreen/recharge_section.dart';

class RechargeRoute extends StatefulWidget {
  @override
  _RechargeRouteState createState() => _RechargeRouteState();
}

class _RechargeRouteState extends State<RechargeRoute> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.keyboard_arrow_left, size: 35),
          ),
          title: Text(
            AppLocalizations.of(context).translate("Recharge"),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF242424),
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: BlocProvider(
          create: (context) => RechargeInficashBloc(
            paymentRepository: PaymentRepository(),
          )..add(
              FetchRechargeOptions(),
            ),
          child: RechargeSection(),
        ));
  }
}
