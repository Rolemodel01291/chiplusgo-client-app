import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:infishare_client/blocs/auth_bloc/auth_state.dart';
import 'package:infishare_client/blocs/blocs.dart';
import 'package:infishare_client/channel/stripe_channel.dart';
import 'package:infishare_client/models/models.dart';
import 'package:infishare_client/repo/repo.dart';
import './bloc.dart';

class MyAcountBloc extends Bloc<MyAcountEvent, MyAcountState> {
  final AuthBloc authBloc;
  final UserRepository userRepository;
  final PaymentRepository paymentRepository;
  StreamSubscription<DocumentSnapshot> _userSub;
  StreamSubscription _paymentSub;
  StreamSubscription authSub;
  StripeChannel _stripeChannel = StripeChannel();

  MyAcountBloc({
    this.authBloc,
    this.userRepository,
    this.paymentRepository,
  }) {
    authSub = authBloc.listen((state) {
      if (state is Autheticated) {
        add(FetchUserData());
      } else if (state is UnAutheticated) {
        add(InternalNoUser());
      }
    });
  }

  @override
  MyAcountState get initialState => NoAcountState();

  @override
  Stream<MyAcountState> mapEventToState(
    MyAcountEvent event,
  ) async* {
    if (event is FetchUserData) {
      yield* _mapFetchUserToState(event);
    } else if (event is InternalNoUser) {
      yield* _mapInternalNoUserToState(event);
    } else if (event is InternalUserUpdate) {
      yield* _mapInternalUserUpdate(event);
    } else if (event is ShowPayment) {
      yield* _mapShowPayment(event);
    }
  }

  Stream<MyAcountState> _mapFetchUserToState(FetchUserData event) async* {
    try {
      yield MyAccountLoading();
      _userSub?.cancel();
      final user = await userRepository.getCurrentUser();
      if (user == null) {
        yield NoAcountState();
        return;
      }
      _userSub = userRepository.getRealTimeUser(user.uid).listen((snapShot) {
        final user = User.fromJson(snapShot.data);
        add(
          InternalUserUpdate(user: user),
        );
      });
    } catch (e) {
      yield MyAccountLoadError(errorMsg: e.toString());
    }
  }

  Stream<MyAcountState> _mapInternalNoUserToState(InternalNoUser event) async* {
    yield NoAcountState();
  }

  Stream<MyAcountState> _mapInternalUserUpdate(
      InternalUserUpdate event) async* {
    yield MyAccountLoaded(event.user);
  }

  Stream<MyAcountState> _mapShowPayment(ShowPayment event) async* {
    try {
      //yield MyAccountLoadingPayment((state as MyAccountLoaded).user);
      await _stripeChannel.editPayment();
      yield MyAccountLoaded((state as MyAccountLoaded).user);
    } catch (e) {
      yield MyAccountPaymentError(
          e.toString(), (state as MyAccountLoaded).user);
    }
  }

  @override
  Future<void> close() async {
    authSub.cancel();
    _userSub?.cancel();
    _paymentSub?.cancel();
    super.close();
  }
}
