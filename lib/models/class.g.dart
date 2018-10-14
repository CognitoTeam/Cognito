// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'class.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Class _$ClassFromJson(Map<String, dynamic> json) {
  return Class(
      title: json['title'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      courseNumber: json['courseNumber'] as String,
      instructor: json['instructor'] as String,
      officeLocation: json['officeLocation'] as String,
      subjectArea: json['subjectArea'] as String,
      units: json['units'] as int)
    ..startTime = json['startTime'] == null
        ? null
        : DateTime.parse(json['startTime'] as String)
    ..endTime = json['endTime'] == null
        ? null
        : DateTime.parse(json['endTime'] as String)
    ..isRepeated = json['isRepeated'] as bool
    ..daysOfEvent =
        (json['daysOfEvent'] as List)?.map((e) => e as int)?.toList()
    ..officeHours = (json['officeHours'] as Map<String, dynamic>)?.map((k, e) =>
        MapEntry(
            k,
            (e as List)
                ?.map((e) => e == null ? null : DateTime.parse(e as String))
                ?.toList()))
    ..todo = (json['todo'] as Map<String, dynamic>)?.map((k, e) => MapEntry(
        k,
        (e as List)
            ?.map((e) =>
                e == null ? null : Task.fromJson(e as Map<String, dynamic>))
            ?.toList()));
}

Map<String, dynamic> _$ClassToJson(Class instance) => <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'location': instance.location,
      'startTime': instance.startTime?.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'isRepeated': instance.isRepeated,
      'daysOfEvent': instance.daysOfEvent,
      'subjectArea': instance.subjectArea,
      'courseNumber': instance.courseNumber,
      'instructor': instance.instructor,
      'officeLocation': instance.officeLocation,
      'units': instance.units,
      'officeHours': instance.officeHours?.map(
          (k, e) => MapEntry(k, e?.map((e) => e?.toIso8601String())?.toList())),
      'todo': instance.todo
    };
