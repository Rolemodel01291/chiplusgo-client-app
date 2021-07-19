import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infishare_client/blocs/language_bloc/bloc.dart';
import 'package:infishare_client/language/app_localization.dart';

class LangSection extends StatefulWidget {
  final List<String> titles;
  final List<String> langCodes;
  const LangSection({
    Key key,
    @required this.titles,
    this.langCodes,
  });

  @override
  LangSectionState createState() => LangSectionState();
}

class LangSectionState extends State<LangSection> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 16, top: 0),
              child: Text(
                AppLocalizations.of(context).translate('Language'),
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF242424),
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 96,
              color: Colors.white,
              child: ListView.separated(
                padding: EdgeInsets.only(left: 16),
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.titles.length,
                itemBuilder: (BuildContext context, int index) {
                  return _SelectableLang(
                    currentLang:
                        (state as LanguageSettingLoaded).language.languageCode,
                    title: widget.titles[index],
                    langCode: widget.langCodes[index],
                  );
                },
                separatorBuilder: (BuildContext context, int index) => Padding(
                  padding: EdgeInsets.only(left: 34),
                  child: Divider(
                    height: 0,
                    thickness: 0.5,
                    color: Color(0xFFACACAC),
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}

// selectable language item
class _SelectableLang extends StatefulWidget {
  final String title;
  final String currentLang;
  final String langCode;
  const _SelectableLang(
      {Key key, @required this.title, this.currentLang, this.langCode})
      : super(key: key);
  @override
  _SelectableLangState createState() => _SelectableLangState();
}

class _SelectableLangState extends State<_SelectableLang> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.only(left: 0, right: 16),
        width: MediaQuery.of(context).size.width,
        height: 48,
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image.asset(
              widget.title == "简体中文" ? 'assets/images/chinese.png' : 'assets/images/English(US).png',
              width: 24.0,
              height: 24.0,
              fit: BoxFit.cover,
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: Text(
                widget.title,
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Opacity(
              opacity: widget.currentLang == widget.langCode ? 1 : 0,
              child: Icon(
                Icons.check,
                size: 24,
                color: Colors.green,
              ),
            )
          ],
        ),
      ),
      onTap: () {
        BlocProvider.of<LanguageBloc>(context).add(
          ChangeLanguage(
            langCode: widget.langCode,
            countryCode: widget.langCode == 'en' ? 'US' : 'Hans',
          ),
        );
      },
    );
  }
}
