import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:infishare_client/repo/user_repo.dart';
import './bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository userRepository;
  StreamSubscription<DocumentSnapshot> _userSubscription;
  String _verifyID = '';
  final FacebookLogin facebookLogin = FacebookLogin();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthBloc({@required this.userRepository});

  @override
  AuthState get initialState => Uninitialized();

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AuthGoogleEvent) {
      yield* _mapSignupFromGoogleToState(event);
      //   try {
      //     await userRepository.client.uploadCloudMsgToken();
      //     yield Autheticated();
      //   } catch (e) {
      //     yield AuthError(
      //       errorMsg: e.toString(),
      //     );
      //   }
    } else if (event is AuthFacebookEvent) {
      print("Sing 1");
      yield* _mapSignupFromFacebookToState(event);
      /*try {
          await userRepository.client.uploadCloudMsgToken();
          yield Autheticated();
          event.onSuccess();
        } catch (e) {
          yield AuthError(
            errorMsg: e.toString(),
          );
        }*/
    } else if (event is SendCodeEvent) {
      yield* _mapSendCodeEventToState(event);
    } else if (event is VerifySmscode) {
      yield* _mapVerifySmscodeToState(event);
    } else if (event is SignUpNewUser) {
      yield* _mapSignupNewUserToState(event);
    } else if (event is SignUpNewUserFromGoogle) {
      yield* _mapSignupNewUserFromGoogleToState(event);
    } else if (event is AppStart) {
      yield* _mapAppStartEventToState(event);
    } else if (event is SignOut) {
      yield* _mapSignOutEvnetToState(event);
    } else if (event is AuthInternalErrorEvent) {
      yield AuthError(errorMsg: event.errorMsg);
    } else if (event is AuthInternalPhoneVerified) {
      yield PhoneVerified(verificationId: event.verficationId);
    } else if (event is AuthInternalSucEvent) {
      try {
        await userRepository.client.uploadCloudMsgToken();
        yield Autheticated();
      } catch (e) {
        yield AuthError(
          errorMsg: e.toString(),
        );
      }
    } else if (event is InternalSmsCodeVerified) {
      yield SmsCodeVerified();
    } else if (event is InternalGmailVerified) {
      yield GmailVerified(email: event.email);
    } else if (event is InternalFacebookVerified) {
      yield FacebookVerified(email: event.email);
    }
  }

  Stream<AuthState> _mapSignOutEvnetToState(SignOut event) async* {
    try {
      await userRepository.signOut();
      yield UnAutheticated();
    } catch (_) {
      yield UnAutheticated();
    }
  }

  Stream<AuthState> _mapAppStartEventToState(AppStart event) async* {
    try {
      final firebaseuser = await userRepository.getCurrentUser();
      if (firebaseuser != null) {
        print('${firebaseuser.phoneNumber}');
        final user = await userRepository.fetchUserInfo(firebaseuser.uid);
        if (user.email == '') {
          //* email is empty so this user close app before the update email process
          //* logout
          await userRepository.signOut();
          yield UnAutheticated();
        } else {
          yield Autheticated();
        }
      } else {
        yield UnAutheticated();
      }
    } catch (_) {
      yield UnAutheticated();
    }
  }

  Stream<AuthState> _mapSendCodeEventToState(SendCodeEvent event) async* {
    yield AuthLoading();
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential authCredential) async {
      try {
        print('verificationCompleted');
        _userSubscription?.cancel();
        Function onData = (DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.data != null &&
              documentSnapshot.data['Email'] != null) {
            _userSubscription?.cancel();
            print(documentSnapshot.data['Email']);
            if (documentSnapshot.data['Email'] == '') {
              //* document created and user don't have email yet
              //* So this is a new user
              //* next step should be update user email and create customer in stripe
              add(
                InternalSmsCodeVerified(),
              );
            } else {
              //* user already have email so login process complete
              add(
                AuthInternalSucEvent(),
              );
            }
          }
        };
        print('====================error');
        try {
          final authResult =
              await userRepository.signInWithCredential(authCredential);
          final user = authResult.user;
          _userSubscription =
              userRepository.getRealTimeUser(user.uid).listen(onData);
        } catch (e) {
          await userRepository.signOut();
          print('------------------------------------$e');
          add(
            AuthInternalErrorEvent(
              errorMsg: e.toString(),
            ),
          );
        }
      } on Exception catch (e) {
        print('--------------------Error----------------$e');
        add(
          AuthInternalErrorEvent(
            errorMsg: e.toString(),
          ),
        );
      }
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      add(AuthInternalErrorEvent(errorMsg: authException.message));
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) {
      _verifyID = verificationId;
      add(AuthInternalPhoneVerified(verficationId: verificationId));
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verifyID = verificationId;
      // if (!(state is Autheticated)) {
      //   add(AuthInternalPhoneVerified(verficationId: verificationId));
      // }
    };
    try {
      await userRepository.verifyPhone(
          phoneNum: event.phoneNum,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          timeout: codeAutoRetrievalTimeout);
    } catch (e) {
      yield AuthError(errorMsg: e.toString());
    }
  }

  Stream<AuthState> _mapVerifySmscodeToState(VerifySmscode event) async* {
    yield AuthLoading();
    _userSubscription?.cancel();
    Function onData = (DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.data != null &&
          documentSnapshot.data['Email'] != null) {
        _userSubscription?.cancel();
        print(documentSnapshot.data['Email']);
        if (documentSnapshot.data['Email'] == '') {
          //* document created and user don't have email yet
          //* So this is a new user
          //* next step should be update user email and create customer in stripe
          add(InternalSmsCodeVerified());
        } else {
          //* user already have email so login process complete
          add(AuthInternalSucEvent());
        }
      }
    };
    try {
      final authResult = await userRepository.signInWithPhone(
          smsCode: event.smsCode, verifyCode: _verifyID);
      final user = authResult.user;
      print('=============================$user');
      _userSubscription =
          userRepository.getRealTimeUser(user.uid).listen(onData);
    } catch (e) {
      await userRepository.signOut();
      yield AuthError(errorMsg: e.toString());
    }
  }

  Stream<AuthState> _mapSignupNewUserToState(SignUpNewUser event) async* {
    yield AuthLoading();
    try {
      await userRepository.updateUserInfo(event.name, event.email);
      await userRepository.createCustomer();
      await userRepository.client.uploadCloudMsgToken();
      yield Autheticated();
    } on Exception catch (e) {
      await userRepository.signOut();
      yield AuthError(
        errorMsg: e.toString(),
      );
    }
  }

  Stream<AuthState> _mapSignupNewUserFromGoogleToState(
      SignUpNewUserFromGoogle event) async* {
    yield AuthLoading();
    try {
      await userRepository.updateGoogleUserInfo(
          event.name, event.phone, event.email);
      await userRepository.setGoogleSignupType();
      await userRepository.createCustomer();
      await userRepository.client.uploadCloudMsgToken();
      yield Autheticated();
    } on Exception catch (e) {
      await userRepository.signOut();
      yield AuthError(
        errorMsg: e.toString(),
      );
    }
  }

  Stream<AuthState> _mapSignupFromGoogleToState(AuthGoogleEvent event) async* {
    yield AuthLoading();
    _userSubscription?.cancel();
    Function onData = (DocumentSnapshot documentSnapshot, String email) {
      if (documentSnapshot.data != null &&
          documentSnapshot.data['Phone'] != null) {
        _userSubscription?.cancel();
        print(documentSnapshot.data['Phone']);
        if (documentSnapshot.data['Phone'] == "") {
          //* document created and user don't have email yet
          //* So this is a new user
          // add(SignUpNewUserFromGoogle());
          add(InternalGmailVerified(email: email));
        } else {
          //* user already have email so login process complete
          add(AuthInternalSucEvent());
        }
      }
    };
    String email = "";
    try {
      final authResult = await userRepository.signInWithGoogle();
      final user = authResult.user;

      user.providerData
          .map((item) => {
                if (item.email != null) {email = item.email}
              })
          .toList();
      _userSubscription =
          userRepository.getRealTimeUser(user.uid).listen((snapshot) {
        onData(snapshot, email);
      });
    } catch (e) {
      await userRepository.signOut();
      yield AuthError(errorMsg: e.toString());
    }
    // yield AuthLoading();
    // try {
    //   await userRepository.createCustomer();
    //   await userRepository.client.uploadCloudMsgToken();
    //   yield Autheticated();
    // } on Exception catch (e) {
    //   await userRepository.signOut();
    //   yield AuthError(
    //     errorMsg: e.toString(),
    //   );
    // }
  }

  Stream<AuthState> _mapSignupFromFacebookToState(
      AuthFacebookEvent event) async* {
    yield AuthLoading();
    _userSubscription?.cancel();
    Function onData = (DocumentSnapshot documentSnapshot, String email) {
      if (documentSnapshot.data != null &&
          documentSnapshot.data['Phone'] != null) {
        _userSubscription?.cancel();
        if (documentSnapshot.data['Phone'] == "") {
          //* document created and user don't have email yet
          //* So this is a new user
          // add(SignUpNewUserFromGoogle());
          add(InternalFacebookVerified(email: email));
        } else {
          //* user already have email so login process complete
          add(AuthInternalSucEvent());
        }
      }
    };
    String email = "";
    final FacebookLoginResult result = await facebookLogin.logIn(['email']);
    print(result.status.toString());
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;

        print("Facebook logged in: " + accessToken.token.toString());
        final credential =
            FacebookAuthProvider.getCredential(accessToken: accessToken.token);
        final AuthResult authResult =
            await _auth.signInWithCredential(credential);

        final FirebaseUser user = authResult.user;
        user.providerData
            .map((item) => {
                  if (item.email != null) {email = item.email}
                })
            .toList();
        _userSubscription =
            userRepository.getRealTimeUser(user.uid).listen((snapshot) {
          onData(snapshot, email);
        });
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("Login cancelled by user");
        break;
      case FacebookLoginStatus.error:
        print("Something went wrong with the login process");
        break;
    }
  }
}
