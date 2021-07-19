import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:infishare_client/language/app_localization.dart';

// if due later than 1 day, then show Hour, Minute and Second;
// otherwise show Day, Hour and Minute
class TimerSection extends StatefulWidget {
  final double balance;
  final String percertage;
  final String startDate;
  final String endDate;
  final DateTime due;
  final bool isSpecial;
  const TimerSection(
      {Key key,
      @required this.isSpecial,
      @required this.percertage,
      @required this.due,
      @required this.balance,
      @required this.startDate,
      @required this.endDate})
      : assert(percertage != null);
  @override
  TimerSectionState createState() => TimerSectionState();
}

class TimerSectionState extends State<TimerSection> {
  String restTimeText;
  Timer timeController;

  String restTime(DateTime due) {
    DateTime today = new DateTime.now();
    Duration duration = due.difference(today);
    int durationSec = duration.inSeconds;
    // print(durationSec);
    int restDay = durationSec ~/ (3600 * 24);
    int restHour = (durationSec % (3600 * 24)) ~/ 3600;
    int restMin = (durationSec % (3600 * 24) % 3600) ~/ 60;
    int restSec = durationSec % (3600 * 24) % 3600 % 60;
    if (restDay != 0) {
      return "${restDay}D : ${restHour}H : ${restMin}M";
    } else {
      return "${restHour}H : ${restMin}M : ${restSec}s";
    }
  }

  @override
  void initState() {
    DateTime today = new DateTime.now();
    if (today.isAfter(widget.due)) {
      restTimeText = "";
    } else {
      restTimeText = restTime(widget.due);
    }
    timeController = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (today.isAfter(widget.due)) {
          restTimeText = "";
        } else {
          restTimeText = restTime(widget.due);
        }
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Visibility(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(16),
            color: Color(0xFF266EF6),
            // clock cloumn
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.timer,
                      size: 21,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      AppLocalizations.of(context).locale.languageCode == 'en'
                          ? "LIMITED PERIOD OFFER"
                          : "限时折扣",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    )
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text:
                            AppLocalizations.of(context).locale.languageCode ==
                                    'en'
                                ? 'Recharge now and get up to '
                                : "即刻充值就享高达",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: widget.percertage,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: AppLocalizations.of(context)
                                    .locale
                                    .languageCode ==
                                'en'
                            ? ' bonus! Event is only valid from ${widget.startDate} to ${widget.endDate}. \nExpires in:'
                            : '返现。 活动时间${widget.startDate} 到 ${widget.endDate}. \n截止倒计时：',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Center(
                  child: Text(
                    restTimeText,
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                )
              ],
            ),
          ),
          visible: widget.isSpecial,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  AppLocalizations.of(context).translate('InficashBalance'),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF242424),
                  ),
                ),
              ),
              Text(
                "\$${widget.balance}",
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF81B72F),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    timeController.cancel();
    super.dispose();
  }
}
