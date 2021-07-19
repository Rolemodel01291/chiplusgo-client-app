import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infishare_client/blocs/filter_bloc/bloc.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:infishare_client/screens/businesslist/restaurants_segment_section.dart';

class TransactionFilterSection extends StatefulWidget {

  @override
  _TransactionFilterSectionState createState() => _TransactionFilterSectionState();
}

class _TransactionFilterSectionState extends State<TransactionFilterSection> {
  int timeIndex = 0;
  int typeIndex = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                    BlocProvider.of<FilterBloc>(context).add(
                      ResetFilter(),
                    );
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
                    BlocProvider.of<FilterBloc>(context).add(
                      FilterConfirmEvent(),
                    );
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
                      timeIndex =  val;
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
                      'Purchase',
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
    ));
  }
}
