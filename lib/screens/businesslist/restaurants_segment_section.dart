import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BusinessSegmentSection extends StatefulWidget {
  final Function onValueChange;
  final int seletedIndex;
  final Map<int, Widget> logoWidgets;
  const BusinessSegmentSection({
    this.seletedIndex,
    this.onValueChange,
    this.logoWidgets,
  });
  @override
  _BusinessSegmentSectionState createState() =>
      _BusinessSegmentSectionState();
}

class _BusinessSegmentSectionState extends State<BusinessSegmentSection> {

  _BusinessSegmentSectionState();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.seletedIndex);
    return Container(
      width: MediaQuery.of(context).size.width,
      child: CupertinoSegmentedControl(
        selectedColor: Color(0xFF1463a0),
        unselectedColor: Colors.white,
        borderColor: Color(0xFF1463a0),
        children: widget.logoWidgets,
        onValueChanged: widget.onValueChange,
        groupValue: widget.seletedIndex,
      ),
    );
  }
}
