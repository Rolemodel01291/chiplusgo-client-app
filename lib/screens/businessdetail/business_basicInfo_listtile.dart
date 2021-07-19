import 'package:flutter/material.dart';
import 'package:infishare_client/blocs/wifi_bloc.dart';
import 'package:infishare_client/language/app_localization.dart';

class BusinessInfoTile extends StatelessWidget {
  final String content;
  final IconData iconData;
  final VoidCallback onTap;

  BusinessInfoTile({this.content, this.iconData, this.onTap})
      : assert(iconData != null, content != null);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(
                iconData,
                size: 24,
                color: Colors.black,
              ),
            ),
            Expanded(
              child: Text(
                content,
                style: TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Icon(
                Icons.chevron_right,
                color: Color.fromRGBO(172, 172, 172, 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BusinessHourListTile extends StatelessWidget {
  final bool isOpenNow;
  final VoidCallback onTap;

  BusinessHourListTile({this.isOpenNow, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(
                Icons.calendar_today,
                size: 24,
                color: Colors.black,
              ),
            ),
            Expanded(
              child: isOpenNow
                  ? Text(
                      AppLocalizations.of(context).translate('OpenNow'),
                      style: TextStyle(
                          fontSize: 16, color: Color.fromRGBO(0, 172, 92, 1)),
                    )
                  : Text(
                      AppLocalizations.of(context).translate('Closed'),
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Icon(
                Icons.chevron_right,
                color: Color.fromRGBO(172, 172, 172, 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BusinessWifiInfoTile extends StatefulWidget {
  final VoidCallback onTap;
  final String wifiSsid;
  final WifiState status;

  BusinessWifiInfoTile({this.onTap, this.wifiSsid, this.status});

  @override
  State<StatefulWidget> createState() {
    return _BusinessWifiInfoState();
  }
}

class _BusinessWifiInfoState extends State<BusinessWifiInfoTile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(
              Icons.wifi,
              size: 24,
              color: Colors.black,
            ),
          ),
          Expanded(
            child: Text(
              widget.wifiSsid != ''
                  ? widget.wifiSsid
                  : 'Wi-Fi service unavaiable',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Container(
              height: 30,
              child: widget.wifiSsid != '' ? _buildConnectBtn() : Container(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectBtn() {
    if (widget.status is WifiConnected || widget.status is WifiDisconnect) {
      return FlatButton(
        color: Color(0xFFFCD300),
        child: Text(
          widget.status is WifiConnected ? 'DISCONNECT' : 'CONNECT',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        onPressed: widget.onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      );
    } else {
      return FlatButton(
        color: Color(0xFFFCD300),
        child: SizedBox(
          width: 25,
          height: 25,
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              strokeWidth: 2.0,
            ),
          ),
        ),
        onPressed: widget.onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      );
    }
  }
}
