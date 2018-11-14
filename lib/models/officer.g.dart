// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'officer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Officer _$OfficerFromJson(Map<String, dynamic> json) {
  return Officer(
      json['officerName'] as String, json['officerPosition'] as String);
}

Map<String, dynamic> _$OfficerToJson(Officer instance) => <String, dynamic>{
      'officerName': instance.officerName,
      'officerPosition': instance.officerPosition
    };
