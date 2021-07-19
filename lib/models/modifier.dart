import 'modifier_option.dart';
import 'package:json_annotation/json_annotation.dart';

part 'modifier.g.dart';

@JsonSerializable(anyMap: true)
class Modifier {
  @JsonKey(name: 'Name')
  String name;
  @JsonKey(name: 'Name_cn')
  String nameCn;
  @JsonKey(name: 'Multi_choices')
  bool multiChoices;
  @JsonKey(name: 'Options')
  List<ModifierOptions> options;

  Modifier({this.multiChoices, this.name, this.nameCn, this.options});

  factory Modifier.fromJson(Map<String, dynamic> json) =>
      _$ModifierFromJson(json);

  Map<String, dynamic> toJson() => _$ModifierToJson(this);
}
