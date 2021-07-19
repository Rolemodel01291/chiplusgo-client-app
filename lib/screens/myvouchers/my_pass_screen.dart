import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infishare_client/blocs/my_coupon_bloc/my_coupon_bloc_bloc.dart';
import 'package:infishare_client/repo/coupon_repo.dart';
import 'package:infishare_client/repo/repo.dart';
import 'package:infishare_client/repo/utils/firebase_consts.dart';
import 'myVouchers_vertical_list_section.dart';
import 'package:http/http.dart' as http;
import 'package:infishare_client/blocs/blocs.dart';

class MyPassScreen extends StatefulWidget {
  final String type;
  final String title;
  MyPassScreen({this.type, this.title});

  @override
  _MyPassScreenState createState() => _MyPassScreenState();
}

class _MyPassScreenState extends State<MyPassScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: BlocProvider(
        create: (context) => MyCouponBlocBloc(
          couponRepository: CouponRepository(
            client: InfiShareApiClient(httpClient: http.Client()),
          ),
        )..add(
            FetchUserCouponTicket(type: widget.type, used: false),
          ),
        child: UsedCouponsVerticalListSection(
          type: FirestoreConstants.GROUP_BUY,
        ),
      ),
    );
  }
}
