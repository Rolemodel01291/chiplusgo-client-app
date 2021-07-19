import 'package:flutter/material.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:infishare_client/models/open_hours.dart';

class BusinessHourList extends StatelessWidget {
  final OpenHour openHour;

  BusinessHourList({this.openHour});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          AppLocalizations.of(context).translate('BusinessHour'),
          style: TextStyle(
            color: Colors.black
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16),
            child: openHour.isOpen
                ? Text(
                    AppLocalizations.of(context).translate('OpenNow'),
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromRGBO(0, 172, 92, 1),
                    ),
                  )
                : Text(
                    AppLocalizations.of(context).translate('Closed'),
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
          ),
          _buildHourItem(AppLocalizations.of(context).translate('Monday'),
              openHour.hour.mondy, DateTime.now().weekday == 1),
          _buildHourItem(AppLocalizations.of(context).translate('Tuesday'),
              openHour.hour.tuesday, DateTime.now().weekday == 2),
          _buildHourItem(AppLocalizations.of(context).translate('Wednesday'),
              openHour.hour.wednesday, DateTime.now().weekday == 3),
          _buildHourItem(AppLocalizations.of(context).translate('Thursday'),
              openHour.hour.thursday, DateTime.now().weekday == 4),
          _buildHourItem(AppLocalizations.of(context).translate('Friday'),
              openHour.hour.friday, DateTime.now().weekday == 5),
          _buildHourItem(AppLocalizations.of(context).translate('Saturday'),
              openHour.hour.saturday, DateTime.now().weekday == 6),
          _buildHourItem(AppLocalizations.of(context).translate('Sunday'),
              openHour.hour.sunday, DateTime.now().weekday == 7),
        ],
      ),
    );
  }

  Widget _buildHourItem(String title, List<String> hours, bool isToday) {
    TextStyle todayStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
    TextStyle notTodatStyle = TextStyle(
      color: Colors.grey,
    );
    final hourString = hours.join(',');

    return Container(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: isToday ? todayStyle : notTodatStyle,
            ),
          ),
          Spacer(),
          Expanded(
            flex: 2,
            child: Text(
              hourString,
              style: isToday ? todayStyle : notTodatStyle,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }
}
