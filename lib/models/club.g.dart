// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'club.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Club _$ClubFromJson(Map<String, dynamic> json) {
  return Club(
      title: json['title'] as String,
      description: json['description'] as String,
      location: json['location'] as String)
    ..startTime = json['startTime'] == null
        ? null
        : DateTime.parse(json['startTime'] as String)
    ..endTime = json['endTime'] == null
        ? null
        : DateTime.parse(json['endTime'] as String)
    ..isRepeated = json['isRepeated'] as bool
    ..daysOfEvent =
        (json['daysOfEvent'] as List)?.map((e) => e as int)?.toList()
    ..officers = (json['officers'] as List)
        ?.map((e) =>
            e == null ? null : Officer.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..events = (json['events'] as List)
        ?.map(
            (e) => e == null ? null : Event.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..tasks = (json['tasks'] as List)
        ?.map(
            (e) => e == null ? null : Task.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$ClubToJson(Club instance) => <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'location': instance.location,
      'startTime': instance.startTime?.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'isRepeated': instance.isRepeated,
      'daysOfEvent': instance.daysOfEvent,
      'officers': instance.officers,
      'events': instance.events,
      'tasks': instance.tasks
    };
