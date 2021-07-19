import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:infishare_client/models/coupon_ticket.dart';
import 'package:infishare_client/repo/coupon_repo.dart';
import './bloc.dart';

class ItemsUpdateBloc extends Bloc<ItemsUpdateEvent, ItemsUpdateState> {
  CouponTicket couponTicket;
  CouponRepository couponRepository;

  ItemsUpdateBloc({this.couponTicket, this.couponRepository});

  @override
  ItemsUpdateState get initialState => ItemsPicked(couponTicket);

  @override
  Stream<ItemsUpdateState> mapEventToState(
    ItemsUpdateEvent event,
  ) async* {
    if (event is ChangeCouponItems) {
      yield* _mapChangeCouponItems(event);
    } else if (event is AddItemEvent) {
      yield* _mapAddCouponItemToState(event);
    } else if (event is RemoveItemEvent) {
      yield* _mapRemoveCouponItemToState(event);
    }
  }

  Stream<ItemsUpdateState> _mapChangeCouponItems(
    ChangeCouponItems event,
  ) async* {
    try {
      yield ItemsUpdating(couponTicket);
      // await couponRepository.updateTicketItems(
      //     couponTicket.couponId, couponTicket.detail);
      yield ItemsUpdateSuccess(couponTicket);
    } catch (_) {
      yield ItemsUpdateError('Can not update combo info', couponTicket);
    }
  }

  Stream<ItemsUpdateState> _mapAddCouponItemToState(
    AddItemEvent event,
  ) async* {
    //* three situation
    //* 1. if group.pick == 1 and items[itemIndex].count == 1, this item should be unselect
    //* 2. if group.pick == 1 and items[itemIndex].count == 0, unselect other item and select this one
    //* 3. if group.pick > 2 check if group can pick more

    // if (couponTicket.detail.groups[event.groupIndex].pick == 1) {
    //   if (couponTicket
    //           .detail.groups[event.groupIndex].items[event.itemIndex].count ==
    //       1) {
    //     couponTicket.detail.groups[event.groupIndex]
    //         .removeItem(event.itemIndex);
    //     yield ItemsPicked(couponTicket);
    //   } else {
    //     couponTicket.detail.groups[event.groupIndex].clearItemCoun();
    //     couponTicket.detail.groups[event.groupIndex].addItem(event.itemIndex);
    //     yield ItemsPicked(couponTicket);
    //   }
    // } else if (couponTicket.detail.groups[event.groupIndex].canPick()) {
    //   couponTicket.detail.groups[event.groupIndex].addItem(event.itemIndex);
    //   yield ItemsPicked(couponTicket);
    // }
  }

  Stream<ItemsUpdateState> _mapRemoveCouponItemToState(
    RemoveItemEvent event,
  ) async* {
    // if (couponTicket
    //         .detail.groups[event.groupIndex].items[event.itemIndex].count >
    //     0) {
    //   couponTicket.detail.groups[event.groupIndex].removeItem(event.itemIndex);
    //   yield ItemsPicked(couponTicket);
    // }
  }
}
