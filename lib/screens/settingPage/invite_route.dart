import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
// import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class InviteRoute extends StatefulWidget {
  final String referealCode;
  final String userName;

  const InviteRoute({this.referealCode, this.userName});
  InviteRouteState createState() => InviteRouteState();
}

class InviteRouteState extends State<InviteRoute> {
  String _inform = '';
  String _copyInform = '';
  Color informColor;

  String _content = '';
  bool _copied = false;

  Widget shareButton(Icon icon, String title, VoidCallback onTap) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(0),
        width: 60,
        //height: 54,
        // color: Colors.red,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            icon,
            SizedBox(
              height: 4,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFFACACAC),
              ),
            ),
          ],
        ),
      ),
      onTap: onTap,
    );
  }

  Widget shareMethodSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        shareButton(
          Icon(
            AntDesign.getIconData('wechat'),
            size: 32,
            color: Color(0xff2424243),
          ),
          AppLocalizations.of(context).translate('Wechat'),
          () {
            // Share.share(_content);
          },
        ),
        SizedBox(
          width: 33,
        ),
        shareButton(
          Icon(
            MaterialIcons.getIconData('email'),
            size: 32,
            color: Color(0xff2424243),
          ),
          AppLocalizations.of(context).translate('Email'),
          () async {
            String url =
                'mailto:infishare@example.com?subject=Try%20InfiShare!&body=${Uri.encodeFull(_content)}';
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              print('Could not launch $url');
            }
          },
        ),
        SizedBox(
          width: 33,
        ),
        shareButton(
          Icon(
            MaterialIcons.getIconData('message'),
            size: 32,
            color: Color(0xff2424243),
          ),
          AppLocalizations.of(context).translate("Message"),
          () async {
            _sendSMS(_content, []);
          },
        ),
      ],
    );
  }

  void _sendSMS(String message, List<String> recipents) async {
    String _result =
        await FlutterSms.sendSMS(message: message, recipients: recipents)
            .catchError((onError) {
      print(onError);
    });
    print(_result);
  }

  @override
  void initState() {
    informColor = Color(0xFFACACAC);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //TODO: add ios link and android link in here
    _content = AppLocalizations.of(context).translate('Hi,') +
        widget.userName +
        AppLocalizations.of(context).translate(
            'has had a great experience discovering and experiencing ethnic food on InfiShare. Click on the following link to download the app and use code ') +
        'https://www.infishareapp.com/' + ', Code:'+
        widget.referealCode +
        AppLocalizations.of(context)
            .translate('to enjoy \$5 off your first transaction with us.');
    _inform = AppLocalizations.of(context)
        .translate('Click to copy your referal code');
    _copyInform = AppLocalizations.of(context).translate('Copied to clipboard');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          AppLocalizations.of(context).translate("Invite Friends"),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF242424),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 16),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SvgPicture.asset(
                'assets/svg/invite.svg',
                width: 120.0,
                height: 120.0,
                fit: BoxFit.cover,
              ),
              Text(
                AppLocalizations.of(context).translate("Your Referal Code"),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF242424),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              CustomPaint(
                painter: _DashedBoarderPainter(
                  _buildRectangularDashPath(130, 50),
                ),
                child: GestureDetector(
                  child: Container(
                      color: Colors.transparent,
                      width: 130,
                      height: 50,
                      child: Center(
                        child: Text(
                          widget.referealCode,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF242424),
                          ),
                        ),
                      )),
                  onTap: () {
                    Clipboard.setData(
                      new ClipboardData(text: widget.referealCode),
                    );
                    if (!_copied) {
                      setState(() {
                        _copied = true;
                        informColor = Color(0xFF35B535);
                      });
                    }
                  },
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                _copied ? _copyInform : _inform,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14, color: informColor),
              ),
              SizedBox(
                height: 24,
              ),
              Padding(
                padding: EdgeInsets.only(left: 24, right: 24),
                child: Text(
                  AppLocalizations.of(context).translate('Referal Desciption'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF242424),
                  ),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              shareMethodSection()
            ],
          ),
        ),
      ),
    );
  }
}

class _DashedBoarderPainter extends CustomPainter {
  final Path path;
  const _DashedBoarderPainter(this.path);
  @override
  void paint(Canvas canvas, Size size) {
    Paint boarderPaint = new Paint()
      ..color = Color(0xFF707070)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawPath(
      dashPath(
        path,
        dashArray: CircularIntervalList<double>(<double>[2.0, 2.0]),
      ),
      boarderPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

// custom dash boarder path
Path _buildRectangularDashPath(double width, double height) {
  Path path = Path();
  // path configure
  path.lineTo(width, 0);
  path.lineTo(width, height);
  path.lineTo(0, height);
  path.lineTo(0, 0);
  path.close();
  return path;
}
