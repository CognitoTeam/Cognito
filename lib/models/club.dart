/// Models a club
/// @author Julian Vu
import 'package:cognito/models/event.dart';
import 'package:cognito/models/task.dart';
import 'package:json_annotation/json_annotation.dart';

part 'club.g.dart';

@JsonSerializable()

class Club extends Event {
  List<String> officers;
  List<Event> events;
  List<Task> tasks;

  Club(
      {String title,
      String description = "",
      String location = "",
      DateTime start,
      DateTime end})
      : super(
            title: title,
            description: description,
            location: location,
            start: start,
            end: end) {
    officers = List();
    events = List();
    tasks = List();
  }
factory Club.fromJson(Map<String, dynamic> json) => _$ClubFromJson(json);

  Map<String, dynamic> toJson() => _$ClubToJson(this);
  /// Adds a club event to list of events
  void addEvent(Event event) {
    events.add(event);
  }

  /// Adds an officer to list of officers
  void addOfficer(String name) {
    officers.add(name);
  }
  /// Adds a task to list of tasks
  void addTask(Task task) {
    tasks.add(task);
  }
}
