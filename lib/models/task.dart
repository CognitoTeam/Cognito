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
  /// Add subtask to list of subtasks
  addSubTask(Task subTask) => subTasks.add(subTask);
}
