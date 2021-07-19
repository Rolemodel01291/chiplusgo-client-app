import 'dart:io';

import 'package:meta/meta.dart';

@immutable
abstract class UserProfileState {}

class InitialUserProfileState extends UserProfileState {}

class UserProfileBaseState extends UserProfileState {

  final String imageUrl;
  File imageFile;

  UserProfileBaseState([
    this.imageUrl,
    this.imageFile,
  ]);
}

class UserProfileUpdated extends UserProfileBaseState {
  UserProfileUpdated([
    String imageUrl,
    File imageFile,
  ]) : super(
          imageUrl,
          imageFile,
        );
}

class UserProfileUpdating extends UserProfileBaseState {
  UserProfileUpdating([
    String imageUrl,
    File imageFile,
  ]) : super(
          imageUrl,
          imageFile,
        );
}

class UserProfileUpdateError extends UserProfileBaseState {
  final String errorMsg;

  UserProfileUpdateError([
    this.errorMsg,
    String imageUrl,
    File imageFile,
  ]) : super(
          imageUrl,
          imageFile,
        );
}