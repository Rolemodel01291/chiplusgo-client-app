import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'coupon_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
part 'coupon_ticket.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class CouponTicket extends Equatable {
  @JsonKey(name: 'Used_Business_name')
  final List<Map<String, String>> usedBusinessName;
  @JsonKey(name: 'Description')
  final String description;
  @JsonKey(name: 'Description_cn')
  final String descriptionCn;
  // @JsonKey(name: 'Details')
  // CouponDetail detail;
  @JsonKey(name: 'Item', defaultValue: [])
  final List<Map<String, String>> items;
  @JsonKey(name: 'Image', defaultValue: [])
  final List<String> images;
  @JsonKey(name: 'Rules')
  CouponRule rule;
  @JsonKey(name: 'Title')
  final String name;
  @JsonKey(name: 'Title_cn')
  final String nameCn;
  @JsonKey(name: 'Original_price')
  final double oriPrice;
  @JsonKey(name: 'Price')
  final double price;
  // @JsonKey(name: 'Type')
  // final String couponType;
  @JsonKey(name: 'Business_name')
  final List<Map<String, String>> businessName;
  @JsonKey(name: 'BusinessId')
  final List<String> businessId;
  // @JsonKey(name: 'Receipt_num')
  // final String receiptNum;
  @JsonKey(name: 'Used')
  final bool used;
  @JsonKey(name: 'ClientId')
  final String clientId;
  // @JsonKey(name: 'Picked')
  // bool picked;
  // @JsonKey(name: 'Ticket_num')
  // final String ticketNum;
  @JsonKey(name: 'CouponId')
  final String couponId;
  @JsonKey(name: 'CouponTicketId')
  final String couponTicketId;
  // @JsonKey(name: 'Tips')
  // final double tips;
  @JsonKey(name: 'Tax')
  final double tax;

  @JsonKey(ignore: true)
  List<DocumentReference> businessRef;
  @JsonKey(ignore: true)
  DateTime purchaseDate;
  @JsonKey(ignore: true)
  DateTime usedDate;
  @JsonKey(ignore: true)
  DateTime startDate;
  @JsonKey(ignore: true)
  DateTime endDate;

  CouponTicket(
      // this.detail,
      this.usedBusinessName,
      this.description,
      this.descriptionCn,
      this.items,
      this.images,
      this.rule,
      this.name,
      this.nameCn,
      this.oriPrice,
      this.price,
      // this.couponType,
      this.businessId,
      // this.receiptNum,
      this.used,
      this.clientId,
      // this.ticketNum,
      this.couponId,
      this.couponTicketId,
      this.businessName,
      // this.tips,
      this.tax);

  factory CouponTicket.fromJson(Map<String, dynamic> json) {
    print("${json['Item']}");
    print("${json['Business_name']}");
    var ticket = _$CouponTicketFromJson(json);
    print("-------------------------------");
    ticket.businessRef =
        json['Business'].cast<DocumentReference>() as List<DocumentReference>;
    ticket.purchaseDate = (json['Purchase_date'] as Timestamp).toDate();
    ticket.usedDate = (json['Used_date'] as Timestamp)?.toDate();
    ticket.startDate = (json['Validatity']['Start_date'] as Timestamp).toDate();
    ticket.endDate = (json['Validatity']['End_date'] as Timestamp).toDate();
    return ticket;
  }

  CouponTicket copyWith({CouponDetail coupondetail}) {
    return CouponTicket(
        // detail ?? this.detail,
        this.usedBusinessName,
        this.description,
        this.descriptionCn,
        this.items,
        this.images,
        this.rule,
        this.name,
        this.nameCn,
        this.oriPrice,
        this.price,
        // this.couponType,
        this.businessId,
        // this.receiptNum,
        this.used,
        this.clientId,
        // this.ticketNum,
        this.couponId,
        this.couponTicketId,
        this.businessName,
        // this.tips,
        this.tax);
  }

  Map<String, dynamic> toJson() => _$CouponTicketToJson(this);

  String getDiscountInt() {
    return price.toStringAsFixed(2).split('.')[0];
  }

  String getDiscountDecimal() {
    return price.toStringAsFixed(2).split('.')[1];
  }

  String getPriceInt() {
    return (oriPrice - price).toStringAsFixed(2).split('.')[0];
  }

  String getPriceDecimal() {
    return (oriPrice - price).toStringAsFixed(2).split('.')[1];
  }

  String getUsedDate() {
    if (usedDate != null) {
      return DateFormat('MM/dd/yyyy').format(usedDate.toLocal());
    } else {
      return DateFormat('MM/dd/yyyy').format(endDate.toLocal());
    }
  }

  bool isBeforeToday(Timestamp timestamp) {
    return DateTime.now().toUtc().isBefore(
          DateTime.fromMillisecondsSinceEpoch(
            timestamp.millisecondsSinceEpoch,
            isUtc: false,
          ).toUtc(),
        );
  }

  bool getExpire() {
    if (!used && isBeforeToday(Timestamp.fromDate(endDate))) {
      return false;
    } else {
      return true;
    }
  }

  bool getExpireState() {
    if (usedDate != null) {
      return false;
    } else {
      return true;
    }
  }

  bool isUsed() {
    if (used) {
      return true;
    } else {
      return false;
    }
  }

  bool isExpired() {
    if (!used && !isBeforeToday(Timestamp.fromDate(endDate))) {
      return true;
    } else {
      return false;
    }
  }

  bool isNew() {
    if (!used && isBeforeToday(Timestamp.fromDate(endDate))) {
      return true;
    } else {
      return false;
    }
  }

  String getPurchaseDate() {
    return DateFormat('MM/dd/yyyy').format(purchaseDate.toLocal());
  }

  String getVaildDate() {
    return DateFormat('MM/dd/yyyy').format(startDate.toLocal()) +
        '~' +
        DateFormat('MM/dd/yyyy').format(endDate.toLocal());
  }

  // double getTotal() {
  //   return price + tax + tips;
  // }

  @override
  List<Object> get props => [
        // this.detail,

        this.description,
        this.descriptionCn,
        this.items,
        this.images,
        this.name,
        this.nameCn,
        this.oriPrice,
        this.price,
        // this.couponType,
        this.businessId,
        // this.receiptNum,
        this.rule,
        this.used,
        this.clientId,
        // this.ticketNum,
        this.couponId,
        this.couponTicketId,
        this.businessName,
        // this.tips,
        this.tax
      ];
}
