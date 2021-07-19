import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'app_version.g.dart';

@JsonSerializable()
class AppVersion extends Equatable {
  @JsonKey(name: 'Latest_version')
  final VersionWithNotes lastest;
  @JsonKey(name: 'Minimal_version')
  final VersionWithNotes minimal;

  @JsonKey(ignore: true)
  Timestamp updateTime;

  AppVersion(this.lastest, this.minimal);

  factory AppVersion.fromJson(Map<String, dynamic> json) =>
      _$AppVersionFromJson(json);

  Map<String, dynamic> toJson() => _$AppVersionToJson(this);

  @override
  List<Object> get props => [lastest, minimal];
}

@JsonSerializable()
class VersionWithNotes extends Equatable {
  @JsonKey(name: 'Version')
  final VersionCode versionCode;
  @JsonKey(name: 'Notes')
  final String note;

  VersionWithNotes(this.versionCode, this.note);

  factory VersionWithNotes.fromJson(Map<String, dynamic> json) =>
      _$VersionWithNotesFromJson(json);

  Map<String, dynamic> toJson() => _$VersionWithNotesToJson(this);

  @override
  List<Object> get props => [versionCode, note];
}

@JsonSerializable()
class VersionCode extends Equatable {
  @JsonKey(name: 'Build')
  final int build;
  @JsonKey(name: 'Major')
  final int major;
  @JsonKey(name: 'Minor')
  final int minor;

  VersionCode(this.build, this.major, this.minor);

  factory VersionCode.fromJson(Map<String, dynamic> json) =>
      _$VersionCodeFromJson(json);

  Map<String, dynamic> toJson() => _$VersionCodeToJson(this);


  /// Check version number with server
  int checkVersion(int ma, int mi, int bu) {
    if (major - ma == 0) {
      if (minor - mi == 0) {
        if (build - bu == 0) {
          return 0;
        } else {
          return build - bu;
        }
      } else {
        return minor - mi;
      }
    } else {
      return major - ma;
    }
  }

  @override
  List<Object> get props => [build, major, minor];
}
