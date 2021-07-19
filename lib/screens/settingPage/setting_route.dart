import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infishare_client/blocs/auth_bloc/bloc.dart';
import 'package:infishare_client/blocs/blocs.dart';
import 'package:infishare_client/blocs/setting_bloc/bloc.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:infishare_client/repo/utils/setting_consts.dart';
import 'setting_lang_section.dart' as slSection;
import 'setting_about_section.dart' as sbSection;

class SettingRoute extends StatefulWidget {
  const SettingRoute({Key key});
  @override
  SettingRouteState createState() => SettingRouteState();
}

class SettingRouteState extends State<SettingRoute> {
  @override
  Widget build(BuildContext context) {
    // overwrite the this page's material theme
    return BlocBuilder<SettingBloc, SettingState>(
      builder: (context, state) {
        return Theme(
          data: ThemeData(
            primaryColor: Colors.white,
            splashColor: Colors.transparent,
          ),
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: Text(
                AppLocalizations.of(context).translate('Settings'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF242424),
                ),
              ),
              backgroundColor: Colors.white,
            ),
            body: ListView(
              children: <Widget>[
                SizedBox(
                  height: 16,
                ),
                slSection.LangSection(
                  titles: ["简体中文", "English(US)"],
                  langCodes: SettingConstants.supportedLanguage,
                ),
                SizedBox(
                  height: 32,
                ),
                sbSection.AboutSection(
                  buildNum: state is AppVersionLoaded ? state.buildNum : '',
                  versionNum: state is AppVersionLoaded ? state.versionNum : '',
                ),
                SizedBox(
                  height: 32,
                ),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is Autheticated) {
                      return LougoutButton();
                    } else {
                      return Container();
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class LougoutButton extends StatefulWidget {
  const LougoutButton();
  LougoutButtonState createState() => LougoutButtonState();
}

class LougoutButtonState extends State<LougoutButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 48,
      child: FlatButton(
        color: Colors.white,
        textColor: Color(0xFFC60404),
        disabledColor: Colors.grey,
        disabledTextColor: Colors.black,
        focusColor: Colors.white,
        padding: EdgeInsets.all(8.0),
        splashColor: Color(0x55C60404),
        onHighlightChanged: (value) {},
        onPressed: () {
          BlocProvider.of<AuthBloc>(context).add(
            SignOut(),
          );
          Navigator.of(context).pop();
        },
        child: Text(
          AppLocalizations.of(context).translate('Logout'),
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
