// Copyright 2019 UniPlan. All rights reserved.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cognito/database/database.dart';
import 'package:cognito/models/assignment.dart';
import 'package:cognito/models/category.dart';
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
  List<Assignment> assignments;
  List<Assignment> assessments;
  List<Task> tasks;
  Category starting;

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
      List<int> daysOfEvent,
      int id})
      : super(
            title: title,
            description: description,
            location: location,
            start: start,
            end: end,
            isRepeated: true,
            daysOfEvent: daysOfEvent,
            id: id) {
    this.courseNumber = courseNumber;
    this.instructor = instructor;
    this.officeLocation = officeLocation;
    this.subjectArea = subjectArea;
    this.units = units;
    officeHours = Map();
    categories = List();
    assessments = List();
    assignments = List();
    tasks = List();
    starting = Category(title: "Default", weightInPercentage: 100.0);
  }
  factory Class.fromJson(Map<String, dynamic> json) => _$ClassFromJson(json);

  Map<String, dynamic> toJson() => _$ClassToJson(this);

  ///
  ///adds office hours to a class
  addOfficeHours(DateTime start, DateTime end) {
    List<DateTime> temp = [start, end];
    officeHours[(officeHours.length + 1).toString()] = temp;
  }

  String getGrade(assessments, assignments, categories) {
    Map<Assignment, Category> gradebook = Map();
    for (Assignment a in assessments) {
      gradebook[a] = a.category;
    }
    for (Assignment a in assignments) {
      gradebook[a] = a.category;
    }
    if (gradebook.isEmpty) {
      return "No Grades yet";
    }
    List<Category> cat = List();
    for (Category c in categories) {
      cat.add(c);
    }
    //Need all categories and the assignments with categories
    GradeCalculator gradeCalculator = GradeCalculator(cat, gradebook);
    gradeCalculator.calculateGrade();
    return gradeCalculator.letterGrade;
  }

  addCategory(Category category) {
    if (starting.weightInPercentage < category.weightInPercentage) {
      throw Exception("Error categories more than 100%");
    } else {
      starting.weightInPercentage -= category.weightInPercentage;
      categories.add(category);
    }
  }

  deleteCategory(Category categoryToDelete) {
    starting.weightInPercentage += categoryToDelete.weightInPercentage;
    categories.remove(categoryToDelete);
  }

  ///
  ///Based on the key passed in addTodoItem will add
  ///A new task, assignment or assessment to its
  ///specific List
  addTodoItem(String key, {Task task, Assignment assignment}) {
    switch (key) {
      case "task":
        tasks.add(task);
        break;

      case "assignment":
        assignments.add(assignment);
        break;

      case "assessment":
        assessments.add(assignment);
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
