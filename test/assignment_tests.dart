/// Tester file for Assignment class
import 'package:test/test.dart';
import 'package:cognito/models/assignment.dart';

void main() {
  test("Assignment Constructor Tests", () {
    Assignment testAssignment = Assignment(
      title: "CS 160 - Project Update",
      description: "Second project update",
      dueDate: DateTime(2018, 9, 25, 23, 59),
      pointsEarned: 9.0,
      pointsPossible: 10.0
    );

    expect(testAssignment.title, equals("CS 160 - Project Update"));
    expect(testAssignment.description, equals("Second project update"));
    expect(testAssignment.dueDate, equals(DateTime(2018, 9, 25, 23, 59)));
    expect(testAssignment.pointsPossible, equals(10.0));
    expect(testAssignment.pointsEarned, equals(9.0));
    expect(testAssignment.rawScore, equals(0.9));

    Assignment testAssignment2 = Assignment(
      title: "CS 160 - Project Update",
      description: "Second project update",
      dueDate: DateTime(2018, 9, 25, 23, 59),
    );
    
    expect(testAssignment2.pointsPossible, equals(0.0));
    expect(testAssignment2.pointsEarned, equals(0.0));

    testAssignment2.pointsPossible = 10.0;
    testAssignment2.pointsEarned = 5.0;
    expect(testAssignment2.rawScore, equals(0.5));
  });
}