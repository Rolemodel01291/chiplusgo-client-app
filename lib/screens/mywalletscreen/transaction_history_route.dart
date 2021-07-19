import 'package:flutter/material.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:infishare_client/models/transaction_history.dart';
import 'package:infishare_client/repo/repo.dart';
import 'package:infishare_client/screens/businesslist/restaurants_segment_section.dart';
import 'package:infishare_client/screens/commen_widgets/transaction_item.dart';
import 'package:infishare_client/screens/mywalletscreen/transaction_item_detail_route.dart';

class TransactionHistoryRoute extends StatefulWidget {
  @override
  _TransactionHistoryRouteState createState() =>
      _TransactionHistoryRouteState();
}

class _TransactionHistoryRouteState extends State<TransactionHistoryRoute> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PaymentRepository _paymentRepository = PaymentRepository();
  List<TransactionHistory> transactionHistorys = [];
  List<TransactionHistory> filteredTransactionHistorys = [];
  bool isLoad = false;
  int timeIndex = 0;
  int typeIndex = 0;
  @override
  void initState() {
    getTransactionHistorys();
    super.initState();
  }

  getTransactionHistorys() async {
    List<TransactionHistory> _transactionHistories =
        await _paymentRepository.getTransactionHistory();
    setState(() {
      transactionHistorys = _transactionHistories;
      filteredTransactionHistorys = _transactionHistories;
      isLoad = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.keyboard_arrow_left, size: 35),
        ),
        title: Text(
          AppLocalizations.of(context).locale.languageCode == 'en'
              ? "Activity"
              : "交易记录",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          Center(
            child: GestureDetector(
              onTap: () {
                _scaffoldKey.currentState.openEndDrawer();
              },
              child: Padding(
                padding: EdgeInsets.only(right: 16),
                child: Text(
                  AppLocalizations.of(context).locale.languageCode == 'en'
                      ? "Filter"
                      : "筛选",
                  style: TextStyle(
                      color: Color(0xff1463a0),
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
      endDrawer: Drawer(
          child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.only(top: 16, bottom: 16),
          children: <Widget>[
            // reset/apply buttons row
            Container(
              padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: MediaQuery.of(context).padding.top,
                  bottom: 16),
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    child: Text(
                      AppLocalizations.of(context).translate('Reset'),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff1463a0),
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  Spacer(),
                  GestureDetector(
                    child: Text(
                      AppLocalizations.of(context).translate('Apply'),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff1463a0),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        if (typeIndex != 0) {
                          String filterType = "";
                          if (typeIndex == 1) {
                            filterType = "Charge";
                          } else if (typeIndex == 2) {
                            filterType = "Pay";
                          } else {
                            filterType = "Refund";
                          }
                          filteredTransactionHistorys = transactionHistorys
                              .where((element) => element.type == filterType)
                              .toList();
                        } else {
                          filteredTransactionHistorys = transactionHistorys;
                        }
                      });
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),

            // line container
            Container(
              height: 0.5,
              color: Color(0xFFACACAC),
            ),

            // sort by/distance section
            Container(
              padding: EdgeInsets.only(top: 16, bottom: 16),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Text(
                      'Time',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF242424),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  BusinessSegmentSection(
                    onValueChange: (val) {
                      setState(() {
                        timeIndex = val;
                      });
                    },
                    logoWidgets: {
                      0: Text(
                        'All',
                        style: TextStyle(fontSize: 14),
                      ),
                      1: Text(
                        'Daily',
                        style: TextStyle(fontSize: 14),
                      ),
                      2: Text(
                        'Weekly',
                        style: TextStyle(fontSize: 14),
                      ),
                      3: Text(
                        'Monthly',
                        style: TextStyle(fontSize: 14),
                      ),
                    },
                    seletedIndex: timeIndex,
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Text(
                      'Type',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF242424),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  BusinessSegmentSection(
                    logoWidgets: {
                      0: Text(
                        'All',
                        style: TextStyle(fontSize: 14),
                      ),
                      1: Text(
                        'Charge',
                        style: TextStyle(fontSize: 14),
                      ),
                      2: Text(
                        'Pay',
                        style: TextStyle(fontSize: 14),
                      ),
                      3: Text(
                        'Refund',
                        style: TextStyle(fontSize: 14),
                      ),
                    },
                    onValueChange: (val) {
                      setState(() {
                        typeIndex = val;
                      });
                    },
                    seletedIndex: typeIndex,
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
      body: isLoad == false
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.all(8),
              child: SingleChildScrollView(
                child: Column(
                  children:
                      filteredTransactionHistorys.map((transactionHistory) {
                    return TransactionItem(
                      transactionHistory: transactionHistory,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    TransactionItemDetailRoute(
                                      transactionHistory: transactionHistory,
                                    )));
                      },
                    );
                  }).toList(),
                ),
              ),
              // child: BlocProvider(
              //   create: (context) =>
              //       TransactionHistoryBloc(paymentRepository: PaymentRepository())
              //         ..add(
              //           FetchTransactionHistory(),
              //         ),
              //   child: TransactionHistorySection(),
              // ),
            ),
    );
  }
}
