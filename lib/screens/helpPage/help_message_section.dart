import 'package:flutter/material.dart';
import 'package:infishare_client/language/app_localization.dart';

class HelpMsgSection extends StatefulWidget {
  final FocusNode currentNode;
  final TextEditingController controller;

  const HelpMsgSection({Key key, @required this.currentNode, this.controller})
      : assert(currentNode != null),
        super(key: key);

  @override
  HelpMsgSectionState createState() {
    return HelpMsgSectionState();
  }
}

class HelpMsgSectionState extends State<HelpMsgSection> {
  Color textColor;

  @override
  void initState() {
    textColor = Colors.transparent;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
          height: 153,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              style: BorderStyle.solid,
              width: 1,
              color: Color(0xFFACACAC),
            ),
          ),
          child: TextFormField(
            // autofocus: true,
            controller: widget.controller,
            focusNode: widget.currentNode,
            textInputAction: TextInputAction.done,
            maxLines: 6,
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Color(0xFF242424),
            ),
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(0), border: InputBorder.none),

            validator: (value) {
              setState(() {
                textColor = (value.isEmpty) ? Colors.red : Colors.transparent;
              });

              if (value.isEmpty) {
                return "";
              }
              return null;
            },
            onSaved: (String value) {},
          ),
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          AppLocalizations.of(context).translate("Required"),
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 13, color: textColor),
        ),
      ],
    );
  }
}
