import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infishare_client/blocs/auth_bloc/bloc.dart';
import 'package:infishare_client/language/app_localization.dart';

class OnBoardingRoute extends StatefulWidget {
  OnBoardingRoute({Key key}) : super(key: key);

  @override
  _OnBoardingRouteState createState() => _OnBoardingRouteState();
}

class _OnBoardingRouteState extends State<OnBoardingRoute>
    with TickerProviderStateMixin {
  AnimationController _colorAnimation;
  int _curIndex = 0;
  PageController _pageController;
  Animatable<Color> background;
  List<Color> _cardColors = [
    Color(0xffE0A056),
    Color(0xffF2D5A0),
    Color(0xffFFE354),
    Color(0xffffefd8),
  ];

  List<String> _images = [
    'assets/images/onboarding1.png',
    'assets/images/onboarding2.png',
    'assets/images/onboarding3.png',
    'assets/images/gift.png'
  ];

  List<String> _description = [
    'Discover exclusive deals on authentic Chinese dishes at Chicago',
    'Build your own meal combo with unlimited possibilities',
    'Redeem your purchased deals on our in-store kiosk and get same quality of service.',
    'Get up to \$10 reward when you sign up and refer friends to InfiShare',
  ];

  List<String> _descriptionCn = [
    '海量团购，供您挑选',
    '根据喜好，自定义团购内容',
    '在我们的自助点单机上兑换您的团购并享受一样的优质服务',
    '注册并分享其他好友来InfiShare消费，可以获得最高\$10奖励!'
  ];

  @override
  void initState() {
    background = TweenSequence<Color>([
      TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(
          begin: Color(0xffF5E2CC),
          end: Color(0xffFBF2E2),
        ),
      ),
      TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(
          begin: Color(0xffFBF2E2),
          end: Color(0xffFFF6CB),
        ),
      ),
      TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(
          begin: Color(0xffFFF6CB),
          end: Color(0xffffefd8),
        ),
      ),
    ]);
    _pageController = PageController();
    _colorAnimation = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 0),
    );
    super.initState();
  }

  String _getDescription(BuildContext context, int index) {
    if (AppLocalizations.of(context).locale.languageCode == 'en') {
      return _description[index];
    } else {
      return _descriptionCn[index];
    }
  }

  @override
  Widget build(BuildContext context) {
    final langcode = AppLocalizations.of(context).locale.languageCode;
    return Scaffold(
      body: AnimatedBuilder(
        animation: _pageController,
        builder: (context, child) {
          final color =
              _pageController.hasClients ? _pageController.page / 3 : .0;

          return DecoratedBox(
            decoration: BoxDecoration(
              color: background.evaluate(
                AlwaysStoppedAnimation(color),
              ),
            ),
            child: child,
          );
        },
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            PageView.builder(
              onPageChanged: (index) {
                setState(() {
                  _curIndex = index;
                });
              },
              controller: _pageController,
              itemBuilder: (context, index) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width - 108,
                        height: MediaQuery.of(context).size.width - 108,
                        child: OnBoardingImageList(
                          color: _cardColors[index],
                          image: _images[index],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 32),
                        padding: EdgeInsets.fromLTRB(48, 16, 48, 16),
                        child: Text(
                          _getDescription(context, index),
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      index == 3
                          ? BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, state) {
                                if (state is Autheticated) {
                                  return Container(
                                    margin: EdgeInsets.all(16),
                                    width:
                                        MediaQuery.of(context).size.width - 80,
                                    height: 46,
                                    child: RaisedButton(
                                      child: Text(
                                        langcode == 'en'
                                            ? 'Explore now'
                                            : '开始探索',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      color: Colors.black,
                                      elevation: 1.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(23.0),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pushReplacementNamed('/home');
                                      },
                                    ),
                                  );
                                } else {
                                  return Column(
                                    children: <Widget>[
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                80,
                                        height: 46,
                                        child: RaisedButton(
                                          child: Text(
                                            langcode == 'en'
                                                ? 'Join now'
                                                : '现在加入',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          color: Colors.black,
                                          elevation: 1.0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(23.0),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pushNamed('/auth');
                                          },
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.all(16),
                                        width:
                                            MediaQuery.of(context).size.width -
                                                80,
                                        height: 46,
                                        child: RaisedButton(
                                          child: Text(
                                            langcode == 'en'
                                                ? 'Not now'
                                                : '稍后注册',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          color: Color(0xffffefd8),
                                          elevation: 0.0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(23.0),
                                            side:
                                                BorderSide(color: Colors.grey),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pushReplacementNamed('/home');
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              },
                            )
                          : Container(),
                    ],
                  ),
                );
              },
              itemCount: _images.length,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(bottom: 32),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    PageIndicator(
                      isSelected: _curIndex == 0,
                    ),
                    PageIndicator(
                      isSelected: _curIndex == 1,
                    ),
                    PageIndicator(
                      isSelected: _curIndex == 2,
                    ),
                    PageIndicator(
                      isSelected: _curIndex == 3,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _colorAnimation.dispose();
  }
}

class OnBoardingImageList extends StatelessWidget {
  final Color color;
  final String image;

  const OnBoardingImageList({Key key, this.color, this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        RotationTransition(
          turns: AlwaysStoppedAnimation(5 / 360),
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10.0, // has the effect of softening the shadow
                  spreadRadius: 1.0, // has the effect of extending the shadow
                  offset: Offset(
                    2.0, // horizontal, move right 10
                    2.0, // vertical, move down 10
                  ),
                )
              ],
            ),
          ),
        ),
        Image.asset(
          image,
          width: 213,
          height: 213,
          fit: BoxFit.cover,
        ),
      ],
    );
  }
}

class PageIndicator extends StatelessWidget {
  final bool isSelected;

  const PageIndicator({
    Key key,
    this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8),
      height: isSelected ? 15 : 7,
      width: isSelected ? 15 : 7,
      decoration: BoxDecoration(
        color: isSelected ? Color.fromRGBO(89, 2, 2, 0.3) : Colors.transparent,
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Center(
        child: Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color:
                isSelected ? Color(0xff590202) : Color.fromRGBO(89, 2, 2, 0.3),
            borderRadius: BorderRadius.all(
              Radius.circular(7),
            ),
          ),
        ),
      ),
    );
  }
}
