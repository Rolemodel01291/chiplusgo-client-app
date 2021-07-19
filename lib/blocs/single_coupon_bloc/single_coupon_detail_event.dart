import 'package:infishare_client/models/models.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SingleCouponDetailEvent {}

class FetchCouponAndBusiness extends SingleCouponDetailEvent {

  FetchCouponAndBusiness();

  @override
  String toString() =>
      'Fetch coupon';
}
