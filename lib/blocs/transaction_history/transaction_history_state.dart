import 'package:equatable/equatable.dart';
import 'package:infishare_client/models/models.dart';
import 'package:infishare_client/models/transaction_history.dart';
import 'package:meta/meta.dart';

@immutable
abstract class TransactionHistoryState extends Equatable {}

class TransactionHistoryUninit extends TransactionHistoryState {
  @override
  List<Object> get props => null;

  @override
  String toString() => 'transaction history uninit';
}

class TransactionHistoryError extends TransactionHistoryState {
  final String errorMsg;

  TransactionHistoryError({this.errorMsg});

  @override
  List<Object> get props => [errorMsg];

  @override
  String toString() => 'History loaded error: $errorMsg';
}

class TransactionHistoryLoaded extends TransactionHistoryState {
  final List<TransactionHistory> historys;
  final bool hasReachedMax;

  TransactionHistoryLoaded({this.historys, this.hasReachedMax});

  TransactionHistoryLoaded copyWith(
      {List<TransactionHistory> history, bool hasReachedMax}) {
    return TransactionHistoryLoaded(
      historys: history ?? this.historys,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [historys, hasReachedMax];

  @override
  String toString() =>
      'Transaction History loaded length ${historys.length} hasReachMax: $hasReachedMax';
}
