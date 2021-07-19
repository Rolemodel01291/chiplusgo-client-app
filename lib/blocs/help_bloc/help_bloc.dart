import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:infishare_client/repo/repo.dart';
import './bloc.dart';

class HelpBloc extends Bloc<HelpEvent, HelpState> {
  final UserRepository userRepository;

  HelpBloc({this.userRepository});

  @override
  HelpState get initialState => InitialHelpState();

  @override
  Stream<HelpState> mapEventToState(
    HelpEvent event,
  ) async* {
    if (event is UploadHelpEvent) {
      yield* _mapUploadEventToState(event);
    }
  }

  Stream<HelpState> _mapUploadEventToState(UploadHelpEvent event) async* {
    try {
      if (event.businessName != '') {
        print('-------------------------------------');
        //* merchant join request
        final help = event.help;
        yield HelpUploading();
        await userRepository.uploadHelp(
          name: help.username,
          phone: help.phone,
          email: help.email,
          content: help.text +
              '\n'
                  'Business name: ${event.businessName}' +
              '\n' +
              'Business type: ${event.businessType}',
        );
        yield HelpUploaded();
      } else {
        print('---------------sdfsdf----------------------');
        //* normal user help
        final help = event.help;
        yield HelpUploading();
        await userRepository.uploadHelp(
          name: help.username,
          phone: help.phone,
          email: help.email,
          content: help.text,
        );
        print(
            '---------------Sendtdfdsfs980099999999999999999----------------------');
        yield HelpUploaded();
      }
    } catch (e) {
      yield HelpUploadError(
        errorMsg: e.toString(),
      );
    }
  }
}
