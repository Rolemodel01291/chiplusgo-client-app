import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infishare_client/blocs/my_vouchers_bloc/bloc.dart';
import 'package:infishare_client/blocs/my_vouchers_bloc/my_vouchers_bloc_bloc.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:infishare_client/repo/coupon_repo.dart';
import 'package:infishare_client/repo/repo.dart';
import 'myVouchers_vertical_list_section.dart';
import 'package:http/http.dart' as http;
import 'package:infishare_client/blocs/blocs.dart';

class MyVouchersRoute extends StatefulWidget {
  final String type;
  final String title;
  MyVouchersRoute({this.type, this.title});

  @override
  _MyVouchersRouteState createState() => _MyVouchersRouteState();
}

class _MyVouchersRouteState extends State<MyVouchersRoute> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(0, 87),
          child: Container(
            padding: EdgeInsets.only(bottom: 0.5),
            color: Color(0xFFACACAC),
            child: AppBar(
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.chevron_left,
                  color: Color(0xff242424),
                  size: 30,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: Text(
                widget.title,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
              backgroundColor: Colors.white,
              bottom: PreferredSize(
                preferredSize: Size(0, 44),
                child: Container(
                  // color: Colors.red,
                  width: MediaQuery.of(context).size.width,
                  height: 44,
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: TabBar(
                    labelColor: Color(0xFF242424),
                    labelPadding: EdgeInsets.only(left: 16, right: 16),
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                    unselectedLabelStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                    indicatorColor: Color(0xFF242424),
                    indicatorWeight: 4,
                    indicatorSize: TabBarIndicatorSize.tab,
                    // labelPadding: EdgeInsets.all(0),
                    isScrollable: false,
                    tabs: <Widget>[
                      Tab(
                        text:
                            AppLocalizations.of(context).translate("Available"),
                      ),
                      Tab(
                        text: AppLocalizations.of(context).translate("Used"),
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
              create: (context) => MyVouchersBlocBloc(
                couponRepository: CouponRepository(
                  client: InfiShareApiClient(httpClient: http.Client()),
                ),
              )..add(FetchUserVouchersTicket(type: widget.type, used: false)),
              child: UnusedVouchersVerticalListSection(
                type: widget.type,
              ),
            ),
            BlocProvider(
              create: (context) => MyVouchersBlocBloc(
                couponRepository: CouponRepository(
                  client: InfiShareApiClient(httpClient: http.Client()),
                ),
              )..add(FetchUserVouchersTicket(type: widget.type, used: true)),
              child: UsedCouponsVerticalListSection(
                type: widget.type,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
