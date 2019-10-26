// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) {
  return Event(
      title: json['title'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      isRepeated: json['isRepeated'] as bool,
      daysOfEvent:
          (json['daysOfEvent'] as List)?.map((e) => e as int)?.toList(),
      id: json['id'] as String,
      priority: json['priority'] as int,
      duration: json['duration'] == null
          ? null
          : Duration(microseconds: json['duration'] as int))
    ..startTime = json['startTime'] == null
        ? null
        : DateTime.parse(json['startTime'] as String)
    ..endTime = json['endTime'] == null
        ? null
        : DateTime.parse(json['endTime'] as String);
}

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'location': instance.location,
      'startTime': instance.startTime?.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'isRepeated': instance.isRepeated,
      'id': instance.id,
      'priority': instance.priority,
      'duration': instance.duration?.inMicroseconds,
      'daysOfEvent': instance.daysOfEvent
    };
