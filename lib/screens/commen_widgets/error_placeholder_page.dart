import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infishare_client/language/app_localization.dart';

class ErrorPlaceHolder extends StatelessWidget {
  final String description;
  final String imageName;
  final VoidCallback onTap;

  ErrorPlaceHolder(this.description,
      {this.imageName = 'assets/svg/error.svg', this.onTap});

  @override
  Widget build(BuildContext context) {
    final Widget svgImage = new SvgPicture.asset(
      imageName,
      width: 150,
      height: 150,
    );

    List<Widget> widgets = [
      svgImage,
      Text(
        description,
        style: TextStyle(fontSize: 18, color: Color(0xffacacac)),
        textAlign: TextAlign.center,
      )
    ];
    if (onTap != null) {
      widgets.add(FlatButton.icon(
        //shape: ,
        icon: Icon(Icons.refresh),
        label: Text(
          AppLocalizations.of(context).translate('Retry'),
          style: TextStyle(fontSize: 16),
        ),
        onPressed: onTap,
      ));
    }

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widgets,
          ),
        ),
      ),
    );
  }
}
