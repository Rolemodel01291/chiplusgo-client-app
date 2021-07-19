import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infishare_client/blocs/blocs.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:infishare_client/repo/repo.dart';
import 'history_section.dart';
import 'recharge_section.dart';

class InficashRoute extends StatefulWidget {
  final int initIndex;

  const InficashRoute({this.initIndex});

  @override
  _InficashRouteState createState() => _InficashRouteState();
}

class _InficashRouteState extends State<InficashRoute> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: widget.initIndex,
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(0, 88),
          child: Container(
            padding: EdgeInsets.only(bottom: 0.5),
            color: Color(0xFFACACAC),
            child: AppBar(
              elevation: 0,
              title: Text(
                "InfiCash",
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF242424),
                ),
              ),
              backgroundColor: Colors.white,
              bottom: PreferredSize(
                preferredSize: Size(0, 44),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 44,
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: TabBar(
                    labelColor: Color(0xFF73B12D),
                    // labelPadding: EdgeInsets.only(left: 16,right: 16),
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                    unselectedLabelStyle: TextStyle(),
                    unselectedLabelColor: Color(0xFF242424),
                    indicatorColor: Color(0xFF73B12D),
                    indicatorWeight: 4,
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelPadding: EdgeInsets.all(0),
                    isScrollable: false,
                    tabs: <Widget>[
                      Tab(
                        text: AppLocalizations.of(context).translate('History'),
                      ),
                      Tab(
                        text: AppLocalizations.of(context)
                            .translate('Recharge account'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            BlocProvider(
              create: (context) =>
                  ChargeHistoryBloc(paymentRepository: PaymentRepository())
                    ..add(
                      FetchChargeHistory(),
                    ),
              child: HistorySection(),
            ), // tab shows history page
            BlocProvider(
              create: (context) => RechargeInficashBloc(
                paymentRepository: PaymentRepository(),
              )..add(
                  FetchRechargeOptions(),
                ),
              child: RechargeSection(),
            ) // tab shows recharge page
          ],
        ),
      ),
    );
  }
}
