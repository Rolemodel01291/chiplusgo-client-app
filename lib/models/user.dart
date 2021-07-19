import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(anyMap: true)
class User {
  @JsonKey(name: 'Balance')
  final double balance;
  @JsonKey(name: 'CreditLine_balance')
  final double creditlineBalance;
  @JsonKey(name: 'Customer_id')
  final String customerId;
  @JsonKey(name: 'Avatar')
  final String avatar;
  @JsonKey(name: 'Email')
  final String email;
  @JsonKey(name: 'Name')
  final String name;
  @JsonKey(name: 'Phone')
  final String phone;
  @JsonKey(name: 'Point')
  final int point;
  @JsonKey(name: 'Points_balance')
  final int pointsBalance;
  @JsonKey(name: 'Referral_code')
  final String referralCode;
  @JsonKey(name: 'Refered_code')
  final String referredCode;
  @JsonKey(name: 'AddressLine1')
  final String addressLine1;
  @JsonKey(name: 'AddressLine2')
  final String addressLine2;
  @JsonKey(name: 'City')
  final String city;
  @JsonKey(name: 'SignupType', nullable: true)
  final String signupType;

  User(
      {this.avatar,
      this.balance,
      this.creditlineBalance,
      this.customerId,
      this.email,
      this.name,
      this.phone,
      this.point,
      this.pointsBalance,
      this.referralCode,
      this.referredCode,
      this.addressLine1,
      this.addressLine2,
      this.city,
      this.signupType});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
