import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infishare_client/blocs/blocs.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:intl/intl.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'detail_widgets.dart';

class TipAndDetailSection extends StatefulWidget {
  final double tip;
  final double tax;
  final double total;
  final double inficash;
  final double subtotal;
  final double tipBase;

  TipAndDetailSection(
      {this.tip,
      this.subtotal,
      this.tax,
      this.total,
      this.inficash,
      this.tipBase});
  TipAndDetailSectionState createState() => TipAndDetailSectionState();
}

class TipAndDetailSectionState extends State<TipAndDetailSection> {
  List<double> _tipsOption = [];
  int _currentSelection = 0;
  var f = NumberFormat("#,###,##0.00", "en_US");
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.tipBase == 0) {
      _tipsOption.add(0);
      _tipsOption.add(15);
      _tipsOption.add(18);
      _tipsOption.add(20);
      _tipsOption.add(22);
    } else {
      double base = widget.tipBase;
      for (int i = 0; i < 4; i++) {
        _tipsOption.add(base);
        base = base + 3;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final CheckOutBloc checkOutBloc = BlocProvider.of<CheckOutBloc>(context);
    return Column(
      children: <Widget>[
        Container(
            padding: EdgeInsets.all(16),
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Tips",
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF242424),
                        ),
                      ),
                      Spacer(),
                      Text(
                        AppLocalizations.of(context)
                            .translate('Tips Info description'),
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFFACACAC),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: MaterialSegmentedControl(
                    children: _buildTipsOptions(),
                    selectionIndex: _currentSelection,
                    borderColor: Color(0xff242424),
                    selectedColor: Color(0xff242424),
                    unselectedColor: Colors.white,
                    borderRadius: 5.0,
                    onSegmentChosen: (index) {
                      setState(() {
                        _currentSelection = index;
                        checkOutBloc
                            .add(ChangeTips(tipsRate: _tipsOption[index]));
                      });
                    },
                  ),
                ),
              ],
            )),
        SizedBox(
          height: 16,
        ),
        Container(
          child: DetailSection(
            title: AppLocalizations.of(context).translate('Detail'),
            subTotal: widget.subtotal,
            tax: widget.tax,
            tip: widget.tip,
            inficash: widget.inficash,
            total: widget.total,
          ),
        ),
      ],
    );
  }

  Map<int, Widget> _buildTipsOptions() {
    Map<int, Widget> retVal = {};

    for (int i = 0; i < _tipsOption.length; i++) {
      retVal[i] = Column(
        children: <Widget>[
          Text('${_tipsOption[i].toStringAsFixed(0)}%'),
          Text('\$${f.format((_tipsOption[i] * widget.subtotal) / 100)}')
        ],
      );
    }

    return retVal;
  }
}
