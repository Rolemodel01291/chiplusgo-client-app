import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final bool inactive;
  final Function onPressed;

  CustomButton({this.text, this.inactive, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: this.inactive ? Color(0xffacacac) : Color(0xff1463a0),
      height: 50,
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.keyboard_arrow_right,
            color: Colors.transparent,
          ),

          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),

          Icon(
            Icons.keyboard_arrow_right,
            color: Colors.white,
          ),
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8)
      ),
    );
  }
}
