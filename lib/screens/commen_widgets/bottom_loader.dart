import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class BottomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      alignment: Alignment.center,
      child: Center(
        child: SizedBox(
          height: 33,
          child: FlareActor(
            'assets/flare/dot_loading.flr',
            animation: 'wave',
            alignment: Alignment.center,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
