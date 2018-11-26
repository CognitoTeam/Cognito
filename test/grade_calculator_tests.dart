/// Tester file for GradeCalculator class
import 'package:cognito/models/category.dart';
import 'package:cognito/models/class.dart';
import 'package:test/test.dart';
import 'package:cognito/models/grade_calculator.dart';
import 'package:cognito/models/assignment.dart';

void main() {
  test("Grade Calculator Constructor Tests", () {
    Map<Assignment, Category> gradebook = Map();
    List<Category> categories = List();
    GradeCalculator testGradeCalculator =
        GradeCalculator(categories, gradebook);
    expect(testGradeCalculator.percentage, equals(0.0));
  });

  test("Grade Calculator Usage Tests", () {
    Map<Assignment, Category> gradebook = Map();
    List<Category> categories = List();
    Category homwework = Category(title: "Homework", weightInPercentage: 30.0);
    categories.add(homwework);
    Category midterm = Category(title: "Midterm", weightInPercentage: 30.0);
    categories.add(midterm);

    Category finalExam = Category(title: "Final", weightInPercentage: 40.0);
    categories.add(finalExam);

    Assignment hw1 =
        Assignment(title: "hw1", pointsEarned: 100.0, pointsPossible: 100.0);
    hw1.category = homwework;

    Assignment hw2 =
        Assignment(title: "hw2", pointsEarned: 100.0, pointsPossible: 100.0);
    hw2.category = homwework;
    Assignment hw3 =
        Assignment(title: "hw3", pointsEarned: 94.0, pointsPossible: 100.0);
    hw3.category = homwework;
    Assignment hw4 =
        Assignment(title: "hw4", pointsEarned: 97.0, pointsPossible: 100.0);
    hw4.category = homwework;
    Assignment hw5 =
        Assignment(title: "hw5", pointsEarned: 106.0, pointsPossible: 100.0);
    hw5.category = homwework;
    Assignment midtermExam = Assignment(
        title: "midterm",
        pointsEarned: 72.0,
        pointsPossible: 100.0,
        isAssessment: true);
    midtermExam.category = midterm;
    Assignment finalExam1 = Assignment(
        title: "final",
        pointsEarned: 97.0,
        pointsPossible: 100.0,
        isAssessment: true);
    finalExam1.category = finalExam;

    gradebook[hw1] = hw1.category;
    gradebook[hw2] = hw2.category;
    gradebook[hw3] = hw3.category;
    gradebook[hw4] = hw4.category;
    gradebook[hw5] = hw5.category;
    gradebook[midtermExam] = midtermExam.category;
    gradebook[finalExam1] = finalExam1.category;

    GradeCalculator testGradeCalculator =
        GradeCalculator(categories, gradebook);

    testGradeCalculator.calculateGrade();

    print(testGradeCalculator.categories[0].title);
    print(testGradeCalculator.categories[1].title);
    print(testGradeCalculator.categories[2].title);
    print(testGradeCalculator.percentage);

    expect(testGradeCalculator.letterGrade, equals("A-"));
    expect(testGradeCalculator.percentage, equals(90.22));
    Class c1 = Class(
      title: "Software",
    );
    c1.addCategory(homwework);
    c1.addCategory(midterm);
    c1.addCategory(finalExam);

    c1.addTodoItem(c1.ASSIGNMENTTAG, assignment: hw1);
    c1.addTodoItem(c1.ASSIGNMENTTAG, assignment: hw2);
    c1.addTodoItem(c1.ASSIGNMENTTAG, assignment: hw3);
    c1.addTodoItem(c1.ASSIGNMENTTAG, assignment: hw4);
    c1.addTodoItem(c1.ASSIGNMENTTAG, assignment: hw5);
    c1.addTodoItem(c1.ASSESSMENTTAG, assignment: midtermExam);
    c1.addTodoItem(c1.ASSESSMENTTAG, assignment: finalExam1);
    print(c1.getGrade());
  });
}
