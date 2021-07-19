import 'package:flutter/material.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'dart:math';
import 'package:path_drawing/path_drawing.dart';

class RedeemStampWidget extends StatelessWidget {
  final String time;
  const RedeemStampWidget({Key key, @required this.time});
  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -pi / 4,
      child: CustomPaint(
        size: Size(60, 60),
        painter: _MyPainter(_topPath(92, 40), _bottomPath(92, 40)),
        child: Container(
          width: 92,
          height: 40,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                AppLocalizations.of(context).translate('Redeemed'),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFC60404),
                ),
              ),
              Text(
                AppLocalizations.of(context).translate('ON') + " $time",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFC60404),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MyPainter extends CustomPainter {
  final Path topPath;
  final Path bottomPath;

  const _MyPainter(this.topPath, this.bottomPath);
  @override
  void paint(Canvas canvas, Size size) {
    Paint _paint = new Paint()
      ..color = Color(0xFFC60404)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 60, _paint);

    canvas.drawPath(
      dashPath(
        topPath,
        dashArray: CircularIntervalList<double>(<double>[2, 4]),
      ),
      _paint,
    );
    canvas.drawPath(
      dashPath(
        bottomPath,
        dashArray: CircularIntervalList<double>(<double>[2, 4]),
      ),
      _paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

// custom dash boarder path
Path _topPath(double width, double height) {
  Path path = Path();
  // path configure
  path.lineTo(width, 0);
  path.close();
  return path;
}

// custom dash boarder path
Path _bottomPath(double width, double height) {
  Path path = Path();
  // path configure
  path.moveTo(0, height);
  path.lineTo(width, height);
  path.close();
  return path;
}
