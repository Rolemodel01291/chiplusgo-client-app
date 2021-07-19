import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:infishare_client/repo/repo.dart';
import './bloc.dart';
import 'package:rxdart/rxdart.dart';

class ChargeHistoryBloc extends Bloc<ChargeHistoryEvent, ChargeHistoryState> {
  final PaymentRepository paymentRepository;

  ChargeHistoryBloc({this.paymentRepository});

  @override
  Stream<ChargeHistoryState> transformEvents(
    Stream<ChargeHistoryEvent> events,
    Stream<ChargeHistoryState> Function(ChargeHistoryEvent event) next,
  ) {
    return super.transformEvents(
      events.debounceTime(
        Duration(milliseconds: 500),
      ),
      next,
    );
  }

  @override
  ChargeHistoryState get initialState => ChargeHistoryUninit();

  @override
  Stream<ChargeHistoryState> mapEventToState(
    ChargeHistoryEvent event,
  ) async* {
    final currentState = state;
    if (event is FetchChargeHistory && !_hasReachMax(currentState)) {
      try {
        if (currentState is ChargeHistoryUninit ||
            currentState is ChargeHistoryError) {
          final historys =
              await paymentRepository.getChargeHistory(limit: 10, startId: '');
          yield ChargeHistoryLoaded(
            historys: historys,
            hasReachedMax: historys.length < 10,
          );
          return;
        }

        if (currentState is ChargeHistoryLoaded) {
          final historys = await paymentRepository.getChargeHistory(
              limit: 10, startId: currentState.historys.last.id);
          yield historys.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : ChargeHistoryLoaded(
                  hasReachedMax: false,
                  historys: currentState.historys + historys,
                );
        }
      } catch (e) {
        print(e);
        yield ChargeHistoryError(errorMsg: 'Error loading charge history');
      }
    }
  }

  bool _hasReachMax(ChargeHistoryState state) =>
      state is ChargeHistoryLoaded && state.hasReachedMax;
}
