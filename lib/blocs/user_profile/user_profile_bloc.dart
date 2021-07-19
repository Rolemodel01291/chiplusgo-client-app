import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:infishare_client/repo/repo.dart';
import './bloc.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final InfiShareApiClient infiShareApiClient;

  UserProfileBloc({this.infiShareApiClient});

  @override
  UserProfileState get initialState => InitialUserProfileState();

  @override
  Stream<UserProfileState> mapEventToState(
    UserProfileEvent event,
  ) async* {
    if (event is LoadUserProfile) {
      yield UserProfileBaseState(event.imageUrl);
    } else if (event is UpdateUserProfile) {
      yield* _mapUpdateUserProfileToState(event);
    } else if (event is ChooseImageFormCorp) {
      yield UserProfileBaseState(
          (state as UserProfileBaseState).imageUrl, event.imageFile);
    }
  }

  Stream<UserProfileState> _mapUpdateUserProfileToState(
      UpdateUserProfile event) async* {
    final curState = state as UserProfileBaseState;
    yield UserProfileUpdating(curState.imageUrl, curState.imageFile);
    try {
      await infiShareApiClient.changeUserInfo(
          name: event.userName,
          email: event.email,
          phoneNum: event.phoneNum,
          addressLine1: event.addressLine1,
          addressLine2: event.addressLine2,
          city: event.city);
      await infiShareApiClient.changeShowName(event.userName);
      await infiShareApiClient.createCustomer();
      if (curState.imageFile != null) {
        final url =
            await infiShareApiClient.uploadUserAvatar(curState.imageFile.path);
        yield UserProfileUpdated(url);
      } else {
        yield UserProfileUpdated(curState.imageUrl, curState.imageFile);
      }
    } catch (e) {
      print(
        e.toString(),
      );
      yield UserProfileUpdateError(
        e.toString(),
        curState.imageUrl,
        curState.imageFile,
      );
    }
  }
}
