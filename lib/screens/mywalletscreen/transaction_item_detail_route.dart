import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:infishare_client/models/business.dart';
import 'package:infishare_client/models/transaction_history.dart';
import 'package:infishare_client/repo/infishare_api.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class TransactionItemDetailRoute extends StatefulWidget {
  final TransactionHistory transactionHistory;
  TransactionItemDetailRoute({this.transactionHistory});

  @override
  TransactionItemDetailRouteState createState() =>
      TransactionItemDetailRouteState();
}

class TransactionItemDetailRouteState
    extends State<TransactionItemDetailRoute> {
  InfiShareApiClient _infiShareApiClient =
      InfiShareApiClient(httpClient: http.Client());
  Business business;
  DocumentSnapshot admin;
  bool isLoad = false;
  double refundEarnedPoint = 0;

  @override
  void initState() {
    print(widget.transactionHistory.businessId);
    if (widget.transactionHistory.businessId != "") {
      getBusiness();
    } else {
      isLoad = true;
    }
    super.initState();
  }

  getBusiness() async {
    Business _business = await _infiShareApiClient
        .getBusinessById(widget.transactionHistory.businessId[0]);
    DocumentSnapshot _admin = await _infiShareApiClient.getAdmin();
    setState(() {
      business = _business;
      admin = _admin;
      isLoad = true;
      refundEarnedPoint = widget.transactionHistory.earnedPoint -
          admin.data['CashPointRate'] *
              widget.transactionHistory.finalPointBalance;
    });
  }

  @override
  Widget build(BuildContext context) {
    var f = NumberFormat("#,###,##0.00", "en_US");
    var pointFormat = NumberFormat("#,###,##0", "en_US");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.keyboard_arrow_left, size: 35)),
        title: Text(
          widget.transactionHistory.getCreateTimeString(),
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: isLoad == true
          ? Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(8),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Align(
                    //   alignment: Alignment.center,
                    //   child: Container(
                    //     width: MediaQuery.of(context).size.width,
                    //     padding: EdgeInsets.symmetric(vertical: 16),
                    //     color: Color(0xfff1f2f4),
                    //     child: Column(
                    //       children: [
                    //         widget.transactionHistory.type == "Charge"
                    //             ? Image.asset(
                    //                 "assets/images/logo.png",
                    //                 height: 80,
                    //                 width: 80,
                    //               )
                    //             : ClipRRect(
                    //                 borderRadius: BorderRadius.circular(40),
                    //                 child: Image.network(
                    //                   business.logo,
                    //                   height: 80,
                    //                   width: 80,
                    //                 ),
                    //               ),
                    //         Padding(
                    //           padding: EdgeInsets.symmetric(vertical: 8),
                    //           child: Text(
                    //             widget.transactionHistory.type == "Charge"
                    //                 ? "CHI+GO"
                    //                 : (AppLocalizations.of(context)
                    //                             .locale
                    //                             .languageCode ==
                    //                         'en'
                    //                     ? business.businessName['English']
                    //                     : business.businessName['Chinese']),
                    //             style: TextStyle(
                    //                 fontSize: 16, fontWeight: FontWeight.bold),
                    //           ),
                    //         ),
                    //         Text(
                    //           widget.transactionHistory.title,
                    //           style: TextStyle(
                    //               color: Colors.grey,
                    //               fontSize: 14,
                    //               fontWeight: FontWeight.w600),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),

                    SizedBox(height: 16),

                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        widget.transactionHistory.type == "Charge" ||
                                widget.transactionHistory.type ==
                                    "Gift Charge" ||
                                widget.transactionHistory.type == "Refund"
                            ? ("+\$" +
                                f.format((widget.transactionHistory.chargeCash)
                                    .abs()))
                            : ("-\$" +
                                f.format((widget.transactionHistory.usedCash)
                                    .abs())),
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                    ),

                    SizedBox(height: 8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star,
                          color: Color(0xfffcd300),
                        ),
                        widget.transactionHistory.type == "Refund"
                            ? Text(
                                "- ${pointFormat.format(refundEarnedPoint)} points",
                                style: TextStyle(
                                    fontSize: 12, color: Color(0xfffcd300)),
                              )
                            : Text(
                                "+ ${pointFormat.format(widget.transactionHistory.earnedPoint.toInt())} points",
                                style: TextStyle(
                                    fontSize: 12, color: Color(0xfffcd300)),
                              ),
                      ],
                    ),

                    // Text(
                    //   "Recharge Source",
                    //   style: TextStyle(
                    //     color: Colors.grey,
                    //     fontSize: 14
                    //   ),
                    // ),

                    // SizedBox(height: 16),

                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text(
                    //       "Citibank@Debit",
                    //       style: TextStyle(
                    //         fontSize: 16,
                    //         fontWeight: FontWeight.w600
                    //       ),
                    //     ),

                    //     Text(
                    //       "\$10.00",
                    //       style: TextStyle(
                    //         fontSize: 16,
                    //         fontWeight: FontWeight.w600
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    SizedBox(height: 16),

                    Text(
                      "Acitivity Type",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),

                    SizedBox(height: 16),

                    Text(
                      widget.transactionHistory.type,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),

                    SizedBox(height: 16),

                    Divider(
                      height: 0.5,
                      color: Color(0xffacacac),
                    ),

                    SizedBox(height: 16),

                    Text(
                      "Activity Number",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),

                    SizedBox(height: 16),

                    Text(
                      widget.transactionHistory.id,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(height: 16),

                    (widget.transactionHistory.type != "Charge" &&
                            widget.transactionHistory.type != "Gift Charge")
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "ACTIVITY DETAILS",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey),
                              ),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      // if (widget.transactionHistory.type ==
                                      //     "Purchase")
                                      //   Text(
                                      //     AppLocalizations.of(context)
                                      //         .translate('Purchase Coupon'),
                                      //     style: TextStyle(
                                      //       fontWeight: FontWeight.w600,
                                      //     ),
                                      //   ),
                                      Text(
                                        widget.transactionHistory.title,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "\$${f.format(widget.transactionHistory.usedCash)}",
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  if (widget.transactionHistory.type !=
                                      "Refund")
                                    Text(
                                      "Covered by Points (${(widget.transactionHistory.finalPointBalance * 100).toInt()})",
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  if (widget.transactionHistory.type ==
                                      "Refund")
                                    Text(
                                      "Covered by Points (${(widget.transactionHistory.finalPointBalance * 100).toInt()})",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  if (widget.transactionHistory.type !=
                                      "Refund")
                                    Text(
                                      "-\$${f.format(widget.transactionHistory.finalPointBalance)}",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  if (widget.transactionHistory.type ==
                                      "Refund")
                                    Text(
                                      "+\$${f.format(widget.transactionHistory.finalPointBalance)}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                ],
                              ),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  if (widget.transactionHistory.type !=
                                      "Refund")
                                    Text(
                                      "Covered by ChiBei",
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  if (widget.transactionHistory.type ==
                                      "Refund")
                                    Text(
                                      "Covered by ChiBei",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  if (widget.transactionHistory.type !=
                                      "Refund")
                                    Text(
                                      "-\$${f.format(widget.transactionHistory.finalCreditBalance)}",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  if (widget.transactionHistory.type ==
                                      "Refund")
                                    Text(
                                      "+\$${f.format(widget.transactionHistory.finalCreditBalance)}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                ],
                              ),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Total",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    "\$${f.format(widget.transactionHistory.finalCashBalance)}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              if (widget.transactionHistory.type != "Purchase")
                                Text(
                                  "Note",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              SizedBox(height: 8),
                              if (widget.transactionHistory.type != "Purchase")
                                Text(
                                  widget.transactionHistory.note,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                            ],
                          )
                        : Container(),

                    SizedBox(height: 16),

                    Divider(
                      height: 0.5,
                      color: Color(0xffacacac),
                    ),
                  ],
                ),
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
