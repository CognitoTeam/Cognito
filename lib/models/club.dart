/// Models a club
/// @author Julian Vu
import 'package:cognito/models/event.dart';
import 'package:cognito/models/officer.dart';
import 'package:cognito/models/task.dart';
import 'package:json_annotation/json_annotation.dart';

part 'club.g.dart';

@JsonSerializable()

class Club extends Event {
  List<Officer> officers;
  List<Event> events;
  List<Task> tasks;

  Club(
      {String title,
      String description = "",
      String location = "",
      DateTime start,
      DateTime end,
      int id})
      : super(
            title: title,
            description: description,
            location: location,
            start: start,
            end: end,
            id: id) {
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
  void addOfficer(Officer officer) {
    officers.add(officer);
  }
  /// Adds a task to list of tasks
  void addTask(Task task) {
    tasks.add(task);
  }
}
