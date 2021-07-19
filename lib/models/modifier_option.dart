import 'package:json_annotation/json_annotation.dart';

part 'modifier_option.g.dart';

@JsonSerializable(anyMap: true)
class ModifierOptions {
  @JsonKey(name: 'Name')
  String name;
  @JsonKey(name: 'Name_cn')
  String nmaeCn;
  @JsonKey(name: 'Price_offset')
  double priceOffset;

  ModifierOptions(this.name, this.nmaeCn, this.priceOffset);

  factory ModifierOptions.fromJson(Map<String, dynamic> json) =>
      _$ModifierOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$ModifierOptionsToJson(this);
}
