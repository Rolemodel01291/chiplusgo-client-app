import 'package:flutter/material.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:infishare_client/models/models.dart';
import 'help_message_section.dart';
// import 'package:flutter_picker/flutter_picker.dart';

class MyCustomBusinessForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController userNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController contentController;
  final TextEditingController businessNameController;
  final Function onTypeSelected;

  final bool businssVisable;
  final User user;
  const MyCustomBusinessForm(
      {Key key,
      this.user,
      this.userNameController,
      this.emailController,
      this.phoneController,
      this.contentController,
      this.businessNameController,
      this.onTypeSelected,
      @required this.formKey,
      @required this.businssVisable})
      : assert(formKey != null),
        assert(businssVisable != null),
        super(key: key);

  @override
  _MyCustomFormState createState() {
    return _MyCustomFormState();
  }
}

class _MyCustomFormState extends State<MyCustomBusinessForm> {
  FocusNode nameNode = FocusNode();
  FocusNode emailNode = FocusNode();
  FocusNode phoneNode = FocusNode();
  FocusNode businessNode = FocusNode();
  FocusNode msgNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _buildFormBody(),
      ),
    );
  }

  List<Widget> _buildFormBody() {
    List<Widget> widgets = [
      HelpTextField(
        title: AppLocalizations.of(context).translate('Name') + "*",
        currentNode: nameNode,
        nextNode: emailNode,
        saveKey: "name",
        controller: widget.userNameController,
      ),
      HelpTextField(
        title: AppLocalizations.of(context).translate('Email') + "*",
        currentNode: emailNode,
        nextNode: phoneNode,
        saveKey: "email",
        controller: widget.emailController,
      ),
      HelpTextField(
        title: AppLocalizations.of(context).translate('Phone number') + "*",
        currentNode: phoneNode,
        nextNode: businessNode,
        saveKey: "phoneNum",
        controller: widget.phoneController,
      ),
    ];

    if (widget.businssVisable) {
      widgets.addAll([
        HelpDropdownButton(
          onSelectType: widget.onTypeSelected,
        ),
        HelpTextField(
          title: AppLocalizations.of(context).translate('Business name') + "*",
          hintString: "Your Business Name",
          currentNode: businessNode,
          nextNode: msgNode,
          saveKey: "businessName",
          controller: widget.businessNameController,
        ),
      ]);
    }

    widgets.addAll([
      SizedBox(
        height: 4,
      ),
      Padding(
        padding: const EdgeInsets.only(top: 0, bottom: 0, left: 16, right: 16),
        child: Text(
          AppLocalizations.of(context).translate("Your message") + "*",
          textAlign: TextAlign.left,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFFACACAC),
          ),
        ),
      ),
      SizedBox(
        height: 12,
      ),
      Padding(
        padding: const EdgeInsets.only(top: 0, bottom: 0, left: 16, right: 16),
        child: HelpMsgSection(
          currentNode: msgNode,
          controller: widget.contentController,
        ),
      ),
    ]);

    return widgets;
  }
}

class HelpTextField extends StatelessWidget {
  final String title;
  final FocusNode currentNode;
  final FocusNode nextNode;
  final String hintString;
  final String saveKey;
  final TextEditingController controller;
  final Function validator;

  const HelpTextField(
      {Key key,
      @required this.title,
      this.validator,
      this.controller,
      this.hintString,
      @required this.saveKey,
      @required this.currentNode,
      @required this.nextNode})
      : assert(title != null),
        assert(saveKey != null),
        assert(currentNode != null),
        assert(nextNode != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 4, bottom: 8, left: 16, right: 0),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFFACACAC),
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            // color: Colors.red,
            child: TextFormField(
              controller: controller,
              // keyboardType: TextInputType.multiline,
              focusNode: currentNode,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF242424),
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(bottom: 8),
                hintText: hintString,
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFACACAC), width: 1),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF242424), width: 1),
                ),
                hintStyle: TextStyle(
                  fontSize: 16,
                  color: Color(0xFFACACAC),
                ),
                errorStyle: TextStyle(fontSize: 13, color: Colors.red),
              ),
              validator: (val) {
                if (val.isEmpty) {
                  return 'Reqired';
                }

                return null;
              },
              onEditingComplete: () {
                print("complete $title edit");
                FocusScope.of(context).requestFocus(nextNode);
              },
            ),
          )
        ],
      ),
    );
  }
}

class HelpDropdownButton extends StatefulWidget {
  final Function onSelectType;

  const HelpDropdownButton({Key key, this.onSelectType}) : super(key: key);
  @override
  _HelpDropdownButtonState createState() => _HelpDropdownButtonState();
}

class _HelpDropdownButtonState extends State<HelpDropdownButton> {
  String dropdownValue = 'Restaurant';
  //* restaurant, beauty, bar, ticket, activity

  @override
  void initState() {
    super.initState();
    dropdownValue = 'Restaurant';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 4, bottom: 0, left: 16, right: 0),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Business Type*",
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFFACACAC),
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Container(
            padding: EdgeInsets.all(0),
            height: 30,
            decoration: BoxDecoration(
              //  color: Colors.red,
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFFACACAC),
                ),
              ),
            ),
            child: FlatButton(
              // color: Colors.red,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              padding: EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    dropdownValue,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16, color: Color(0xFF242424)),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 20,
                  ),
                  Spacer(),
                ],
              ),
              onPressed: () {
                // Picker(
                //     height: 200,
                //     itemExtent: 50,
                //     adapter: PickerDataAdapter<String>(pickerdata: [
                //       'Restaurant',
                //       'Beauty',
                //       'Bar',
                //       'Ticket',
                //       'Activity',
                //     ]),
                //     hideHeader: true,
                //     title: new Text("Select Business Type"),
                //     onConfirm: (Picker picker, List value) {
                //       setState(() {
                //         dropdownValue = picker.getSelectedValues()[0];
                //       });
                //       widget.onSelectType(dropdownValue);
                //     }).showDialog(context);
              },
            ),
          )
        ],
      ),
    );
  }
}
