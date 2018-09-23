import 'package:cognito/models/event.dart';

/// Class extends event class
/// @author Praneet Singh

class Class extends Event {
  String subjectArea, courseNumber, instructor, officeLocation;
  int units;
  Map<DateTime, DateTime> officeHours;
  //GradeCalculator gradeCalculator;
  //Map<String, List<Task>> todo;

  Class ({String title, String description, String location, DateTime start, DateTime end, 
  String courseNumber, String instructor, String officeLocation, String subjectArea, int units}):
  super(title, description, location, start, end){
    this.courseNumber = courseNumber;
    this.instructor = instructor;
    this.officeLocation = officeLocation;
    this.subjectArea = subjectArea;
    this.units = units;
    officeHours = Map();
  }

  addOfficeHours(DateTime start, DateTime end){
        officeHours[start] = end;
  }
}