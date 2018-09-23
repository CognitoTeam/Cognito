import 'package:cognito/models/event.dart';
/// Models a task
/// @author Julian Vu
///
class Task extends Event {
  DateTime dueDate;
  List<Task> subTasks;

  Task(
      {String title,
        String description = "",
        String location = "",
        DateTime start,
        DateTime end,
        DateTime dueDate}) : super(
    title: title,
    description: description,
    location: location,
    start: start,
    end: end,
  ) {
    this.dueDate = dueDate;
    subTasks = List();
  }

  /// Add subtask to list of subtasks
  addSubTask(Task subTask) => subTasks.add(subTask);
}