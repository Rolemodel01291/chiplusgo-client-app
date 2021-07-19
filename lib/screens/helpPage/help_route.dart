import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:infishare_client/blocs/blocs.dart';
import 'package:infishare_client/blocs/help_bloc/help_bloc.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:infishare_client/models/models.dart';
import 'package:infishare_client/screens/coupondetail/bottom_bar_section.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'help_form_section.dart';

//* restaurant, beauty, bar, ticket, activity
class HelpRoute extends StatefulWidget {
  final User user;
  final bool showBusiness;
  const HelpRoute({
    Key key,
    this.user,
    @required this.showBusiness,
  }) : super(key: key);
  @override
  HelpRouteState createState() => HelpRouteState();
}

class HelpRouteState extends State<HelpRoute> {
  final formKey = GlobalKey<FormState>();
  String _businessType = 'Restaurant';
  ProgressDialog _pr;

  TextEditingController _emailController;
  TextEditingController _userNameController;
  TextEditingController _phoneController;
  TextEditingController _businessNameController;
  TextEditingController _contentController;

  void pressButton() {
    // pass the validation to send message
    if (formKey.currentState.validate()) {
      BlocProvider.of<HelpBloc>(context).add(
        UploadHelpEvent(
          businessName: _businessNameController.text,
          businessType: _businessType,
          help: UserHelp(
              email: _emailController.text,
              phone: _phoneController.text,
              username: _userNameController.text,
              text: _contentController.text),
        ),
      );
    }
  }

  _buildLoadingView(BuildContext context) {
    _pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: false);
    _pr.style(
      message: 'Processing',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
          Color(0xff242424),
        ),
      ),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progress: 0.0,
      maxProgress: 100.0,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w600),
    );
  }

  void onTypeSelect(String type) {
    _businessType = type;
  }

  void _showSuccessDialog(BuildContext context) {
    final successdialog = YYDialog().build(context)
      ..barrierDismissible = false
      ..width = 200
      ..height = 200
      ..backgroundColor = Colors.black.withOpacity(0.8)
      ..borderRadius = 10.0
      ..widget(Container(
        width: 150,
        height: 150,
        child: FlareActor(
          'assets/flare/successcheck.flr',
          alignment: Alignment.center,
          fit: BoxFit.cover,
          animation: 'Untitled',
        ),
      ))
      ..widget(Padding(
        padding: EdgeInsets.only(top: 10),
        child: Text(
          "Success",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ))
      ..animatedFunc = (child, animation) {
        return FadeTransition(
          child: child,
          opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
        );
      }
      ..show();
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (successdialog.isShowing) {
        successdialog.dismiss();
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _buildLoadingView(context);
    _emailController = TextEditingController(
        text: widget.user == null ? '' : widget.user.email);
    _userNameController = TextEditingController(
        text: widget.user == null ? '' : widget.user.name);
    _phoneController = TextEditingController(
        text: widget.user == null ? '' : widget.user.phone);
    _businessNameController = TextEditingController();
    _contentController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    // overwrite the this page's material theme
    return BlocListener<HelpBloc, HelpState>(
      listener: (context, state) {
        if (state is HelpUploading) {
          _pr.show();
        }

        if (state is HelpUploadError) {
          _pr.hide().then((hide) {
            if (hide) {
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
          });
        }

        if (state is HelpUploaded) {
          _pr.hide().then((hide) {
            if (hide) {
              _showSuccessDialog(context);
            }
          });
        }
      },
      child: Theme(
        data: ThemeData(
          primaryColor: Colors.white,
          splashColor: Colors.transparent,
        ),
        child: GestureDetector(
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: Text(
                widget.showBusiness
                    ? "Join InfiShare"
                    : AppLocalizations.of(context).translate('Help'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF242424),
                ),
              ),
              backgroundColor: Colors.white,
              bottom: PreferredSize(
                preferredSize: Size(0, 0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 0.5,
                  color: Color(0xFFACACAC),
                ),
              ),
            ),
            body: ListView(
              children: <Widget>[
                Container(
                  padding:
                      EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 16),
                  width: MediaQuery.of(context).size.width,
                  color: Color(0xFFD3E2FD),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context).translate(
                          'You can send us email if you need any help. We will reply in 24 hours.'),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF266EF6),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                // pass HelpRouteState instance to each textfield
                MyCustomBusinessForm(
                  userNameController: _userNameController,
                  phoneController: _phoneController,
                  emailController: _emailController,
                  businessNameController: _businessNameController,
                  contentController: _contentController,
                  onTypeSelected: onTypeSelect,
                  user: widget.user,
                  formKey: formKey,
                  businssVisable: widget.showBusiness,
                ),
              ],
            ),
            bottomNavigationBar: BottomAppBar(
              child: CouponBottomBar(
                title: AppLocalizations.of(context).translate('Send'),
                onPress: pressButton,
              ),
            ),
          ),
          onTap: () {
            // tap the wiget outside form to dismiss the keyboard
            FocusScope.of(context).unfocus();
          },
        ),
      ),
    );
  }
}
