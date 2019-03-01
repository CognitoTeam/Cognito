/// Models an event on a schedule
/// 
//import 'package:json_serializable/json_serializable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event.g.dart';

@JsonSerializable()

class Event {
  /// Instance variables
  String title, description, location;
  DateTime startTime, endTime;
  bool isRepeated;
  int id;

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
      List<int> daysOfEvent,
      int id}) {
    this.title = title;
    this.description = description;
    this.location = location;
    this.startTime = start;
    this.endTime =  end;
    this.isRepeated = isRepeated;
    this.daysOfEvent = daysOfEvent;
    this.id =id;
  }


factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  Map<String, dynamic> toJson() => _$EventToJson(this);
 
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
