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
        ?.toList()
    ..clubs = (json['clubs'] as List)
        ?.map(
            (e) => e == null ? null : Club.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..tasks = (json['tasks'] as List)
        ?.map(
            (e) => e == null ? null : Task.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..events = (json['events'] as List)
        ?.map(
            (e) => e == null ? null : Event.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$AcademicTermToJson(AcademicTerm instance) =>
    <String, dynamic>{
      'termName': instance.termName,
      'startTime': instance.startTime?.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'classes': instance.classes,
      'clubs': instance.clubs,
      'tasks': instance.tasks,
      'events': instance.events
    };
