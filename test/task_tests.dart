/// Tester file for Task class
import 'package:test/test.dart';
import 'package:cognito/models/task.dart';
void main() {
  test("Task Constructor Tests", () {
    Task testTask = Task(
      title: "CS 160 - Project Update",
      description: "Second project update",
      start: DateTime(2018, 0, 0, 11, 44),
      end: DateTime(2018, 0, 0, 11, 55),
      dueDate: DateTime(2018, 9, 25, 23, 59)
    );

    expect(testTask.title, equals("CS 160 - Project Update"));
    expect(testTask.description, equals("Second project update"));
    expect(testTask.location, equals(""));
    expect(testTask.dueDate, equals(DateTime(2018, 9, 25, 23, 59)));
  });

  test("Task Json Tests", () {
    Task testTask = Task(
      title: "CS 160 - Project Update",
      description: "Second project update",
      start: DateTime.now(),
      end: DateTime.now(),
      isRepeated: false,
      daysOfEvent: [1,2,3],
      dueDate: DateTime(2018, 9, 25, 23, 59)
    );
    Task testSubTask = Task(
      title: "Test Subtask",
      dueDate: DateTime(2018, 9, 25, 23, 59)
    );

    expect(testTask.title, equals("CS 160 - Project Update"));
    expect(testTask.description, equals("Second project update"));
    expect(testTask.location, equals(""));
    expect(testTask.dueDate, equals(DateTime(2018, 9, 25, 23, 59)));
  });

  test("Task addSubTask Tests", () {
    Task testTask = Task(
      title: "Test Task",
      dueDate: DateTime(2018, 9, 25, 23, 59)
    );

    Task testSubTask = Task(
      title: "Test Subtask",
      dueDate: DateTime(2018, 9, 25, 23, 59)
    );

    testTask.addSubTask(testSubTask);
    expect(testTask.subTasks.length, equals(1));
    expect(testTask.subTasks[0].title, equals("Test Subtask"));
    expect(testTask.subTasks[0].dueDate, equals(DateTime(2018, 9, 25, 23, 59)));
    
    Task testSubSubTask = Task(
      title: "Test Subsubtask",
      dueDate: DateTime(2018, 9, 25, 23, 59),
    );
    
    testSubTask.addSubTask(testSubSubTask);
    expect(testTask.subTasks.length, equals(1));
    expect(testTask.subTasks[0].subTasks.length, equals(1));
    expect(testTask.subTasks[0].subTasks[0].title, equals("Test Subsubtask"));
    expect(testTask.subTasks[0].subTasks[0].dueDate, equals(DateTime(2018, 9, 25, 23, 59)));
  });
}