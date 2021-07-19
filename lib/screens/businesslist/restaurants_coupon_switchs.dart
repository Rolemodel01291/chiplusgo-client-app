import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:infishare_client/blocs/filter_bloc/bloc.dart';
import 'package:infishare_client/language/app_localization.dart';

class BusinessSwitchColumn extends StatelessWidget {
  final List<bool> initValues;

  const BusinessSwitchColumn({this.initValues});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          BusinessCouponSwitch(
            initValue: initValues[0],
            name: AppLocalizations.of(context).translate('Coupon'),
            icon: Icon(
              Ionicons.getIconData("ios-pricetag"),
              color: initValues[0] ? Colors.red : Colors.grey,
              size: 20,
            ),
            onChange: () {
              BlocProvider.of<FilterBloc>(context).add(
                ChangeFilters(index: 0),
              );
            },
          ),
          Padding(
            padding: EdgeInsets.only(left: 29),
            child: Container(
              height: 0.5,
              color: Color(0xFFACACAC),
            ),
          ),
          BusinessCouponSwitch(
            initValue: initValues[1],
            name: AppLocalizations.of(context).translate('Voucher'),
            icon: Icon(
              MaterialCommunityIcons.getIconData("ticket"),
              color: initValues[1] ? Colors.yellow : Colors.grey,
              size: 20,
            ),
            onChange: () {
              BlocProvider.of<FilterBloc>(context).add(
                ChangeFilters(index: 1),
              );
            },
          ),
          Padding(
            padding: EdgeInsets.only(left: 29),
            child: Container(
              height: 0.5,
              color: Color(0xFFACACAC),
            ),
          ),
          BusinessCouponSwitch(
            initValue: initValues[2],
            name: AppLocalizations.of(context).translate('WiFi'),
            icon: Icon(
              Icons.wifi,
              color: initValues[2] ? Colors.green : Colors.grey,
              size: 20,
            ),
            onChange: () {
              BlocProvider.of<FilterBloc>(context).add(
                ChangeFilters(index: 2),
              );
            },
          ),
          Padding(
            padding: EdgeInsets.only(left: 29),
            child: Container(
              height: 0.5,
              color: Color(0xFFACACAC),
            ),
          ),
          BusinessCouponSwitch(
            initValue: initValues[3],
            name: AppLocalizations.of(context).translate('Parking'),
            icon: Icon(
              FontAwesome5.getIconData("parking", weight: IconWeight.Solid),
              color: initValues[3] ? Colors.blue : Colors.grey,
              size: 20,
            ),
            onChange: () {
              BlocProvider.of<FilterBloc>(context).add(
                ChangeFilters(index: 3),
              );
            },
          ),
        ],
      ),
    );
  }
}

class BusinessCouponSwitch extends StatefulWidget {
  final String name;
  final Icon icon;
  final bool initValue;
  final VoidCallback onChange;
  const BusinessCouponSwitch({
    @required this.name,
    @required this.icon,
    this.initValue,
    this.onChange,
  });

  _BusinessCouponSwitchState createState() => _BusinessCouponSwitchState();
}

class _BusinessCouponSwitchState extends State<BusinessCouponSwitch> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 16),
      height: 48,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          widget.icon,
          SizedBox(
            width: 8,
          ),
          Text(
            widget.name,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF242424),
            ),
          ),
          Spacer(),
          CupertinoSwitch(
            activeColor: Color(0xFFFCD300),
            value: widget.initValue,
            onChanged: (value) {
              widget.onChange();
            },
          )
        ],
      ),
    );
  }
}
