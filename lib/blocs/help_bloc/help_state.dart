import 'package:meta/meta.dart';

@immutable
abstract class HelpState {}

class InitialHelpState extends HelpState {
  @override
  String toString() => 'help init state';
}

class HelpUploading extends HelpState {
  @override
  String toString() => 'Help uploading';
}

class HelpUploadError extends HelpState {
  final String errorMsg;

  HelpUploadError({this.errorMsg});

  @override
  String toString() => 'help upload error';
}

class HelpUploaded extends HelpState {
  @override
  String toString() => 'Help upload success';
}
