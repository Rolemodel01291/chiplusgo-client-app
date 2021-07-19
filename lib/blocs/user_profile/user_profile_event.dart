import 'dart:io';

import 'package:meta/meta.dart';

@immutable
abstract class UserProfileEvent {}

class UpdateUserProfile extends UserProfileEvent {
  final String email;
  final String userName;
  final String phoneNum;
  final String addressLine1;
  final String addressLine2;
  final String city;

  UpdateUserProfile(
      {this.email,
      this.userName,
      this.phoneNum,
      this.addressLine1,
      this.addressLine2,
      this.city});
}

class ChooseImageFormCorp extends UserProfileEvent {
  final File imageFile;

  ChooseImageFormCorp({this.imageFile});
}

class LoadUserProfile extends UserProfileEvent {
  final String imageUrl;
  final String userName;
  final String email;

  LoadUserProfile({
    this.email,
    this.imageUrl,
    this.userName,
  });
}
