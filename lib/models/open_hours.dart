import 'package:json_annotation/json_annotation.dart';

part 'open_hours.g.dart';

@JsonSerializable(anyMap: true)
class Hour {
  @JsonKey(name: 'Monday', defaultValue: [])
  final List<String> mondy;
  @JsonKey(name: 'Tuesday', defaultValue: [])
  final List<String> tuesday;
  @JsonKey(name: 'Wednesday', defaultValue: [])
  final List<String> wednesday;
  @JsonKey(name: 'Thursday', defaultValue: [])
  final List<String> thursday;
  @JsonKey(name: 'Friday', defaultValue: [])
  final List<String> friday;
  @JsonKey(name: 'Saturday', defaultValue: [])
  final List<String> saturday;
  @JsonKey(name: 'Sunday', defaultValue: [])
  final List<String> sunday;

  Hour(this.mondy, this.tuesday, this.wednesday, this.thursday, this.friday,
      this.saturday, this.sunday);

  factory Hour.fromJson(Map<String, dynamic> json) => _$HourFromJson(json);

  Map<String, dynamic> toJson() => _$HourToJson(this);
}

@JsonSerializable()
class OpenHour {
  @JsonKey(name: 'Hours')
  final Hour hour;
  @JsonKey(name: 'IsOpenNow', nullable: true, defaultValue: true)
  final bool isOpen;

  OpenHour(this.hour, this.isOpen);

  factory OpenHour.fromJson(Map<String, dynamic> json) =>
      _$OpenHourFromJson(json);

  Map<String, dynamic> toJson() => _$OpenHourToJson(this);
}
