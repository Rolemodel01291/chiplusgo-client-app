import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ChargeHistoryEvent extends Equatable {}


class FetchChargeHistory extends ChargeHistoryEvent {
  @override
  String toString() => 'Fetch charge history';

  @override
  List<Object> get props => null;
}

