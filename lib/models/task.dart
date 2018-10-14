import 'package:cognito/models/event.dart';
/// Models a task
/// @author Julian Vu
import 'package:json_annotation/json_annotation.dart';

part 'task.g.dart';

@JsonSerializable()

class Task extends Event {
  DateTime dueDate;
  List<Task> subTasks;

  Task(
      {String title,
      String description = "",
      String location = "",
      DateTime start,
      DateTime end,
      bool isRepeated,
      List<int> daysOfEvent,
      DateTime dueDate})
      : super(
            title: title,
            description: description,
            location: location,
            start: start,
            end: end,
            isRepeated: isRepeated,
            daysOfEvent: daysOfEvent) {
    this.dueDate = dueDate;
    subTasks = List();
  }
factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);


  Map<String, dynamic> toJson() => _$TaskToJson(this);
  /*Task.fromJson(Map<String, dynamic> parsedJson) {
    title = parsedJson['title'];
    description = parsedJson['description'];
    location = parsedJson['location'];
    startTime = timeOfDateToDate(parsedJson['start']);
    endTime = timeOfDateToDate(parsedJson['end']);
    isRepeated = parsedJson['isRepeated'];
    var eventsFromJson = parsedJson['daysOfEvent'];
    daysOfEvent = List<int>.from(eventsFromJson);
    dueDate = DateTime.parse(parsedJson['dueDate']);
    var tasksFromJson = parsedJson['subTasks'];
    subTasks = List<Task>.from(tasksFromJson);
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'location': location,
        'start': timeOfDatToDateTime(startTime),
        'end': timeOfDatToDateTime(endTime),
        'isRepeated': isRepeated,
        'daysOfEvent': daysOfEvent,
        'dueDate': dueDate.toIso8601String(),
        'subTasks': subTasks
      };*/

  /// Add subtask to list of subtasks
  addSubTask(Task subTask) => subTasks.add(subTask);
}
