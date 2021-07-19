import 'package:flutter/material.dart';
import 'package:infishare_client/language/app_localization.dart';

class HomeAdSection extends StatelessWidget {
  final Widget image;
  final VoidCallback onTap;
  const HomeAdSection({Key key, @required this.image, this.onTap})
      : assert(image != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      width: MediaQuery.of(context).size.width - 16,
      height: 228,
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          children: <Widget>[
            // background image
            Positioned(left: 0, right: 0, top: 0, bottom: 0, child: image),
            // learn more button
            // Positioned(
            //   right: 16,
            //   bottom: 16,
            //   child: MaterialButton(
            //     elevation: 2.0,
            //     color: Colors.black,
            //     disabledColor: Colors.grey,
            //     child: Center(
            //       child: Text(
            //         AppLocalizations.of(context).translate('LearnMore'),
            //         textAlign: TextAlign.center,
            //         overflow: TextOverflow.ellipsis,
            //         style: TextStyle(fontSize: 12, color: Colors.white),
            //       ),
            //     ),
            //     onPressed: onTap,
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
