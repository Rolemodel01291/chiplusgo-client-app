import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'address.g.dart';

@JsonSerializable()
class Address extends Equatable {
  @JsonKey(name: 'City')
  final String city;
  @JsonKey(name: 'State')
  final String state;
  @JsonKey(name: 'Street')
  final String street;
  @JsonKey(name: 'Zipcode')
  final String zipCode;

  Address({this.city, this.state, this.street, this.zipCode});

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);

  String getOneLineDisplayAddress() {
    return street + ", " + city + ", " + state;
  }

  @override
  List<Object> get props => [state, city, street, zipCode];
}
