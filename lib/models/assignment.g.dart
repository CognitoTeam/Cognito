// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assignment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Assignment _$AssignmentFromJson(Map<String, dynamic> json) {
  return Assignment(
      title: json['title'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
      pointsPossible: (json['pointsPossible'] as num)?.toDouble(),
      pointsEarned: (json['pointsEarned'] as num)?.toDouble(),
      isAssessment: json['isAssessment'] as bool,
      category: json['category'] == null
          ? null
          : Category.fromJson(json['category'] as Map<String, dynamic>))
    ..startTime = json['startTime'] == null
        ? null
        : DateTime.parse(json['startTime'] as String)
    ..endTime = json['endTime'] == null
        ? null
        : DateTime.parse(json['endTime'] as String)
    ..isRepeated = json['isRepeated'] as bool
    ..daysOfEvent =
        (json['daysOfEvent'] as List)?.map((e) => e as int)?.toList()
    ..subTasks = (json['subTasks'] as List)
        ?.map(
            (e) => e == null ? null : Task.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$AssignmentToJson(Assignment instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'location': instance.location,
      'startTime': instance.startTime?.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'isRepeated': instance.isRepeated,
      'daysOfEvent': instance.daysOfEvent,
      'dueDate': instance.dueDate?.toIso8601String(),
      'subTasks': instance.subTasks,
      'pointsPossible': instance.pointsPossible,
      'pointsEarned': instance.pointsEarned,
      'isAssessment': instance.isAssessment,
      'category': instance.category
    };
