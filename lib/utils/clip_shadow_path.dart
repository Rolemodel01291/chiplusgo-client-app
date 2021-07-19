import 'package:flutter/material.dart';

@immutable
class ClipShadowPath extends StatelessWidget {
  final CustomClipper<Path> clipper;
  final Widget child;

  ClipShadowPath({
    @required this.clipper,
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ClipShadowShadowPainter(
        clipper: this.clipper,
      ),
      child: ClipPath(child: child, clipper: this.clipper),
    );
  }
}

class _ClipShadowShadowPainter extends CustomPainter {
  final CustomClipper<Path> clipper;

  _ClipShadowShadowPainter({@required this.clipper});

  @override
  void paint(Canvas canvas, Size size) {
    Paint borderPaint = new Paint();
      // ..color = Color(0xff242424)
      // ..style = PaintingStyle.stroke
      // ..strokeWidth = 0.5;
    var clipPath = clipper.getClip(size);
    canvas.drawShadow(clipPath, Colors.black38, 3.0, false);
    canvas.drawPath(clipPath, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
