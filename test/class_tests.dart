///Tester for Class class
import 'package:test/test.dart';
import 'package:cognito/models/class.dart';

void main(){
  test("Class Constructor Tests", (){
    Class testClass = Class(
      title: "Test Class title",
      description: "This is a test", 
      location: "Test location",
      start: DateTime.now(),
      end: DateTime(2018, 12, 12), 
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

    testClass.officeHours.clear();
    expect(testClass.officeHours.length, equals(0));

    testClass.addOfficeHours(DateTime(1997), DateTime(2018));
    expect(testClass.officeHours.length, equals(1));
    
  });
}