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
    expect("Test Class title", equals(testClass.title));
    expect("This is a test", equals(testClass.description));
    expect("Test location", testClass.location);
    expect("146", testClass.courseNumber);
    expect("Test instructor", testClass.instructor);
    expect("Test location", testClass.location);
    expect("Computer Science", testClass.subjectArea);

    testClass.officeHours.clear();
    expect(0, testClass.officeHours.length);

    testClass.addOfficeHours(DateTime(1997), DateTime(2018));
    expect(1, testClass.officeHours.length);
    
  });
}