import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:infishare_client/repo/repo.dart';
import 'bloc.dart';
import 'package:rxdart/rxdart.dart';

class TransactionHistoryBloc extends Bloc<TransactionHistoryEvent, TransactionHistoryState> {
  final PaymentRepository paymentRepository;

  TransactionHistoryBloc({this.paymentRepository});

  @override
  Stream<TransactionHistoryState> transformEvents(
    Stream<TransactionHistoryEvent> events,
    Stream<TransactionHistoryState> Function(TransactionHistoryEvent event) next,
  ) {
    return super.transformEvents(
      events.debounceTime(
        Duration(milliseconds: 500),
      ),
      next,
    );
  }

  @override
  TransactionHistoryState get initialState => TransactionHistoryUninit();

  @override
  Stream<TransactionHistoryState> mapEventToState(
    TransactionHistoryEvent event,
  ) async* {
    final currentState = state;
    if (event is FetchTransactionHistory && !_hasReachMax(currentState)) {
      try {
        if (currentState is TransactionHistoryUninit ||
            currentState is TransactionHistoryError) {
          // final historys =
          //     await paymentRepository.getChargeHistory(limit: 10, startId: '');
          final historys = 
                await paymentRepository.getTransactionHistory();
                
          yield TransactionHistoryLoaded(
            historys: historys,
            hasReachedMax: historys.length < 10,
          );
          
          return;
        }

        if (currentState is TransactionHistoryLoaded) {
          final historys = await paymentRepository.getTransactionHistory();
          
          yield historys.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : TransactionHistoryLoaded(
                  hasReachedMax: false,
                  historys: currentState.historys + historys,
                );
        }
      } catch (e) {
        print(e);
        yield TransactionHistoryError(errorMsg: 'Error loading transaction history');
      }
    }
  }

  bool _hasReachMax(TransactionHistoryState state) =>
      state is TransactionHistoryLoaded && state.hasReachedMax;
}
