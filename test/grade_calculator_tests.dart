import 'package:cognito/models/Category.dart';
/// Tester file for GradeCalculator class
import 'package:test/test.dart';
import 'package:cognito/models/grade_calculator.dart';
import 'package:cognito/models/assignment.dart';

void main() {
  test("Grade Calculator Constructor Tests", () {
    GradeCalculator testGradeCalculator = GradeCalculator();
    expect(testGradeCalculator.percentage, equals(0.0));
  });

  test("Grade Calculator Usage Tests", () {
    GradeCalculator testGradeCalculator = GradeCalculator();

    testGradeCalculator.addCategory(Category(
      title: "Homework", 
      weightInPercentage: 30.0));

    testGradeCalculator.addCategory(Category(
      title: "Midterm",
      weightInPercentage: 30.0));

    testGradeCalculator.addCategory(Category(
      title: "Final",
      weightInPercentage: 40.0));

    Assignment hw1 = Assignment(
      title: "hw1",
      pointsEarned: 100.0,
      pointsPossible: 100.0
    );

    Assignment hw2 = Assignment(
      title: "hw2",
      pointsEarned: 100.0,
      pointsPossible: 100.0
    );

    Assignment hw3 = Assignment(
        title: "hw3",
        pointsEarned: 94.0,
        pointsPossible: 100.0
    );

    Assignment hw4 = Assignment(
        title: "hw4",
        pointsEarned: 97.0,
        pointsPossible: 100.0
    );

    Assignment hw5 = Assignment(
        title: "hw5",
        pointsEarned: 106.0,
        pointsPossible: 100.0
    );

    Assignment midterm = Assignment(
      title: "midterm",
      pointsEarned: 72.0,
      pointsPossible: 100.0,
      isAssessment: true
    );

    Assignment finalExam = Assignment(
      title: "final",
      pointsEarned: 97.0,
      pointsPossible: 100.0
    );

    testGradeCalculator.addGrade(hw1, testGradeCalculator.categories[0]);
    testGradeCalculator.addGrade(hw2, testGradeCalculator.categories[0]);
    testGradeCalculator.addGrade(hw3, testGradeCalculator.categories[0]);
    testGradeCalculator.addGrade(hw4, testGradeCalculator.categories[0]);
    testGradeCalculator.addGrade(hw5, testGradeCalculator.categories[0]);

    testGradeCalculator.addGrade(midterm, testGradeCalculator.categories[1]);
    testGradeCalculator.addGrade(finalExam, testGradeCalculator.categories[2]);

    testGradeCalculator.calculateGrade();

    print(testGradeCalculator.categories[0].title);
    print(testGradeCalculator.categories[1].title);
    print(testGradeCalculator.categories[2].title);
    print(testGradeCalculator.percentage);

    expect(testGradeCalculator.letterGrade, equals("A-"));
    expect(testGradeCalculator.percentage, equals(90.22));
  });
}