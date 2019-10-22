import 'package:cognito/models/category.dart';
import 'package:cognito/models/academic_term.dart';
import 'package:cognito/models/assignment.dart';
import 'package:cognito/models/class.dart';
import 'package:cognito/models/gpa_calculator.dart';
import 'package:test/test.dart';

void main() {
  test("Test GPA", () {
    AcademicTerm term =
        AcademicTerm(termName: "Spring 2018", startTime: DateTime(2018), endTime: DateTime(2019));
    Class class1 = Class(
        subjectArea: "CS", courseNumber: "160", location: "SJSU", units: 4);
    Class class2 = Class(
        subjectArea: "CS", courseNumber: "157A", location: "SJSU", units: 3);
    Class class3 = Class(
        subjectArea: "CS", courseNumber: "175", location: "SJSU", units: 4);
    Class class4 = Class(
        subjectArea: "CS", courseNumber: "152", location: "SJSU", units: 3);

    Assignment hw1 =
        Assignment(title: "hw1", pointsEarned: 0.0, pointsPossible: 100.0);

    Assignment hw2 =
        Assignment(title: "hw2", pointsEarned: 100.0, pointsPossible: 100.0);

    Assignment hw3 =
        Assignment(title: "hw3", pointsEarned: 94.0, pointsPossible: 100.0);

    Assignment hw4 =
        Assignment(title: "hw4", pointsEarned: 97.0, pointsPossible: 100.0);

    Assignment hw5 =
        Assignment(title: "hw5", pointsEarned: 100.0, pointsPossible: 100.0);

    Assignment midterm = Assignment(
        title: "midterm",
        pointsEarned: 72.0,
        pointsPossible: 100.0,
        isAssessment: true);

    Assignment finalExam =
        Assignment(title: "final", pointsEarned: 97.0, pointsPossible: 100.0);

    Category homework = Category(title: "Homework", weightInPercentage: 30.0);

    Category exam1 = Category(title: "Midterm", weightInPercentage: 30.0);

    Category exam2 = Category(title: "Final", weightInPercentage: 40.0);

    GPACalculator gp = GPACalculator();
    class1.addCategory(homework);
    class1.addCategory(exam1);
    class1.addCategory(exam2);
    hw1.category = homework;
    hw2.category = homework;
    hw3.category = homework;
    hw4.category = homework;
    hw5.category = homework;
    midterm.category = exam1;
    finalExam.category = exam2;
    class1.addTodoItem("assignment", assignment: hw1);
    class1.addTodoItem("assignment", assignment: hw2);
    class1.addTodoItem("assignment", assignment: hw3);
    class1.addTodoItem("assignment", assignment: hw4);
    class1.addTodoItem("assignment", assignment: hw5);
    class1.addTodoItem("assessment", assignment: midterm);
    class1.addTodoItem("assessment", assignment: finalExam);

    class2.addCategory(homework);
    class2.addCategory(exam1);
    class2.addCategory(exam2);
    class2.addTodoItem("assignment", assignment: hw1);
    class2.addTodoItem("assignment", assignment: hw2);
    class2.addTodoItem("assignment", assignment: hw3);
    class2.addTodoItem("assignment", assignment: hw4);
    class2.addTodoItem("assignment", assignment: hw5);
    class2.addTodoItem("assessment", assignment: midterm);
    class2.addTodoItem("assessment", assignment: finalExam);

    class3.addCategory(homework);
    class3.addCategory(exam1);
    class3.addCategory(exam2);
    class3.addTodoItem("assignment", assignment: hw1);
    class3.addTodoItem("assignment", assignment: hw2);
    hw3.category = exam1;
    class3.addTodoItem("assignment", assignment: hw3);
    class3.addTodoItem("assignment", assignment: hw4);
    class3.addTodoItem("assignment", assignment: hw5);
    class3.addTodoItem("assessment", assignment: midterm);
    class3.addTodoItem("assessment", assignment: finalExam);

    class4.addCategory(homework);
    class4.addCategory(exam1);
    class4.addCategory(exam2);
    hw1.category = exam1;
    hw3.category = homework;
    class4.addTodoItem("assignment", assignment: hw1);
    class4.addTodoItem("assignment", assignment: hw2);
    class4.addTodoItem("assignment", assignment: hw3);
    class4.addTodoItem("assignment", assignment: hw4);
    class4.addTodoItem("assignment", assignment: hw5);
    class4.addTodoItem("assessment", assignment: midterm);
    class4.addTodoItem("assessment", assignment: finalExam);

    term.addClass(class1);
    term.addClass(class2);
    term.addClass(class3);
    term.addClass(class4);

    gp.calculateTermGPA(term);
    AcademicTerm term1 =
        AcademicTerm(termName: "Spring 2018", startTime: DateTime(2018), endTime: DateTime(2019));
    Class class11 = Class(
        subjectArea: "CS", courseNumber: "160", location: "SJSU", units: 3);
    Class class21 = Class(
        subjectArea: "CS", courseNumber: "157A", location: "SJSU", units: 3);
    Class class31 = Class(
        subjectArea: "CS", courseNumber: "175", location: "SJSU", units: 3);
    Class class41 = Class(
        subjectArea: "CS", courseNumber: "152", location: "SJSU", units: 3);

    Assignment hw11 =
        Assignment(title: "hw1", pointsEarned: 100.0, pointsPossible: 100.0);

    Assignment hw21 =
        Assignment(title: "hw2", pointsEarned: 100.0, pointsPossible: 100.0);

    Assignment hw31 =
        Assignment(title: "hw3", pointsEarned: 94.0, pointsPossible: 100.0);

    Assignment hw41 =
        Assignment(title: "hw4", pointsEarned: 97.0, pointsPossible: 100.0);

    Assignment hw51 =
        Assignment(title: "hw5", pointsEarned: 90.0, pointsPossible: 100.0);

    Assignment midterm1 = Assignment(
        title: "midterm",
        pointsEarned: 72.0,
        pointsPossible: 100.0,
        isAssessment: true);

    Assignment finalExam1 =
        Assignment(title: "final", pointsEarned: 97.0, pointsPossible: 100.0);

    Category homework1 = Category(title: "Homework", weightInPercentage: 30.0);

    Category exam11 = Category(title: "Midterm", weightInPercentage: 30.0);

    Category exam21 = Category(title: "Final", weightInPercentage: 40.0);

    class11.addCategory(homework1);
    class11.addCategory(exam11);
    class11.addCategory(exam21);
    hw11.category = homework1;
    hw21.category = homework1;
    hw31.category = homework1;
    hw41.category = homework1;
    hw51.category = homework1;
    midterm1.category = exam11;
    finalExam1.category = exam21;
    class11.addTodoItem("assignment", assignment: hw11);
    class11.addTodoItem("assignment", assignment: hw21);
    class11.addTodoItem("assignment", assignment: hw31);
    class11.addTodoItem("assignment", assignment: hw41);
    class11.addTodoItem("assignment", assignment: hw51);
    class11.addTodoItem("assessment", assignment: midterm1);
    class11.addTodoItem("assessment", assignment: finalExam1);

    class21.addCategory(homework1);
    class21.addCategory(exam11);
    class21.addCategory(exam21);
    class21.addTodoItem("assignment", assignment: hw11);
    class21.addTodoItem("assignment", assignment: hw21);
    class21.addTodoItem("assignment", assignment: hw31);
    class21.addTodoItem("assignment", assignment: hw41);
    class21.addTodoItem("assignment", assignment: hw51);
    class21.addTodoItem("assessment", assignment: midterm1);
    class21.addTodoItem("assessment", assignment: finalExam1);

    class31.addCategory(homework1);
    class31.addCategory(exam11);
    class31.addCategory(exam21);
    hw31.category = exam11;
    class31.addTodoItem("assignment", assignment: hw11);
    class31.addTodoItem("assignment", assignment: hw21);
    class31.addTodoItem("assignment", assignment: hw31);
    class31.addTodoItem("assignment", assignment: hw41);
    class31.addTodoItem("assignment", assignment: hw51);
    class31.addTodoItem("assessment", assignment: midterm1);
    class31.addTodoItem("assessment", assignment: finalExam1);

    class41.addCategory(homework1);
    class41.addCategory(exam11);
    class41.addCategory(exam21);
    hw11.category = exam11;
    hw31.category = homework1;
    class41.addTodoItem("assignment", assignment: hw11);
    class41.addTodoItem("assignment", assignment: hw21);
    class41.addTodoItem("assignment", assignment: hw31);
    class41.addTodoItem("assignment", assignment: hw41);
    class41.addTodoItem("assignment", assignment: hw51);
    class41.addTodoItem("assessment", assignment: midterm1);
    class41.addTodoItem("assessment", assignment: finalExam1);

    term1.addClass(class11);
    term1.addClass(class21);
    term1.addClass(class31);
    term1.addClass(class41);

    gp.calculateTermGPA(term1);
    expect(gp.termsMap.length, equals(2));

    gp.calculateGPA();
    print(gp.gpa);
  });

  test("Test Term grade", () {
    AcademicTerm term =
        AcademicTerm(termName: "Spring 2018", startTime: DateTime(2018), endTime: DateTime(2019));
    Class class1 = Class(
        subjectArea: "CS", courseNumber: "160", location: "SJSU", units: 4);
    Class class2 = Class(
        subjectArea: "CS", courseNumber: "157A", location: "SJSU", units: 3);
    Class class3 = Class(
        subjectArea: "CS", courseNumber: "175", location: "SJSU", units: 4);
    Class class4 = Class(
        subjectArea: "CS", courseNumber: "152", location: "SJSU", units: 3);

    Assignment hw1 =
        Assignment(title: "hw1", pointsEarned: 0.0, pointsPossible: 100.0);

    Assignment hw2 =
        Assignment(title: "hw2", pointsEarned: 100.0, pointsPossible: 100.0);

    Assignment hw3 =
        Assignment(title: "hw3", pointsEarned: 94.0, pointsPossible: 100.0);

    Assignment hw4 =
        Assignment(title: "hw4", pointsEarned: 97.0, pointsPossible: 100.0);

    Assignment hw5 =
        Assignment(title: "hw5", pointsEarned: 100.0, pointsPossible: 100.0);

    Assignment midterm = Assignment(
        title: "midterm",
        pointsEarned: 72.0,
        pointsPossible: 100.0,
        isAssessment: true);

    Assignment finalExam =
        Assignment(title: "final", pointsEarned: 97.0, pointsPossible: 100.0);

    Category homework = Category(title: "Homework", weightInPercentage: 30.0);

    Category exam1 = Category(title: "Midterm", weightInPercentage: 30.0);

    Category exam2 = Category(title: "Final", weightInPercentage: 40.0);

    class1.addCategory(homework);
    class1.addCategory(exam1);
    class1.addCategory(exam2);
    hw1.category = homework;
    hw2.category = homework;
    hw3.category = homework;
    hw4.category = homework;
    hw5.category = homework;
    midterm.category = exam1;
    finalExam.category = exam2;
    class1.addTodoItem("assignment", assignment: hw1);
    class1.addTodoItem("assignment", assignment: hw2);
    class1.addTodoItem("assignment", assignment: hw3);
    class1.addTodoItem("assignment", assignment: hw4);
    class1.addTodoItem("assignment", assignment: hw5);
    class1.addTodoItem("assessment", assignment: midterm);
    class1.addTodoItem("assessment", assignment: finalExam);

    class2.addCategory(homework);
    class2.addCategory(exam1);
    class2.addCategory(exam2);
    class2.addTodoItem("assignment", assignment: hw1);
    class2.addTodoItem("assignment", assignment: hw2);
    class2.addTodoItem("assignment", assignment: hw3);
    class2.addTodoItem("assignment", assignment: hw4);
    class2.addTodoItem("assignment", assignment: hw5);
    class2.addTodoItem("assessment", assignment: midterm);
    class2.addTodoItem("assessment", assignment: finalExam);

    class3.addCategory(homework);
    class3.addCategory(exam1);
    class3.addCategory(exam2);
    class3.addTodoItem("assignment", assignment: hw1);
    class3.addTodoItem("assignment", assignment: hw2);
    hw3.category = exam1;
    class3.addTodoItem("assignment", assignment: hw3);
    class3.addTodoItem("assignment", assignment: hw4);
    class3.addTodoItem("assignment", assignment: hw5);
    class3.addTodoItem("assessment", assignment: midterm);
    class3.addTodoItem("assessment", assignment: finalExam);

    class4.addCategory(homework);
    class4.addCategory(exam1);
    class4.addCategory(exam2);
    hw1.category = exam1;
    hw3.category = homework;
    class4.addTodoItem("assignment", assignment: hw1);
    class4.addTodoItem("assignment", assignment: hw2);
    class4.addTodoItem("assignment", assignment: hw3);
    class4.addTodoItem("assignment", assignment: hw4);
    class4.addTodoItem("assignment", assignment: hw5);
    class4.addTodoItem("assessment", assignment: midterm);
    class4.addTodoItem("assessment", assignment: finalExam);

    term.addClass(class1);
    term.addClass(class2);
    term.addClass(class3);
    term.addClass(class4);

    AcademicTerm term1 =
        AcademicTerm(termName: "Spring 2018", startTime: DateTime(2018), endTime: DateTime(2019));
    Class class11 = Class(
        subjectArea: "CS", courseNumber: "160", location: "SJSU", units: 3);
    Class class21 = Class(
        subjectArea: "CS", courseNumber: "157A", location: "SJSU", units: 3);
    Class class31 = Class(
        subjectArea: "CS", courseNumber: "175", location: "SJSU", units: 3);
    Class class41 = Class(
        subjectArea: "CS", courseNumber: "152", location: "SJSU", units: 3);

    Assignment hw11 =
        Assignment(title: "hw1", pointsEarned: 100.0, pointsPossible: 100.0);

    Assignment hw21 =
        Assignment(title: "hw2", pointsEarned: 100.0, pointsPossible: 100.0);

    Assignment hw31 =
        Assignment(title: "hw3", pointsEarned: 94.0, pointsPossible: 100.0);

    Assignment hw41 =
        Assignment(title: "hw4", pointsEarned: 97.0, pointsPossible: 100.0);

    Assignment hw51 =
        Assignment(title: "hw5", pointsEarned: 90.0, pointsPossible: 100.0);

    Assignment midterm1 = Assignment(
        title: "midterm",
        pointsEarned: 72.0,
        pointsPossible: 100.0,
        isAssessment: true);

    Assignment finalExam1 =
        Assignment(title: "final", pointsEarned: 97.0, pointsPossible: 100.0);

    Category homework1 = Category(title: "Homework", weightInPercentage: 30.0);

    Category exam11 = Category(title: "Midterm", weightInPercentage: 30.0);

    Category exam21 = Category(title: "Final", weightInPercentage: 40.0);

    class11.addCategory(homework1);
    class11.addCategory(exam11);
    class11.addCategory(exam21);
    hw11.category = homework1;
    hw21.category = homework1;
    hw31.category = homework1;
    hw41.category = homework1;
    hw51.category = homework1;
    midterm1.category = exam11;
    finalExam1.category = exam21;
    class11.addTodoItem("assignment", assignment: hw11);
    class11.addTodoItem("assignment", assignment: hw21);
    class11.addTodoItem("assignment", assignment: hw31);
    class11.addTodoItem("assignment", assignment: hw41);
    class11.addTodoItem("assignment", assignment: hw51);
    class11.addTodoItem("assessment", assignment: midterm1);
    class11.addTodoItem("assessment", assignment: finalExam1);

    class21.addCategory(homework1);
    class21.addCategory(exam11);
    class21.addCategory(exam21);
    class21.addTodoItem("assignment", assignment: hw11);
    class21.addTodoItem("assignment", assignment: hw21);
    class21.addTodoItem("assignment", assignment: hw31);
    class21.addTodoItem("assignment", assignment: hw41);
    class21.addTodoItem("assignment", assignment: hw51);
    class21.addTodoItem("assessment", assignment: midterm1);
    class21.addTodoItem("assessment", assignment: finalExam1);

    class31.addCategory(homework1);
    class31.addCategory(exam11);
    class31.addCategory(exam21);
    hw31.category = exam11;
    class31.addTodoItem("assignment", assignment: hw11);
    class31.addTodoItem("assignment", assignment: hw21);
    class31.addTodoItem("assignment", assignment: hw31);
    class31.addTodoItem("assignment", assignment: hw41);
    class31.addTodoItem("assignment", assignment: hw51);
    class31.addTodoItem("assessment", assignment: midterm1);
    class31.addTodoItem("assessment", assignment: finalExam1);

    class41.addCategory(homework1);
    class41.addCategory(exam11);
    class41.addCategory(exam21);
    hw11.category = exam11;
    hw31.category = homework1;
    class41.addTodoItem("assignment", assignment: hw11);
    class41.addTodoItem("assignment", assignment: hw21);
    class41.addTodoItem("assignment", assignment: hw31);
    class41.addTodoItem("assignment", assignment: hw41);
    class41.addTodoItem("assignment", assignment: hw51);
    class41.addTodoItem("assessment", assignment: midterm1);
    class41.addTodoItem("assessment", assignment: finalExam1);

    term1.addClass(class11);
    term1.addClass(class21);
    term1.addClass(class31);
    term1.addClass(class41);
    GPACalculator gp = GPACalculator();
    gp.addTerm(term);
    gp.addTerm(term1);
    print(gp.gpa);
    expect(gp.termsMap.length, equals(2));
  });
   test("Test No assignments", () {
      AcademicTerm term =
        AcademicTerm(termName: "Spring 2018", startTime: DateTime(2018), endTime: DateTime(2019));
    Class class1 = Class(
        subjectArea: "CS", courseNumber: "160", location: "SJSU", units: 4);
        term.addClass(class1);
            GPACalculator gp = GPACalculator();
            gp.addTerm(term);
      print(gp.gpa);

  });
}

 