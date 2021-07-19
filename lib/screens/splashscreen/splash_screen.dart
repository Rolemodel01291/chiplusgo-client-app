import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infishare_client/blocs/blocs.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:open_appstore/open_appstore.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state is VersionChecked) {
          if (state.notNew) {
            Future.delayed(Duration(milliseconds: 1000)).then((v) {
              Navigator.of(context).pushReplacementNamed('/home');
            });
          } else {
            Future.delayed(Duration(milliseconds: 1000)).then((v) {
              Navigator.of(context).pushReplacementNamed('/home');
            });
          }
        } else if (state is NeedUpdateState) {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(16.0),
                  ),
                ),
                title: Text('Oops..'),
                content: Text(
                  AppLocalizations.of(context).translate(
                      'Update required to continue using the InfiShare app.'),
                ),
                actions: <Widget>[
                  FlatButton(
                    child:
                        Text(AppLocalizations.of(context).translate('Update')),
                    onPressed: () {
                      OpenAppstore.launch(
                        iOSAppId: '1447754117',
                        androidAppId: 'com.infinet.infishare_client&hl=en_US',
                      );
                    },
                  )
                ],
              );
            },
          );
        } else if (state is VersionCheckError) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(16.0),
                  ),
                ),
                title: Text('Oops..'),
                content: Text(state.errorMsg),
                actions: <Widget>[
                  FlatButton(
                    child: Text(
                      AppLocalizations.of(context).translate('OK'),
                    ),
                    onPressed: () {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      }
                    },
                  )
                ],
              );
            },
          );
        }
      },
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.white),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 64),
                        child: Image.asset(
                          'assets/images/ChiGo.png',
                          fit: BoxFit.cover,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(
                      backgroundColor: Color(0xff1463a0),
                      strokeWidth: 4.0,
                      valueColor: AlwaysStoppedAnimation(Color(0xffdddddd)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    Text(
                      AppLocalizations.of(context).translate('Loading...'),
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0,
                          color: Color(0xff1463a0)),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    ));
  }
}
