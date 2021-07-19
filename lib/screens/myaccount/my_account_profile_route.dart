import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infishare_client/blocs/user_profile/bloc.dart';
import 'package:infishare_client/blocs/user_profile/user_profile_bloc.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:progress_dialog/progress_dialog.dart';

class MyAccountProfileRoute extends StatefulWidget {
  final String username;
  final String email;
  final String phoneNum;
  final String imageUrl;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String signupType;
  const MyAccountProfileRoute(
      {@required this.username,
      @required this.email,
      this.phoneNum,
      this.imageUrl,
      this.addressLine1,
      this.addressLine2,
      this.city,
      this.signupType});

  @override
  _MyAccountProfileRouteState createState() => _MyAccountProfileRouteState();
}

class _MyAccountProfileRouteState extends State<MyAccountProfileRoute> {
  final _formKey = GlobalKey<FormState>();
  ProgressDialog _pr;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressLine1Controller = TextEditingController();
  TextEditingController addressLine2Controller = TextEditingController();
  TextEditingController cityController = TextEditingController();

  FocusNode nameNode = FocusNode();
  FocusNode emailAddrNode = FocusNode();

  bool emailValid(String email) {
    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }

  @override
  void initState() {
    super.initState();
    _buildLoadingView();
    nameController.text = widget.username;
    emailController.text = widget.email;
    phoneController.text = widget.phoneNum;
    addressLine1Controller.text = widget.addressLine1;
    addressLine2Controller.text = widget.addressLine2;
    cityController.text = widget.city;
  }

  _buildLoadingView() {
    _pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: false);
    _pr.style(
      message: 'Loading',
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserProfileBloc, UserProfileState>(
      listener: (context, state) {
        if (state is UserProfileUpdated) {
          _pr.hide();
          Navigator.of(context).pop();
        } else if (state is UserProfileUpdating) {
          _pr.show();
        } else if (state is UserProfileUpdateError) {
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
      },
      child: GestureDetector(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.keyboard_arrow_left,
                size: 35,
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.check,
                  size: 30,
                  color: Color(0xff242424),
                ),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    BlocProvider.of<UserProfileBloc>(context).add(
                      UpdateUserProfile(
                          email: emailController.text,
                          userName: nameController.text,
                          phoneNum: phoneController.text,
                          addressLine1: addressLine1Controller.text,
                          addressLine2: addressLine2Controller.text,
                          city: cityController.text),
                    );
                  }
                },
              ),
            ],
            title: Text(
              AppLocalizations.of(context).translate('Edit Profile'),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF242424),
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 0.5,
          ),
          body: BlocBuilder<UserProfileBloc, UserProfileState>(
            builder: (context, state) {
              return Container(
                color: Color(0xFFF1F2F4),
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    padding: EdgeInsets.only(top: 32),
                    children: <Widget>[
                      // camera image and textfield row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          // camera image and icon
                          Container(
                            height: 140,
                            width: 140,
                            child: Stack(
                              children: <Widget>[
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  top: 0,
                                  bottom: 0,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(70),
                                    child: _buildAvatar(state),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    child: IconButton(
                                      icon: Icon(
                                        Entypo.getIconData("edit"),
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                      onPressed: () async {
                                        final imageFile =
                                            await ImagePicker.pickImage(
                                                source: ImageSource.gallery);
                                        if (imageFile != null) {
                                          File croppedFile =
                                              await ImageCropper.cropImage(
                                            sourcePath: imageFile.path,
                                            aspectRatioPresets:
                                                Platform.isAndroid
                                                    ? [
                                                        CropAspectRatioPreset
                                                            .square,
                                                        CropAspectRatioPreset
                                                            .original,
                                                      ]
                                                    : [
                                                        CropAspectRatioPreset
                                                            .original,
                                                        CropAspectRatioPreset
                                                            .square,
                                                      ],
                                            androidUiSettings:
                                                AndroidUiSettings(
                                                    toolbarTitle: 'Cropper',
                                                    toolbarColor: Colors.white,
                                                    toolbarWidgetColor:
                                                        Colors.black,
                                                    initAspectRatio:
                                                        CropAspectRatioPreset
                                                            .original,
                                                    lockAspectRatio: false),
                                          );
                                          BlocProvider.of<UserProfileBloc>(
                                                  context)
                                              .add(
                                            ChooseImageFormCorp(
                                              imageFile: croppedFile,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                    decoration: BoxDecoration(
                                        color: Color(0xff1463a0),
                                        borderRadius:
                                            BorderRadius.circular(70)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Name textfield
                      TextFormField(
                        controller: nameController,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        focusNode: nameNode,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(20),
                        ],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF242424),
                        ),
                        decoration: InputDecoration(
                          labelText:
                              AppLocalizations.of(context).translate("Name"),
                          labelStyle: TextStyle(
                            color: Color(0xFFACACAC),
                          ),
                          contentPadding:
                              EdgeInsets.only(left: 8, top: 0, bottom: 0),
                          errorStyle:
                              TextStyle(fontSize: 13, color: Colors.red),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Name required.';
                          }
                          return null;
                        },
                        onEditingComplete: () {
                          FocusScope.of(context).requestFocus(emailAddrNode);
                        },
                      ),

                      // Email textfield
                      TextFormField(
                        controller: emailController,
                        readOnly: widget.signupType == null ? false : true,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        focusNode: emailAddrNode,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(100),
                        ],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF242424),
                        ),
                        decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)
                                .translate("Email address"),
                            labelStyle: TextStyle(color: Color(0xFFACACAC)),
                            suffixIcon: widget.signupType == null
                                ? null
                                : Icon(Icons.lock_outline),
                            contentPadding:
                                EdgeInsets.only(left: 8, top: 14, bottom: 14),
                            errorStyle:
                                TextStyle(fontSize: 13, color: Colors.red)),
                        validator: (value) {
                          if (value.isEmpty) {
                            return AppLocalizations.of(context)
                                .translate("Email address required");
                          } else if (!emailValid(value)) {
                            return AppLocalizations.of(context)
                                .translate('Email address is invalid');
                          }
                          return null;
                        },
                      ),

                      TextFormField(
                        controller: phoneController,
                        readOnly: widget.signupType == null ? true : false,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey),
                        decoration: InputDecoration(
                          suffixIcon: widget.signupType == null
                              ? Icon(Icons.lock_outline)
                              : null,
                          labelText: AppLocalizations.of(context)
                              .translate("Phone number"),
                          labelStyle: TextStyle(color: Colors.grey),
                        ),
                      ),

                      SizedBox(height: 8),

                      TextFormField(
                        controller: addressLine1Controller,
                        textInputAction: TextInputAction.done,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF242424),
                        ),
                        decoration: InputDecoration(
                            labelText:
                                "${AppLocalizations.of(context).translate('Address Line')} 1",
                            labelStyle: TextStyle(color: Color(0xFFACACAC)),
                            contentPadding: EdgeInsets.all(0),
                            errorStyle:
                                TextStyle(fontSize: 13, color: Colors.red)),
                      ),

                      SizedBox(height: 8),

                      TextFormField(
                        controller: addressLine2Controller,
                        textInputAction: TextInputAction.done,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF242424),
                        ),
                        decoration: InputDecoration(
                            labelText:
                                "${AppLocalizations.of(context).translate('Address Line')} 2",
                            labelStyle: TextStyle(color: Color(0xFFACACAC)),
                            contentPadding: EdgeInsets.all(0),
                            errorStyle:
                                TextStyle(fontSize: 13, color: Colors.red)),
                      ),

                      SizedBox(height: 8),

                      TextFormField(
                        controller: cityController,
                        textInputAction: TextInputAction.done,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF242424),
                        ),
                        decoration: InputDecoration(
                            labelText:
                                AppLocalizations.of(context).translate("City"),
                            labelStyle: TextStyle(color: Color(0xFFACACAC)),
                            contentPadding: EdgeInsets.all(0),
                            errorStyle:
                                TextStyle(fontSize: 13, color: Colors.red)),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        onTap: () {
          // tap the wiget outside form to dismiss the keyboard
          print("tap to dismiss");
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }

  Widget _buildAvatar(UserProfileState state) {
    if (state is UserProfileBaseState) {
      if (state.imageFile != null) {
        print('------123213-----${state.imageUrl.isNotEmpty}');
        return Image.file(
          state.imageFile,
          width: 140,
          height: 140,
          fit: BoxFit.cover,
        );
      } else {
        print('-----------${state.imageUrl.isNotEmpty}');
        return state.imageUrl.isNotEmpty
            ? ExtendedImage.network(
                state.imageUrl,
                width: 140,
                height: 140,
                fit: BoxFit.cover,
                cache: true,
              )
            : Image.asset(
                'assets/images/profile.png',
                width: 140,
                height: 140,
                fit: BoxFit.cover,
              );
      }
    }
    print('-----dsdfsd------${widget.imageUrl.isNotEmpty}');
    return widget.imageUrl.isNotEmpty
        ? ExtendedImage.network(
            widget.imageUrl,
            width: 140,
            height: 140,
            fit: BoxFit.cover,
            cache: true,
          )
        : Image.asset(
            'assets/images/profile.png',
            width: 140,
            height: 140,
            fit: BoxFit.cover,
          );
  }
}
