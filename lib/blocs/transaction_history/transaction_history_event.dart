import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class TransactionHistoryEvent extends Equatable {}


class FetchTransactionHistory extends TransactionHistoryEvent {
  @override
  String toString() => 'Fetch transaction history';

  @override
  List<Object> get props => null;
}

