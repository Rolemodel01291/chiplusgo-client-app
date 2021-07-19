import 'package:flutter/material.dart';
import 'dart:async';

class _ScaleTransitionItem extends StatelessWidget {
  final Animation<double> scaleAnimation;
  final double width;
  final double height;
  final Color color;

  const _ScaleTransitionItem(
      {@required this.scaleAnimation,
      @required this.width,
      @required this.height,
      @required this.color});
  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scaleAnimation,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: color,
        ),
      ),
    );
  }
}

class BusinessPlaceholderWidget extends StatefulWidget {
  final int durationSec; // whole animation 1 time duration
  final double beginScale; // widget scale at beginning
  final double endScale; // widget scale at ending

  const BusinessPlaceholderWidget(
      {this.durationSec = 1500, this.beginScale = 1, this.endScale = 1.1})
      : assert(durationSec > 600);
  @override
  _BusinessPlaceholderWidgetState createState() =>
      _BusinessPlaceholderWidgetState();
}

class _BusinessPlaceholderWidgetState extends State<BusinessPlaceholderWidget>
    with TickerProviderStateMixin {
  AnimationController _controller1; // image controller
  AnimationController _controller2;
  AnimationController _controller3;

  Animation<double> _imageAnimation; // iamge animation
  Animation<double> _text1Animation;
  Animation<double> _text2Animation;
  Timer t1;
  Timer t2;

  @override
  void initState() {
    _controller1 = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _controller2 = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _controller3 = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _imageAnimation =
        Tween<double>(begin: widget.beginScale, end: widget.endScale)
            .animate(_controller1);
    _text1Animation =
        Tween<double>(begin: widget.beginScale, end: widget.endScale)
            .animate(_controller2);
    _text2Animation =
        Tween<double>(begin: widget.beginScale, end: widget.endScale)
            .animate(_controller3);

    _controller1.repeat(reverse: true);
    t1 = Timer(Duration(milliseconds: 200), () => _controller2.repeat(reverse: true));
    t2 = Timer(Duration(milliseconds: 600), () => _controller3.repeat(reverse: true));

    super.initState();
  }

  @override
  dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    t1.cancel();
    t2.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = (MediaQuery.of(context).size.width - 32 - 32);
    double alpha = 0.2;
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width - 32,
        height: 364,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // iamge part
            _ScaleTransitionItem(
              scaleAnimation: _imageAnimation,
              width: width,
              height: 180,
              color: Colors.grey.withOpacity(alpha),
            ),

            // content part
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _ScaleTransitionItem(
                    scaleAnimation: _text1Animation,
                    width: width * 0.7,
                    height: 35,
                    color: Colors.grey.withOpacity(alpha),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  _ScaleTransitionItem(
                    scaleAnimation: _text2Animation,
                    width: width * 0.3,
                    height: 20,
                    color: Colors.grey.withOpacity(alpha),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  _ScaleTransitionItem(
                    scaleAnimation: _text2Animation,
                    width: width * 0.6,
                    height: 20,
                    color: Colors.grey.withOpacity(alpha),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  _ScaleTransitionItem(
                    scaleAnimation: _text2Animation,
                    width: width * 0.2,
                    height: 25,
                    color: Colors.grey.withOpacity(alpha),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Container(
                    height: 0.5,
                    color: Colors.grey.withOpacity(alpha),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  _ScaleTransitionItem(
                    scaleAnimation: _text2Animation,
                    width: width * 0.7,
                    height: 19,
                    color: Colors.grey.withOpacity(alpha),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchPlaceholderWidget extends StatefulWidget {
  final int durationSec; // whole animation 1 time duration
  final double beginScale; // widget scale at beginning
  final double endScale; // widget scale at ending
  const SearchPlaceholderWidget(
      {this.durationSec = 1500, this.beginScale = 1, this.endScale = 1.1})
      : assert(durationSec > 600);
  @override
  _SearchPlaceholderWidgetState createState() =>
      _SearchPlaceholderWidgetState();
}

class _SearchPlaceholderWidgetState extends State<SearchPlaceholderWidget>
    with TickerProviderStateMixin {
  AnimationController _controller1;
  Animation<double> _text1Animation;

  @override
  void initState() {
    _controller1 = AnimationController(
      duration: Duration(milliseconds: 700),
      vsync: this,
    );
    _text1Animation =
        Tween<double>(begin: widget.beginScale, end: widget.endScale)
            .animate(_controller1);
    _controller1.repeat(reverse: true);

    super.initState();
  }

  @override
  dispose() {
    _controller1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = (MediaQuery.of(context).size.width - 32 - 32);
    double alpha = 0.2;
    return ScaleTransition(
      scale: _text1Animation,
      child: Container(
        width: width,
        height: 32,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey.withOpacity(alpha),
        ),
      ),
    );
  }
}

class AdPlaceholderWidget extends StatefulWidget {
  final int durationSec; // whole animation 1 time duration
  final double beginScale; // widget scale at beginning
  final double endScale; // widget scale at ending
  const AdPlaceholderWidget(
      {this.durationSec = 1500, this.beginScale = 1, this.endScale = 1.1})
      : assert(durationSec > 600);
  @override
  _AdPlaceholderWidgetState createState() => _AdPlaceholderWidgetState();
}

class _AdPlaceholderWidgetState extends State<AdPlaceholderWidget>
    with TickerProviderStateMixin {
  AnimationController _controller1; // image controller
  AnimationController _controller2;
  AnimationController _controller3;

  Animation<double> _imageAnimation; // iamge animation
  Animation<double> _text1Animation;
  Animation<double> _text2Animation;
  bool _isdisposed = false;

  @override
  void initState() {
    _controller1 = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _controller2 = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _controller3 = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _imageAnimation =
        Tween<double>(begin: widget.beginScale, end: widget.endScale)
            .animate(_controller1);
    _text1Animation =
        Tween<double>(begin: widget.beginScale, end: widget.endScale)
            .animate(_controller2);
    _text2Animation =
        Tween<double>(begin: widget.beginScale, end: widget.endScale)
            .animate(_controller3);

    _controller1.repeat(reverse: true);
    Timer(Duration(milliseconds: 200), () => _controller2.repeat(reverse: true));
    Timer(Duration(milliseconds: 600), () => _controller3.repeat(reverse: true));

    super.initState();
  }

  @override
  dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = (MediaQuery.of(context).size.width - 32 - 32);
    double alpha = 0.2;
    return Center(
      child: Container(
          width: width,
          height: 200,
          child: Stack(
            children: <Widget>[
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: _ScaleTransitionItem(
                  scaleAnimation: _imageAnimation,
                  width: width,
                  height: 200,
                  color: Colors.grey.withOpacity(alpha),
                ),
              ),
              Positioned(
                left: 16,
                top: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    _ScaleTransitionItem(
                      scaleAnimation: _text1Animation,
                      width: width * 0.8,
                      height: 30,
                      color: Colors.grey.withOpacity(alpha / 2),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    _ScaleTransitionItem(
                      scaleAnimation: _text2Animation,
                      width: width * 0.6,
                      height: 25,
                      color: Colors.grey.withOpacity(alpha / 2),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}

class CouponPlaceholderWidget extends StatefulWidget {
  final int durationSec; // whole animation 1 time duration
  final double beginScale; // widget scale at beginning
  final double endScale; // widget scale at ending
  const CouponPlaceholderWidget(
      {this.durationSec = 1500, this.beginScale = 1, this.endScale = 1.1})
      : assert(durationSec > 600);
  @override
  _CouponPlaceholderWidgetState createState() =>
      _CouponPlaceholderWidgetState();
}

class _CouponPlaceholderWidgetState extends State<CouponPlaceholderWidget>
    with TickerProviderStateMixin {
  AnimationController _controller1; // image controller
  AnimationController _controller2;
  AnimationController _controller3;

  Animation<double> _imageAnimation; // iamge animation
  Animation<double> _text1Animation;
  Animation<double> _text2Animation;

  @override
  void initState() {
    _controller1 = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _controller2 = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _controller3 = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _imageAnimation =
        Tween<double>(begin: widget.beginScale, end: widget.endScale)
            .animate(_controller1);
    _text1Animation =
        Tween<double>(begin: widget.beginScale, end: widget.endScale)
            .animate(_controller2);
    _text2Animation =
        Tween<double>(begin: widget.beginScale, end: widget.endScale)
            .animate(_controller3);

    _controller1.repeat(reverse: true);
    Timer(Duration(milliseconds: 200), () => _controller2.repeat(reverse: true));
    Timer(Duration(milliseconds: 400), () => _controller3.repeat(reverse: true));

    super.initState();
  }

  @override
  dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = (MediaQuery.of(context).size.width - 32 - 32);
    double alpha = 0.2;
    return Center(
      child: Container(
          width: width,
          height: 250,
          child: Stack(
            children: <Widget>[
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: _ScaleTransitionItem(
                  scaleAnimation: _imageAnimation,
                  width: width,
                  height: 250,
                  color: Colors.grey.withOpacity(alpha),
                ),
              ),
              Positioned(
                left: 16,
                bottom: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    _ScaleTransitionItem(
                      scaleAnimation: _text1Animation,
                      width: width * 0.5,
                      height: 20,
                      color: Colors.grey.withOpacity(alpha / 2),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    _ScaleTransitionItem(
                      scaleAnimation: _text2Animation,
                      width: width * 0.4,
                      height: 15,
                      color: Colors.grey.withOpacity(alpha / 2),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    _ScaleTransitionItem(
                      scaleAnimation: _text2Animation,
                      width: width * 0.6,
                      height: 20,
                      color: Colors.grey.withOpacity(alpha / 2),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    _ScaleTransitionItem(
                      scaleAnimation: _text2Animation,
                      width: width * 0.2,
                      height: 15,
                      color: Colors.grey.withOpacity(alpha / 2),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 16,
                bottom: 16,
                child: _ScaleTransitionItem(
                  scaleAnimation: _text2Animation,
                  width: 60,
                  height: 60,
                  color: Colors.grey.withOpacity(alpha / 2),
                ),
              )
            ],
          )),
    );
  }
}
