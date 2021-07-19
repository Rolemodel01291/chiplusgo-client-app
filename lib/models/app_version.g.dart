// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_version.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppVersion _$AppVersionFromJson(Map json) {
  return AppVersion(
    json['Latest_version'] == null
        ? null
        : VersionWithNotes.fromJson((json['Latest_version'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
    json['Minimal_version'] == null
        ? null
        : VersionWithNotes.fromJson((json['Minimal_version'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
  );
}

Map<String, dynamic> _$AppVersionToJson(AppVersion instance) =>
    <String, dynamic>{
      'Latest_version': instance.lastest,
      'Minimal_version': instance.minimal,
    };

VersionWithNotes _$VersionWithNotesFromJson(Map json) {
  return VersionWithNotes(
    json['Version'] == null
        ? null
        : VersionCode.fromJson((json['Version'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
    json['Notes'] as String,
  );
}

Map<String, dynamic> _$VersionWithNotesToJson(VersionWithNotes instance) =>
    <String, dynamic>{
      'Version': instance.versionCode,
      'Notes': instance.note,
    };

VersionCode _$VersionCodeFromJson(Map json) {
  return VersionCode(
    json['Build'] as int,
    json['Major'] as int,
    json['Minor'] as int,
  );
}

Map<String, dynamic> _$VersionCodeToJson(VersionCode instance) =>
    <String, dynamic>{
      'Build': instance.build,
      'Major': instance.major,
      'Minor': instance.minor,
    };
