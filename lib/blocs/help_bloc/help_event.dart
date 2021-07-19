import 'package:meta/meta.dart';
import 'package:infishare_client/models/models.dart';

@immutable
abstract class HelpEvent {}

class UploadHelpEvent extends HelpEvent {
  final UserHelp help;
  final String businessType;
  final String businessName;

  UploadHelpEvent({
    this.help,
    this.businessName = '',
    this.businessType = '',
  });

  @override
  String toString() =>
      'Upload user help Email: ${help.email} phone: ${help.phone} username: ${help.username} content: ${help.text} type: $businessType busine name: $businessName';
}
