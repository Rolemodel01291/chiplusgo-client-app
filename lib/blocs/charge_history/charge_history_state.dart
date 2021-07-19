import 'package:equatable/equatable.dart';
import 'package:infishare_client/models/models.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ChargeHistoryState extends Equatable {}

class ChargeHistoryUninit extends ChargeHistoryState {
  @override
  List<Object> get props => null;

  @override
  String toString() => 'charge history uninit';
}

class ChargeHistoryError extends ChargeHistoryState {
  final String errorMsg;

  ChargeHistoryError({this.errorMsg});

  @override
  List<Object> get props => [errorMsg];

  @override
  String toString() => 'History loaded error: $errorMsg';
}

class ChargeHistoryLoaded extends ChargeHistoryState {
  final List<ChargeHistory> historys;
  final bool hasReachedMax;

  ChargeHistoryLoaded({this.historys, this.hasReachedMax});

  ChargeHistoryLoaded copyWith(
      {List<ChargeHistory> history, bool hasReachedMax}) {
    return ChargeHistoryLoaded(
      historys: history ?? this.historys,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [historys, hasReachedMax];

  @override
  String toString() =>
      'History loaded length ${historys.length} hasReachMax: $hasReachedMax';
}
