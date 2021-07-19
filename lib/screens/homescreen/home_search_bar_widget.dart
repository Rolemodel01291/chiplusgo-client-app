import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:infishare_client/blocs/blocs.dart';
import 'package:infishare_client/models/banner.dart' as appbanner;
import 'package:infishare_client/repo/repo.dart';
import 'package:infishare_client/screens/commen_widgets/fade_transition_route.dart';
import 'package:http/http.dart' as http;
import '../screens.dart';

// search bar widget
class HomeSearchBarWidget extends StatefulWidget {
  final String title;
  final double whRatio;
  final ValueNotifier<double> verticalNotifier;
  final ValueNotifier<double> horizonNotifier;

  const HomeSearchBarWidget(
      {Key key,
      @required this.title,
      @required this.verticalNotifier,
      @required this.horizonNotifier,
      @required this.whRatio})
      : assert(title != null),
        assert(verticalNotifier != null),
        assert(horizonNotifier != null),
        assert(whRatio != null),
        super(key: key);

  _HomeSearchBarWidgetState createState() => _HomeSearchBarWidgetState();
}

class _HomeSearchBarWidgetState extends State<HomeSearchBarWidget>
    with TickerProviderStateMixin {
  // Color containerColor;
  Color textColor;
  Color barColor;
  Color iconColor;
  Color boarderColor;
  SystemUiOverlayStyle statusBarStyle;
  AnimationController _colorAnimationController;
  double opacity;
  @override
  void initState() {
    _colorAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));
    super.initState();
  }

  // effect 1: when listview vertically scroll up,
  //           change text color, bar color, icon image, boarder color and status style animate to white,
  //           if above certain value, totally white.
  // effect 2: when listview stop horizonly scroll, bar container color keep the same as background
  void _barFeatureUpdate() {
    // double offset = widget.horizonNotifier.value;
    // int page = (offset / 351).floor();
    // double remainder = offset - 351 * page;
    // print("offset = ${widget.verticalNotifier.value}");

    double ratio = widget.verticalNotifier.value /
        ((MediaQuery.of(context).size.width - 32) * widget.whRatio + 16);
    if (ratio >= 1) {
      ratio = 1;
    } else if (ratio <= 0) {
      ratio = 0;
    }
    _colorAnimationController.animateTo(ratio);
    opacity = ratio;
    textColor = ColorTween(begin: Color(0xFFFFFFFF), end: Color(0xFF797979))
        .animate(_colorAnimationController)
        .value;
    barColor = ColorTween(begin: Colors.white30, end: Color(0xFFE5E5E5))
        .animate(_colorAnimationController)
        .value;

    // _colorTween = ColorTween(
    //         begin: Color(widget.listItems[page]["bgcolor"]), end: Colors.white)
    //     .animate(_colorAnimationController);
    // print("_colorTween.value = ${_colorTween.value}");
    if (ratio == 1) {
      iconColor = Colors.black;
      boarderColor = Colors.black45;
      statusBarStyle = SystemUiOverlayStyle.dark;
    } else {
      iconColor = Colors.white;
      boarderColor = Colors.transparent;
      statusBarStyle = SystemUiOverlayStyle.light;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: widget.horizonNotifier,
        builder: (BuildContext context, double value, Widget child) {
          return ValueListenableBuilder(
              valueListenable: widget.verticalNotifier,
              builder: (BuildContext context, double value, Widget child) {
                _barFeatureUpdate();
                return AnnotatedRegion<SystemUiOverlayStyle>(
                    value: statusBarStyle,
                    // biggest container wraps the search bar and status bar
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 64 + MediaQuery.of(context).padding.top,
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 0,
                            child: Container(
                              // padding: EdgeInsets.only(
                              //     left: 16.0,
                              //     right: 16.0,
                              //     top: MediaQuery.of(context).padding.top,
                              //     bottom: 18),
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 0.0, color: boarderColor))),
                              width: MediaQuery.of(context).size.width,
                              // 64 is the container height that below status bar
                              height: 64 + MediaQuery.of(context).padding.top,
                            ),
                          ),
                          // Mask filter
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 0,
                            child: Container(
                              color: Colors.white.withOpacity(opacity),
                              width: MediaQuery.of(context).size.width,
                              height: 64 + MediaQuery.of(context).padding.top,
                            ),
                          ),
                          Positioned(
                            left: 16,
                            right: 16,
                            top: MediaQuery.of(context).padding.top + 16,
                            child: Hero(
                              tag: 'SearchBar',
                              child: GestureDetector(
                                // search bar
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16.0),
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 16.0,
                                        right: 16.0,
                                        top: 6.0,
                                        bottom: 6.0),
                                    color: barColor,
                                    height: 32,
                                    width:
                                        MediaQuery.of(context).size.width - 32,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Icon(
                                          Icons.search,
                                          size: 20.0,
                                          color: iconColor,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Material(
                                          color: Colors.transparent,
                                          child: Text(
                                            widget.title,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 14, color: textColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  print("open search bar");
                                  Navigator.of(context).push(
                                    FadeInRoute(builder: (context) {
                                      return BlocProvider(
                                        create: (context) => SearchBloc(
                                          geolocator: Geolocator(),
                                          businessRepository:
                                              BusinessRepository(
                                            apiClient: InfiShareApiClient(
                                              httpClient: http.Client(),
                                            ),
                                          ),
                                        )..add(
                                            FetchSearchRecommed(),
                                          ),
                                        child: SearchScreen(),
                                      );
                                    }),
                                  );
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ));
              });
        });
  }

  @override
  void dispose() {
    _colorAnimationController.dispose();
    super.dispose();
  }
}
