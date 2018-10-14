/// Models an event on a schedule
/// 
//import 'package:json_serializable/json_serializable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event.g.dart';

@JsonSerializable()
/**
 * TODO: Default values???? for daysofevents, starttime, end time??
 * 
 */
class Event {
  /// Instance variables
  String title, description, location;
  DateTime startTime, endTime;
  bool isRepeated;

  // Elements in list represent day(s) on which this event occurs
  // 1 => Monday, 2 => Tuesday ... 7 => Sunday
  List<int> daysOfEvent;

  /// Default constructor that creates an Event from all information
  Event(
      {String title,
      String description = "",
      String location = "",
      DateTime start,
      DateTime end,
      bool isRepeated,
      List<int> daysOfEvent}) {
    this.title = title;
    this.description = description;
    this.location = location;
    this.startTime = start;
    this.endTime =  end;
    this.isRepeated = isRepeated;
    this.daysOfEvent = daysOfEvent;
  }


factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  Map<String, dynamic> toJson() => _$EventToJson(this);
  /*Event.fromJson(Map<String, dynamic> parsedJson) {
    title = parsedJson['title'];
    description = parsedJson['description'];
    location = parsedJson['location'];
    startTime = stringToTimeOfDay(parsedJson['start']);
    endTime = stringToTimeOfDay(parsedJson['end']);
    isRepeated = parsedJson['isRepeated'];
    var eventsFromJson = parsedJson['daysOfEvent'];
    daysOfEvent = List<int>.from(eventsFromJson);
  }
  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'location': location,
        'start': timeOfDatToDateTime(startTime),
        'end': timeOfDatToDateTime(endTime),
        'isRepeated': isRepeated,
        'daysOfEvent': daysOfEvent
      };*/

  List<int> get getDaysOfEvent => daysOfEvent;

  void addDayOfEvent(int dayOfWeek) {
    if (dayOfWeek < 1 || dayOfWeek > 7) {
      print("Day of Week must be integer from 1 to 7");
    } else if (daysOfEvent.contains(dayOfWeek)) {
      print("List already contains that day");
    } else {
      daysOfEvent.add(dayOfWeek);
    }
  }
}
