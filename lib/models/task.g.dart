// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) {
  return Task(
      title: json['title'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      isRepeated: json['isRepeated'] as bool,
      daysOfEvent:
          (json['daysOfEvent'] as List)?.map((e) => e as int)?.toList(),
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
      id: json['id'] as int)
    ..startTime = json['startTime'] == null
        ? null
        : DateTime.parse(json['startTime'] as String)
    ..endTime = json['endTime'] == null
        ? null
        : DateTime.parse(json['endTime'] as String)
    ..subTasks = (json['subTasks'] as List)
        ?.map(
            (e) => e == null ? null : Task.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'location': instance.location,
      'startTime': instance.startTime?.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'isRepeated': instance.isRepeated,
      'id': instance.id,
      'daysOfEvent': instance.daysOfEvent,
      'dueDate': instance.dueDate?.toIso8601String(),
      'subTasks': instance.subTasks
    };
