import 'package:cognito/models/category.dart';
import 'package:cognito/models/assignment.dart';
import 'package:cognito/models/event.dart';
import 'package:cognito/models/grade_calculator.dart';
import 'package:cognito/models/task.dart';
import 'package:json_annotation/json_annotation.dart';

part 'class.g.dart';

@JsonSerializable()

/// Class extends event class
/// @author Praneet Singh

class Class extends Event {
  final String ASSIGNMENTTAG = "assignment";
  final String ASSESSMENTTAG = "assessment";
  final String TASKTAG = "task";
  String subjectArea, courseNumber, instructor, officeLocation;
  int units;
  Map<String, List<DateTime>> officeHours;
  List<Category> categories;
  @JsonKey(ignore: true)
  GradeCalculator gradeCalculator;
  
  Map<String, List<Task>> todo;

  Class(
      {String title,
      String description = "",
      String location = "",
      DateTime start,
      DateTime end,
      String courseNumber,
      String instructor,
      String officeLocation,
      String subjectArea,
      int units,
      List<int> daysOfEvent})
      : super(
          title: title,
          description: description,
          location: location,
          start: start,
          end: end,
          isRepeated: true,
          daysOfEvent: daysOfEvent
        ) {
    this.courseNumber = courseNumber;
    this.instructor = instructor;
    this.officeLocation = officeLocation;
    this.subjectArea = subjectArea;
    this.units = units;
    officeHours = Map();
    gradeCalculator = GradeCalculator();
    todo = Map();
    categories = List();
  }
  factory Class.fromJson(Map<String, dynamic> json) => _$ClassFromJson(json);

  Map<String, dynamic> toJson() => _$ClassToJson(this);

  ///
  ///adds office hours to a class
  addOfficeHours(DateTime start, DateTime end) {
    List<DateTime> temp = [start, end];
    officeHours[(officeHours.length+1).toString()] = temp;
  }
addCategory(Category category) {
    categories.add(category);
  }
  ///
  ///Based on the key passed in addTodoItem will add
  ///A new task, assignment or assessment to its
  ///specific List
  addTodoItem(String key,
      {Task task, Assignment assignment}) {
    switch (key) {
      case "task":
        if (todo.containsKey(key)) {
          todo[key].add(task);
        } else {
          List<Task> tsk = List();
          tsk.add(task);
          todo[key] = tsk;
        }
        break;

      case "assignment":
        if (todo.containsKey(key)) {
          todo[key].add(assignment);
        } else {
          List<Assignment> assign = List();
          assign.add(assignment);
          todo[key] = assign;
        }
        print("Added a assignment to the class");
        if (!gradeCalculator.categories.contains(assignment.category)) {
          gradeCalculator.addCategory(assignment.category);
        }
        gradeCalculator.addGrade(assignment, assignment.category);
        break;

      case "assessment":
        if (todo.containsKey(key)) {
          todo[key].add(assignment);
        } else {
          List<Assignment> assment = List();
          assment.add(assignment);
          todo[key] = assment;
        }
        print("Added a assessment to the class");

        if (!gradeCalculator.categories.contains(assignment.category)) {
          gradeCalculator.addCategory(assignment.category);
        }
        gradeCalculator.addGrade(assignment, assignment.category);
        break;

      default:
        print("Invalid key");
    }
  }

  @override
  String toString() {
    return "Title: " + this.title + "\n";
  }


}
