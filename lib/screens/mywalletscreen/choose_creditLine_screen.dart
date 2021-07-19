import 'dart:math';

import 'package:flutter/material.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:intl/intl.dart';

class ChooseCreditlineScreen extends StatefulWidget {
  final double creditLineBalance;

  ChooseCreditlineScreen({this.creditLineBalance});

  @override
  _ChooseCreditlineScreenState createState() => _ChooseCreditlineScreenState();
}

class _ChooseCreditlineScreenState extends State<ChooseCreditlineScreen> {
  int _selectedRadio;
  TextEditingController _textController;

  _setSelectedRadio(int val) {
    setState(() {
      _selectedRadio = val;
    });
  }

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _selectedRadio = 3;
    // if (widget.pointsBalance == widget.maxUsage) {
    //   _selectedRadio = 1;
    // } else if (widget.pointsBalance == 0.0) {
    //   _selectedRadio = 3;
    // } else if (widget.pointsBalance < widget.maxUsage) {
    //   _selectedRadio = 2;
    // } else {
    //   _selectedRadio = 1;
    // }
  }

  @override
  Widget build(BuildContext context) {
    var f = NumberFormat("#,###,##0.00", "en_US");
    // final CheckOutBloc checkOutBloc = BlocProvider.of<CheckOutBloc>(context);
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Radio(
                  activeColor: Color(0xff1463a0),
                  value: 1,
                  groupValue: _selectedRadio,
                  onChanged: (val) {
                    setState(() {
                      _selectedRadio = val;
                    });
                    Navigator.pop(context, widget.creditLineBalance);
                  },
                ),
                RichText(
                  text: TextSpan(
                      style: TextStyle(fontSize: 14, color: Colors.black),
                      children: [
                        TextSpan(
                            text: AppLocalizations.of(context)
                                        .locale
                                        .languageCode ==
                                    'en'
                                ? "Use maximum ChiBei available "
                                : "使用最多可使用的芝呗 "),
                        TextSpan(
                            text: "\$${f.format(widget.creditLineBalance)} ",
                            style: TextStyle(
                                color: Color(0xff1463a0),
                                fontWeight: FontWeight.bold)),
                      ]),
                ),
              ],
            ),
            _selectedRadio != 2
                ? Row(
                    children: <Widget>[
                      Radio(
                        activeColor: Color(0xff1463a0),
                        value: 2,
                        groupValue: _selectedRadio,
                        onChanged: _setSelectedRadio,
                      ),
                      Text(
                        AppLocalizations.of(context)
                            .translate('Choose a specific amount'),
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  )
                : Container(
                    height: 100,
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Radio(
                              activeColor: Color(0xff1463a0),
                              value: 2,
                              groupValue: _selectedRadio,
                              onChanged: _setSelectedRadio,
                            ),
                            Text(
                              AppLocalizations.of(context)
                                  .translate('Choose a specific amount'),
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: TextField(
                                controller: _textController,
                                decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xff1463a0), width: 2.0),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xff1463a0), width: 2.0),
                                    ),
                                    prefixText: '\$',
                                    hintText: AppLocalizations.of(context)
                                                .locale
                                                .languageCode ==
                                            'en'
                                        ? 'Max \$${f.format(widget.creditLineBalance)}'
                                        : '最大额度 \$${f.format(widget.creditLineBalance)}'),
                                keyboardAppearance: Brightness.light,
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            RaisedButton(
                              textColor: Colors.white,
                              color: Color(0xff1463a0),
                              child: Text(AppLocalizations.of(context)
                                  .translate('Confirm')),
                              onPressed: () {
                                double _usage = min(
                                    double.tryParse(
                                          _textController.text,
                                        ) ??
                                        widget.creditLineBalance,
                                    widget.creditLineBalance);
                                Navigator.pop(context, _usage);
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
            Row(
              children: <Widget>[
                Radio(
                  activeColor: Color(0xff242424),
                  value: 3,
                  groupValue: _selectedRadio,
                  onChanged: (val) {
                    setState(() {
                      _selectedRadio = val;
                    });
                    // checkOutBloc.add(ChangeInfiCash(usage: 0.0));
                    Navigator.pop(context);
                  },
                ),
                Text(
                  AppLocalizations.of(context).locale.languageCode == 'en'
                      ? "Do not apply ChiBei"
                      : "不适用芝呗",
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
