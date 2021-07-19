// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'open_hours.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Hour _$HourFromJson(Map json) {
  return Hour(
    (json['Monday'] as List)?.map((e) => e as String)?.toList() ?? [],
    (json['Tuesday'] as List)?.map((e) => e as String)?.toList() ?? [],
    (json['Wednesday'] as List)?.map((e) => e as String)?.toList() ?? [],
    (json['Thursday'] as List)?.map((e) => e as String)?.toList() ?? [],
    (json['Friday'] as List)?.map((e) => e as String)?.toList() ?? [],
    (json['Saturday'] as List)?.map((e) => e as String)?.toList() ?? [],
    (json['Sunday'] as List)?.map((e) => e as String)?.toList() ?? [],
  );
}

Map<String, dynamic> _$HourToJson(Hour instance) => <String, dynamic>{
      'Monday': instance.mondy,
      'Tuesday': instance.tuesday,
      'Wednesday': instance.wednesday,
      'Thursday': instance.thursday,
      'Friday': instance.friday,
      'Saturday': instance.saturday,
      'Sunday': instance.sunday,
    };

OpenHour _$OpenHourFromJson(Map json) {
  return OpenHour(
    json['Hours'] == null
        ? null
        : Hour.fromJson((json['Hours'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
    json['IsOpenNow'] as bool ?? true,
  );
}

Map<String, dynamic> _$OpenHourToJson(OpenHour instance) => <String, dynamic>{
      'Hours': instance.hour,
      'IsOpenNow': instance.isOpen,
    };
