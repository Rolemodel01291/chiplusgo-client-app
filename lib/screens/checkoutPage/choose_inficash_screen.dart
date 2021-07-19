import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infishare_client/blocs/blocs.dart';
import 'package:infishare_client/language/app_localization.dart';

class ChooseInfiCashScreen extends StatefulWidget {
  final double inficash;
  final double maxUsage;

  ChooseInfiCashScreen({this.inficash, this.maxUsage});

  @override
  _ChooseInfiCashScreenState createState() => _ChooseInfiCashScreenState();
}

class _ChooseInfiCashScreenState extends State<ChooseInfiCashScreen> {
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
    if (widget.inficash == widget.maxUsage) {
      _selectedRadio = 1;
    } else if (widget.inficash == 0.0) {
      _selectedRadio = 3;
    } else if (widget.inficash < widget.maxUsage) {
      _selectedRadio = 2;
    } else {
      _selectedRadio = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final CheckOutBloc checkOutBloc = BlocProvider.of<CheckOutBloc>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      //resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'InfiCash',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.black,
            size: 24,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Radio(
                    activeColor: Color(0xff242424),
                    value: 1,
                    groupValue: _selectedRadio,
                    onChanged: (val) {
                      setState(() {
                        _selectedRadio = val;
                      });
                      checkOutBloc.add(ChangeInfiCash(usage: -1.0));
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    AppLocalizations.of(context)
                        .translate('Use maximum InfiCash available'),
                    style: TextStyle(fontSize: 16),
                  ),
                  Spacer(),
                  Text(
                    '\$${widget.maxUsage.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 16, color: Color(0xff00AC5C)),
                  ),
                ],
              ),
              _selectedRadio != 2
                  ? Row(
                      children: <Widget>[
                        Radio(
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
                    )
                  : Container(
                      height: 100,
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Radio(
                                activeColor: Color(0xff242424),
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
                                            color: Color(0xff242424),
                                            width: 2.0),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xff242424),
                                            width: 2.0),
                                      ),
                                      prefixText: '\$',
                                      hintText:
                                          'Max \$${widget.maxUsage.toStringAsFixed(2)}'),
                                  keyboardAppearance: Brightness.light,
                                  keyboardType:
                                      TextInputType.numberWithOptions(),
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              RaisedButton(
                                textColor: Colors.white,
                                color: Color(0xff242424),
                                child: Text(AppLocalizations.of(context)
                                    .translate('Confirm')),
                                onPressed: () {
                                  double _usage = min(
                                      double.tryParse(
                                            _textController.text,
                                          ) ??
                                          widget.maxUsage,
                                      widget.maxUsage);
                                  checkOutBloc
                                      .add(ChangeInfiCash(usage: _usage));
                                  Navigator.pop(context);
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
                      checkOutBloc.add(ChangeInfiCash(usage: 0.0));
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    AppLocalizations.of(context)
                        .translate('Do not apply InfiCash'),
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
