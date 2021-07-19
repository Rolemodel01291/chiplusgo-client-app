import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infishare_client/blocs/blocs.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:infishare_client/models/coupon_ticket.dart';
import 'package:infishare_client/screens/commen_widgets/swipe_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:infishare_client/screens/helpPage/help_route.dart';

class RedeemByMerchantSection extends StatefulWidget {
  final bool confirm;
  final CouponTicket couponTicket;
  const RedeemByMerchantSection(
      {Key key, @required this.confirm, this.couponTicket});
  @override
  RedeemByMerchantSectionState createState() => RedeemByMerchantSectionState();
}

class RedeemByMerchantSectionState extends State<RedeemByMerchantSection> {
  QrCodeBlocBloc _qrCodeBlocBloc;

  String selectedId = '';
  String selectedName = "";

  Future<void> _redeemAction() async {
    if (AppLocalizations.of(context).locale.languageCode == 'en') {
      selectedName = widget.couponTicket.businessName[0]['English'];
      selectedId = widget.couponTicket.businessId[0];
    } else {
      selectedName = widget.couponTicket.businessName[0]['Chinese'];
      selectedId = widget.couponTicket.businessId[0];
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              AppLocalizations.of(context).translate('Redeem by merchant'),
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF303030)),
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Text(
                AppLocalizations.of(context).translate('Confirm dialog'),
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 25),
              Text(
                AppLocalizations.of(context)
                    .translate('Please select business'),
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              StatefulBuilder(
                  builder: (BuildContext context, StateSetter dropDownState) {
                return DropdownButton<String>(
                  value: selectedName,
                  isExpanded: true,
                  items: widget.couponTicket.businessName.map((value) {
                    return new DropdownMenuItem<String>(
                      value: AppLocalizations.of(context).locale.languageCode ==
                              'en'
                          ? value['English']
                          : value['Chinese'],
                      child: new Text(
                        AppLocalizations.of(context).locale.languageCode == 'en'
                            ? value['English']
                            : value['Chinese'],
                        style: new TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                  onChanged: (String value) {
                    for (int index = 0;
                        index < widget.couponTicket.businessName.length;
                        index++) {
                      print(
                          '${widget.couponTicket.businessName[index]['English']} $value');
                      if (AppLocalizations.of(context).locale.languageCode ==
                          'en') {
                        if (widget.couponTicket.businessName[index]
                                ['English'] ==
                            value) {
                          setState(() {
                            selectedId = widget.couponTicket.businessId[index];
                          });
                        }
                      } else {
                        if (widget.couponTicket.businessName[index]
                                ['Chinese'] ==
                            value) {
                          selectedId = widget.couponTicket.businessId[index];
                        }
                      }
                    }

                    dropDownState(() {
                      selectedName = value;
                    });
                  },
                );
              }),
            ]),
          ),
          actions: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      child: FlatButton(
                        textColor: Color(0xFF266EF6),
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context).translate('Cancel'),
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                        onPressed: () {
                          print("jump back page");
                          Navigator.of(context).pop();
                        },
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Color(0xFF266EF6),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(4)),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      height: 48,
                      child: FlatButton(
                          color: Color(0xFFC60404),
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context).translate("Confirm"),
                              textAlign: TextAlign.right,
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                          onPressed: () {
                            _qrCodeBlocBloc.add(ChangeRedeemMethod());

                            Navigator.of(context).pop();
                          }),
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buttonsRow() {
    return Padding(
      padding: EdgeInsets.only(top: 32),
      child: Row(
        children: <Widget>[
          Container(
            width: (MediaQuery.of(context).size.width - 32 - 16) / 2,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(
                width: 1,
                color: Color(0xFF266EF6),
              ),
            ),
            child: FlatButton(
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(5.0),
                ),
                color: Colors.white,
                textColor: Color(0xFF266EF6),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)
                        .translate('Help')
                        .toUpperCase(),
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return BlocProvider(
                          create: (context) => HelpBloc(
                              userRepository: BlocProvider.of<AuthBloc>(context)
                                  .userRepository),
                          child: HelpRoute(
                            showBusiness: false,
                            // user: state is MyAccountLoaded
                            //     ? state.user
                            //     : null,
                          ),
                        );
                      },
                    ),
                  );
                }),
          ),
          SizedBox(
            width: 16,
          ),
          SizedBox(
            width: (MediaQuery.of(context).size.width - 32 - 16) / 2,
            height: 40,
            child: FlatButton(
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(5.0),
                ),
                color: Color(0xFFC60404),
                textColor: Colors.white,
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)
                        .translate('I merchant')
                        .toUpperCase(),
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onPressed: () {
                  _redeemAction();
                }),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _qrCodeBlocBloc = BlocProvider.of<QrCodeBlocBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            AppLocalizations.of(context).translate('Redeem by merchant'),
            textAlign: TextAlign.start,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF242424)),
          ),
          SizedBox(height: 16),
          TermItem(
              title: AppLocalizations.of(context).translate('merchant rule 1'),
              numbs: "1"),
          SizedBox(height: 12),
          TermItem(
              title: AppLocalizations.of(context).translate('merchant rule 2'),
              numbs: "2"),
          SizedBox(height: 12),
          TermItem(
              title: AppLocalizations.of(context).translate('merchant rule 3'),
              numbs: "3"),
          SizedBox(height: 12),
          TermItem(
              title: AppLocalizations.of(context).translate('merchant rule 4'),
              numbs: "4"),
          widget.confirm
              ? BlocBuilder<QrCodeBlocBloc, QrCodeBlocState>(
                  builder: (context, state) {
                    return Padding(
                      padding: EdgeInsets.only(top: 28),
                      child: SwipeButton(
                        initialPosition: state is QRCodeRedeemSuccess
                            ? SwipePosition.SwipeRight
                            : SwipePosition.SwipeLeft,
                        borderRadius: BorderRadius.circular(22),
                        height: 44,
                        thumb: Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                          size: 40,
                        ),
                        content: Center(
                          child: state is QRCodeRedeemLoading
                              ? CircularProgressIndicator()
                              : Text(
                                  AppLocalizations.of(context)
                                      .translate('Slide to redeem'),
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
                        onChanged: (result) async {
                          if (result == SwipePosition.SwipeRight) {
                            String documentId = await Firestore.instance
                                .collection("Orders")
                                .document("Orders")
                                .collection(selectedId)
                                .document()
                                .documentID;
                            DocumentSnapshot ClientDoc = await Firestore
                                .instance
                                .collection("Client")
                                .document(widget.couponTicket.clientId)
                                .get();
                            DocumentSnapshot TicketDoc = await Firestore
                                .instance
                                .collection("Coupon_ticket")
                                .document(widget.couponTicket.clientId)
                                .collection("Coupon_ticket")
                                .document(widget.couponTicket.couponTicketId)
                                .get();
                            DocumentSnapshot BusinessDoc = await Firestore
                                .instance
                                .collection("Business")
                                .document(selectedId)
                                .get();

                            Firestore.instance
                                .collection('Orders')
                                .document('Orders')
                                .collection(selectedId)
                                .document(documentId)
                                .setData({
                              "BusinessId": selectedId,
                              "ClientId": widget.couponTicket.clientId,
                              "ClientName": ClientDoc.data['Name'],
                              "CouponId": widget.couponTicket.couponId,
                              "CouponTicketId":
                                  widget.couponTicket.couponTicketId,
                              "Create_date": widget.couponTicket.purchaseDate,
                              "Discount": 0,
                              "Item": TicketDoc.data['Item'],
                              "OrderId": documentId,
                              "Original_price": widget.couponTicket.oriPrice,
                              "Price": widget.couponTicket.price,
                              "Subtotal": widget.couponTicket.price +
                                  widget.couponTicket.price *
                                      widget.couponTicket.tax,
                              "Tax": widget.couponTicket.tax,
                              "Title": TicketDoc.data['Title']
                            }).then((value) {
                              Firestore.instance
                                  .collection('Coupon_ticket')
                                  .document(widget.couponTicket.clientId)
                                  .collection("Coupon_ticket")
                                  .document(widget.couponTicket.couponTicketId)
                                  .updateData({
                                "Used_BusinessId": selectedId,
                                "Used_Business_name": [
                                  {
                                    "English": BusinessDoc.data['Business_name']
                                        ['English'],
                                    "Chinese": BusinessDoc.data['Business_name']
                                        ['Chinese']
                                  }
                                ]
                              }).then((value) =>
                                      {_qrCodeBlocBloc.add(SelfRedeemEvent())});
                            });
                          }
                        },
                      ),
                    );
                  },
                )
              : buttonsRow()
        ],
      ),
    );
  }
}

class TermItem extends StatelessWidget {
  final String title;
  final String numbs;
  const TermItem({Key key, @required this.title, @required this.numbs});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "$numbs. ",
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 14, color: Color(0xFF242424)),
          ),
          Expanded(
            child: Text(
              "$title",
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 14, color: Color(0xFF242424)),
            ),
          ),
        ],
      ),
    );
  }
}
