import 'package:flutter/material.dart';
import 'package:infishare_client/models/banner.dart' as appbanner;

// back ground view, behind all widgets on home page
class HomeBackGroundView extends StatefulWidget {
  final appbanner.AppBanner appBanner;
  final ValueNotifier<double> notifier;
  final double whRatio;

  const HomeBackGroundView(
      {Key key,
      @required this.appBanner,
      @required this.notifier,
      @required this.whRatio})
      : assert(appBanner != null),
        assert(notifier != null),
        assert(whRatio != null),
        super(key: key);

  @override
  _HomeBackGroundViewState createState() => _HomeBackGroundViewState();
}

class _HomeBackGroundViewState extends State<HomeBackGroundView>
    with TickerProviderStateMixin {
  AnimationController _colorAnimationController;
  Animation _colorTween;
  @override
  void initState() {
    _colorAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));
    _colorTween = ColorTween(
      begin: Color(
        int.parse(widget.appBanner.topBanner[0].color),
      ),
      end: Color(
        int.parse(widget.appBanner.topBanner[0].color),
      ),
    ).animate(_colorAnimationController);

    super.initState();
  }

  // produce color according to image's relative position
  void changeColor(BuildContext context) {
    double offset = widget.notifier.value;
    double width = MediaQuery.of(context).size.width - 32;
    int page = (offset / width).floor();
    double remainder = offset - width * page;
    int nextPage = page + 1;
    // print("offset = $offset");
    // print("page = $page");

    if (page < 0) {
      page = 0;
      nextPage = 0;
    } else if (page > (widget.appBanner.topBanner.length - 2)) {
      page = (widget.appBanner.topBanner.length - 1);
      nextPage = (widget.appBanner.topBanner.length - 1);
    }
    _colorAnimationController.animateTo(remainder / width);
    _colorTween = ColorTween(
      begin: Color(
        int.parse(widget.appBanner.topBanner[page].color),
      ),
      end: Color(
        int.parse(widget.appBanner.topBanner[nextPage].color),
      ),
    ).animate(_colorAnimationController);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.notifier,
      builder: (BuildContext context, double value, Widget child) {
        // print("widget.notifier.value = ${widget.notifier.value}");
        changeColor(context);
        return AnimatedBuilder(
          animation: _colorAnimationController,
          builder: (context, child) => Container(
            padding: const EdgeInsets.all(0.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0, 0.18),
                end: Alignment(0, 1),
                colors: [_colorTween.value, Color(0xFFEDEDED)],
              ),
            ),
            height: (MediaQuery.of(context).size.width - 32) * widget.whRatio,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _colorAnimationController.dispose();
    super.dispose();
  }
}
