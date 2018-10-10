import 'package:cognito/models/assignment.dart';
import 'package:cognito/models/grade_calculator.dart';
///Tester for Class class
import 'package:test/test.dart';
import 'package:cognito/models/class.dart';
import 'package:cognito/models/task.dart';
import 'package:flutter/material.dart';

void main(){
  test("Class Constructor Tests", (){
    Class testClass = Class(
      title: "Test Class title",
      description: "This is a test", 
      location: "Test location",
      start: TimeOfDay.now(),
      end: TimeOfDay(hour: 11, minute: 59),
      courseNumber: "146",
      instructor: "Test instructor",
      officeLocation: "Test location",
      subjectArea: "Computer Science",
      units: 3
    );
    expect(testClass.title, equals("Test Class title"));
    expect(testClass.description, equals("This is a test"));
    expect(testClass.location, equals("Test location"));
    expect(testClass.courseNumber, equals("146"));
    expect(testClass.instructor, equals("Test instructor"));
    expect(testClass.location, equals("Test location"));
    expect(testClass.subjectArea, equals("Computer Science"));
    expect(testClass.units, equals(3));
  });

  test("Test addOfficeHours", (){
    Class testClass1 = Class(
      title: "Test map",
      courseNumber: "146",
      instructor: "Test instructor",
      officeLocation: "Test location",
      subjectArea: "Computer Science",
      units: 3
    );
    testClass1.officeHours.clear();
    expect(testClass1.officeHours.length, equals(0));

    testClass1.addOfficeHours(DateTime(1997), DateTime(2018));
    expect(testClass1.officeHours.length, equals(1));
  });

  test("Test optional arguments constuctor", (){
    Class testClass2 = Class(
      title: "Test optional constructor",
      start: TimeOfDay.now(),
      end: TimeOfDay(hour: 11, minute: 59),
      courseNumber: "146",
      instructor: "Test instructor",
      officeLocation: "San Jose",
      subjectArea: "Computer Science",
      units: 3
    );
    expect(testClass2.title, equals("Test optional constructor"));
    expect(testClass2.description, equals(""));
    expect(testClass2.location, equals(""));
    expect(testClass2.courseNumber, equals("146"));
    expect(testClass2.instructor, equals("Test instructor"));

  });

  test("Test todo list Assigment", (){
    Class testClass3 = Class(
      title: "Test todo list Assigment", 
      courseNumber: "146",
      instructor: "Test instructor",
      officeLocation: "San Jose",
      subjectArea: "Computer Science",
      units: 3
    );
    String key = "assignment";
    Assignment assignTest = Assignment();
    Assignment assignTest1 = Assignment();
    testClass3.addTodoItem(key, assignment: assignTest);
    expect(testClass3.todo[key].length, equals(1));

    testClass3.addTodoItem(key, assignment: assignTest1);
    expect(testClass3.todo[key].length, equals(2));
  });

  test("Test todo list Task", (){
    Class testClass4 = Class(
      title: "Test todo list task", 
      courseNumber: "146",
      instructor: "Test instructor",
      officeLocation: "San Jose",
      subjectArea: "Computer Science",
      units: 3
    );
    String key = "task";
    Task taskTest = Task();
     Task taskTest1 = Task();
    testClass4.addTodoItem(key, task: taskTest);
    expect(testClass4.todo[key].length, equals(1));

    testClass4.addTodoItem(key, task: taskTest1);
    expect(testClass4.todo[key].length, equals(2));
  });

  test("Test todo list Assessment", (){
    Class testClass5 = Class(
      title: "Test todo list Assessment", 
      courseNumber: "146",
      instructor: "Test instructor",
      officeLocation: "San Jose",
      subjectArea: "Computer Science",
      units: 3
    );
    String key = "assessment";
    Assignment assignTest = Assignment(isAssessment: true);
    Assignment assignTest1 = Assignment(isAssessment: true);
    testClass5.addTodoItem(key, assignment: assignTest);
    expect(testClass5.todo[key].length, equals(1));

    testClass5.addTodoItem(key, assignment: assignTest1);
    expect(testClass5.todo[key].length, equals(2));
  });

  test("Adding todo item with category", (){
    Class testClass6 = Class(
      title: "Test assessment with category", 
      courseNumber: "146",
      instructor: "Test instructor",
      officeLocation: "San Jose",
      subjectArea: "Computer Science",
      units: 3
    );
    String key = "assessment";
    Category category = Category(title: "Homework", weightInPercentage: 0.20);
    Assignment assignTest = Assignment(isAssessment: true);
    //Assignment assignTest1 = Assignment(isAssessment: true);
    testClass6.gradeCalculator.addCategory(category);
    testClass6.addTodoItem(key, assignment: assignTest, category: category);
    expect(testClass6.gradeCalculator.gradeBook.length, equals(1));
  });
}
