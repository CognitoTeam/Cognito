/// Tester file for Task class
import 'package:test/test.dart';
import 'package:cognito/models/task.dart';

void main() {
  test("Task Constructor Tests", () {
    Task testTask = Task(
      title: "CS 160 - Project Update",
      description: "Second project update",
      start: DateTime(2018, 9, 24, 10),
      end: DateTime(2018, 9, 24, 12),
      dueDate: DateTime(2018, 9, 25, 23, 59)
    );

    expect("CS 160 - Project Update", equals(testTask.title));
    expect("Second project update", equals(testTask.description));
    expect("", equals(testTask.location));
    expect(DateTime(2018, 9, 24, 12), equals(testTask.timeBlock[DateTime(2018, 9, 24, 10)]));
    expect(DateTime(2018, 9, 25, 23, 59), equals(testTask.dueDate));
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
    expect(1, equals(testTask.subTasks.length));
    expect("Test Subtask", equals(testTask.subTasks[0].title));
    expect(DateTime(2018, 9, 25, 23, 59), equals(testTask.subTasks[0].dueDate));
    
    Task testSubSubTask = Task(
      title: "Test Subsubtask",
      dueDate: DateTime(2018, 9, 25, 23, 59),
    );
    
    testSubTask.addSubTask(testSubSubTask);
    expect(1, equals(testTask.subTasks.length));
    expect(1, equals(testTask.subTasks[0].subTasks.length));
    expect("Test Subsubtask", equals(testTask.subTasks[0].subTasks[0].title));
    expect(DateTime(2018, 9, 25, 23, 59), equals(testTask.subTasks[0].subTasks[0].dueDate));
  });
}