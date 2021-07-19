import 'package:infishare_client/models/models.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ItemsUpdateState {}

class ItemsData extends ItemsUpdateState {
  final CouponTicket ticket;

  ItemsData([this.ticket]);
}

class ItemsUpdating extends ItemsData {
  ItemsUpdating([CouponTicket ticket]) : super(ticket);
}

class ItemsUpdateSuccess extends ItemsData {
  ItemsUpdateSuccess([CouponTicket ticket]) : super(ticket);
}

class ItemsUpdateError extends ItemsData {
  final String errorMsg;
  ItemsUpdateError(this.errorMsg, [CouponTicket ticket]) : super(ticket);
}

class ItemsPicked extends ItemsData {
  ItemsPicked([CouponTicket ticket]) : super(ticket);
}
