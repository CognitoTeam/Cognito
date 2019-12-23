import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cognito/models/event.dart';

/// Models a task
/// @author Julian Vu
import 'package:json_annotation/json_annotation.dart';


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
      DateTime dueDate,
      String id,
      int priority = 1,
      Duration duration})
      : super(
            title: title,
            description: description,
            location: location,
            start: start,
            end: end,
            isRepeated: isRepeated,
            daysOfEvent: daysOfEvent,
            id: id, 
            priority: priority,
            duration: duration) {
    this.dueDate = dueDate;
    subTasks = List();
  }

  factory Task.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    List<int> list = List();
    data['days_of_event'].forEach((item) => list.add(item));
    Task t = Task(
      id: doc.documentID,
      title: data['title'],
      location: data['location'],
      description: data['description'],
      isRepeated: data['repeated'],
      dueDate: data['due_date'].toDate(),
      daysOfEvent: list,
      priority: data['priority'],
      duration: Duration(minutes: data['duration_in_minutes']),
    );
    return t;
  }

  /// Add subtask to list of subtasks
  addSubTask(Task subTask) => subTasks.add(subTask);

}
