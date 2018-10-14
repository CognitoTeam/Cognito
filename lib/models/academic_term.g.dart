// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'academic_term.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AcademicTerm _$AcademicTermFromJson(Map<String, dynamic> json) {
  return AcademicTerm(
      json['termName'] as String,
      json['startTime'] == null
          ? null
          : DateTime.parse(json['startTime'] as String),
      json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String))
    ..classes = (json['classes'] as List)
        ?.map(
            (e) => e == null ? null : Class.fromJson(e as Map<String, dynamic>))
        ?.toSet()
    ..clubs = (json['clubs'] as List)
        ?.map(
            (e) => e == null ? null : Club.fromJson(e as Map<String, dynamic>))
        ?.toSet();
}

Map<String, dynamic> _$AcademicTermToJson(AcademicTerm instance) =>
    <String, dynamic>{
      'termName': instance.termName,
      'startTime': instance.startTime?.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'classes': instance.classes?.toList(),
      'clubs': instance.clubs?.toList()
    };
