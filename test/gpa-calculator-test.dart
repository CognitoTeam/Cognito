
import 'package:cognito/models/academic_term.dart';
import 'package:cognito/models/assignment.dart';
import 'package:cognito/models/class.dart';
import 'package:cognito/models/gpa-calculator.dart';
import 'package:cognito/models/grade_calculator.dart';
import 'package:test/test.dart';

void main(){
  test("Test GPA", () {
    AcademicTerm term = AcademicTerm("Spring 2018", DateTime(2018), DateTime(2019));
    Class class1 = Class(subjectArea: "CS", courseNumber: "160", location: "SJSU", units: 4);
    Class class2 = Class(subjectArea: "CS", courseNumber: "157A", location: "SJSU", units: 3);
    Class class3 = Class(subjectArea: "CS", courseNumber: "175", location: "SJSU", units: 4);
    Class class4 = Class(subjectArea: "CS", courseNumber: "152", location: "SJSU", units: 3);

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

    Category homework = Category(
      title: "Homework", 
      weightInPercentage: 30.0);

      Category exam1 = Category(
      title: "Midterm", 
      weightInPercentage: 30.0);

      Category exam2 = Category(
      title: "Final", 
      weightInPercentage: 40.0);

      GPACalculator gp  = GPACalculator();
      class1.gradeCalculator.addCategory(homework);
      class1.gradeCalculator.addCategory(exam1);
      class1.gradeCalculator.addCategory(exam2);
      class1.addTodoItem("assignment", assignment: hw1, category: homework);
      class1.addTodoItem("assignment", assignment: hw2, category: homework);
      class1.addTodoItem("assignment", assignment: hw3, category: homework);
      class1.addTodoItem("assignment", assignment: hw4, category: homework);
      class1.addTodoItem("assignment", assignment: hw5, category: homework);
      class1.addTodoItem("assessment", assignment: midterm, category: exam1);
      class1.addTodoItem("assessment", assignment: finalExam, category: exam2);

      class2.gradeCalculator.addCategory(homework);
      class2.gradeCalculator.addCategory(exam1);
      class2.gradeCalculator.addCategory(exam2);
      class2.addTodoItem("assignment", assignment: hw1, category: homework);
      class2.addTodoItem("assignment", assignment: hw2, category: homework);
      class2.addTodoItem("assignment", assignment: hw3, category: homework);
      class2.addTodoItem("assignment", assignment: hw4, category: homework);
      class2.addTodoItem("assignment", assignment: hw5, category: homework);
      class2.addTodoItem("assessment", assignment: midterm, category: exam1);
      class2.addTodoItem("assessment", assignment: finalExam, category: exam2);

      class3.gradeCalculator.addCategory(homework);
      class3.gradeCalculator.addCategory(exam1);
      class3.gradeCalculator.addCategory(exam2);
      class3.addTodoItem("assignment", assignment: hw1, category: homework);
      class3.addTodoItem("assignment", assignment: hw2, category: homework);
      class3.addTodoItem("assignment", assignment: hw3, category: exam1);
      class3.addTodoItem("assignment", assignment: hw4, category: homework);
      class3.addTodoItem("assignment", assignment: hw5, category: homework);
      class3.addTodoItem("assessment", assignment: midterm, category: exam1);
      class3.addTodoItem("assessment", assignment: finalExam, category: exam2);

      class4.gradeCalculator.addCategory(homework);
      class4.gradeCalculator.addCategory(exam1);
      class4.gradeCalculator.addCategory(exam2);
      class4.addTodoItem("assignment", assignment: hw1, category: exam1);
      class4.addTodoItem("assignment", assignment: hw2, category: homework);
      class4.addTodoItem("assignment", assignment: hw3, category: homework);
      class4.addTodoItem("assignment", assignment: hw4, category: homework);
      class4.addTodoItem("assignment", assignment: hw5, category: homework);
      class4.addTodoItem("assessment", assignment: midterm, category: exam1);
      class4.addTodoItem("assessment", assignment: finalExam, category: exam2);

      term.addClass(class1);
      term.addClass(class2);
      term.addClass(class3);
      term.addClass(class4);

      gp.calculateTermGPA(term);
    AcademicTerm term1 = AcademicTerm("Spring 2018", DateTime(2018), DateTime(2019));
    Class class11 = Class(subjectArea: "CS", courseNumber: "160", location: "SJSU", units: 3);
    Class class21 = Class(subjectArea: "CS", courseNumber: "157A", location: "SJSU", units: 3);
    Class class31 = Class(subjectArea: "CS", courseNumber: "175", location: "SJSU", units: 3);
    Class class41 = Class(subjectArea: "CS", courseNumber: "152", location: "SJSU", units: 3);

     Assignment hw11 = Assignment(
      title: "hw1",
      pointsEarned: 100.0,
      pointsPossible: 100.0
    );

    Assignment hw21 = Assignment(
      title: "hw2",
      pointsEarned: 100.0,
      pointsPossible: 100.0
    );

    Assignment hw31 = Assignment(
        title: "hw3",
        pointsEarned: 94.0,
        pointsPossible: 100.0
    );

    Assignment hw41 = Assignment(
        title: "hw4",
        pointsEarned: 97.0,
        pointsPossible: 100.0
    );

    Assignment hw51 = Assignment(
        title: "hw5",
        pointsEarned: 106.0,
        pointsPossible: 100.0
    );

    Assignment midterm1 = Assignment(
      title: "midterm",
      pointsEarned: 72.0,
      pointsPossible: 100.0,
      isAssessment: true
    );

    Assignment finalExam1 = Assignment(
      title: "final",
      pointsEarned: 97.0,
      pointsPossible: 100.0
    );

    Category homework1 = Category(
      title: "Homework", 
      weightInPercentage: 30.0);

      Category exam11 = Category(
      title: "Midterm", 
      weightInPercentage: 30.0);

      Category exam21 = Category(
      title: "Final", 
      weightInPercentage: 40.0);

      class11.gradeCalculator.addCategory(homework1);
      class11.gradeCalculator.addCategory(exam11);
      class11.gradeCalculator.addCategory(exam21);
      class11.addTodoItem("assignment", assignment: hw11, category: homework1);
      class11.addTodoItem("assignment", assignment: hw21, category: homework1);
      class11.addTodoItem("assignment", assignment: hw31, category: homework1);
      class11.addTodoItem("assignment", assignment: hw41, category: homework1);
      class11.addTodoItem("assignment", assignment: hw51, category: homework1);
      class11.addTodoItem("assessment", assignment: midterm1, category: exam11);
      class11.addTodoItem("assessment", assignment: finalExam1, category: exam21);

      class21.gradeCalculator.addCategory(homework1);
      class21.gradeCalculator.addCategory(exam11);
      class21.gradeCalculator.addCategory(exam21);
      class21.addTodoItem("assignment", assignment: hw11, category: homework1);
      class21.addTodoItem("assignment", assignment: hw21, category: homework1);
      class21.addTodoItem("assignment", assignment: hw31, category: homework1);
      class21.addTodoItem("assignment", assignment: hw41, category: homework1);
      class21.addTodoItem("assignment", assignment: hw51, category: homework1);
      class21.addTodoItem("assessment", assignment: midterm1, category: exam11);
      class21.addTodoItem("assessment", assignment: finalExam1, category: exam21);

      class31.gradeCalculator.addCategory(homework1);
      class31.gradeCalculator.addCategory(exam11);
      class31.gradeCalculator.addCategory(exam21);
      class31.addTodoItem("assignment", assignment: hw11, category: homework1);
      class31.addTodoItem("assignment", assignment: hw21, category: homework1);
      class31.addTodoItem("assignment", assignment: hw31, category: exam11);
      class31.addTodoItem("assignment", assignment: hw41, category: homework1);
      class31.addTodoItem("assignment", assignment: hw51, category: homework1);
      class31.addTodoItem("assessment", assignment: midterm1, category: exam11);
      class31.addTodoItem("assessment", assignment: finalExam1, category: exam21);

      class41.gradeCalculator.addCategory(homework1);
      class41.gradeCalculator.addCategory(exam11);
      class41.gradeCalculator.addCategory(exam21);
      class41.addTodoItem("assignment", assignment: hw11, category: exam11);
      class41.addTodoItem("assignment", assignment: hw21, category: homework1);
      class41.addTodoItem("assignment", assignment: hw31, category: homework1);
      class41.addTodoItem("assignment", assignment: hw41, category: homework1);
      class41.addTodoItem("assignment", assignment: hw51, category: homework1);
      class41.addTodoItem("assessment", assignment: midterm1, category: exam11);
      class41.addTodoItem("assessment", assignment: finalExam1, category: exam21);

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
    AcademicTerm term = AcademicTerm("Spring 2018", DateTime(2018), DateTime(2019));
    Class class1 = Class(subjectArea: "CS", courseNumber: "160", location: "SJSU", units: 4);
    Class class2 = Class(subjectArea: "CS", courseNumber: "157A", location: "SJSU", units: 3);
    Class class3 = Class(subjectArea: "CS", courseNumber: "175", location: "SJSU", units: 4);
    Class class4 = Class(subjectArea: "CS", courseNumber: "152", location: "SJSU", units: 3);

     Assignment hw1 = Assignment(
      title: "hw1",
      pointsEarned: 100.0,
      pointsPossible: 100.0
    );

    Assignment midterm = Assignment(
      title: "midterm",
      pointsEarned: 100.0,
      pointsPossible: 100.0,
      isAssessment: true
    );

    Assignment finalExam = Assignment(
      title: "final",
      pointsEarned: 70.0,
      pointsPossible: 100.0
    );

    Category homework = Category(
      title: "Homework", 
      weightInPercentage: 30.0);

      Category exam1 = Category(
      title: "Midterm", 
      weightInPercentage: 30.0);

      Category exam2 = Category(
      title: "Final", 
      weightInPercentage: 40.0);

      GPACalculator gp  = GPACalculator();
      class1.gradeCalculator.addCategory(homework);
      class1.gradeCalculator.addCategory(exam1);
      class1.gradeCalculator.addCategory(exam2);
      class1.addTodoItem("assignment", assignment: hw1, category: homework);
      class1.addTodoItem("assessment", assignment: midterm, category: exam1);
      class1.addTodoItem("assessment", assignment: finalExam, category: exam2);

      Assignment hw2 = Assignment(
      title: "hw1",
      pointsEarned: 100.0,
      pointsPossible: 100.0
    );

    Assignment midterm2 = Assignment(
      title: "midterm",
      pointsEarned: 100.0,
      pointsPossible: 100.0,
      isAssessment: true
    );

    Assignment finalExam2 = Assignment(
      title: "final",
      pointsEarned: 100.0,
      pointsPossible: 100.0
    );
      class2.gradeCalculator.addCategory(homework);
      class2.gradeCalculator.addCategory(exam1);
      class2.gradeCalculator.addCategory(exam2);
      class2.addTodoItem("assignment", assignment: hw2, category: homework);
      class2.addTodoItem("assessment", assignment: midterm2, category: exam1);
      class2.addTodoItem("assessment", assignment: finalExam2, category: exam2);

      Assignment hw3 = Assignment(
      title: "hw1",
      pointsEarned: 92.0,
      pointsPossible: 100.0
    );

    Assignment midterm3 = Assignment(
      title: "midterm",
      pointsEarned: 95.0,
      pointsPossible: 100.0,
      isAssessment: true
    );

    Assignment finalExam3 = Assignment(
      title: "final",
      pointsEarned: 90.0,
      pointsPossible: 100.0
    );
      class3.gradeCalculator.addCategory(homework);
      class3.gradeCalculator.addCategory(exam1);
      class3.gradeCalculator.addCategory(exam2);
      class3.addTodoItem("assignment", assignment: hw3, category: homework);
      class3.addTodoItem("assessment", assignment: midterm3, category: exam1);
      class3.addTodoItem("assessment", assignment: finalExam3, category: exam2);

      Assignment hw4 = Assignment(
      title: "hw1",
      pointsEarned: 100.0,
      pointsPossible: 100.0
    );

    Assignment midterm4 = Assignment(
      title: "midterm",
      pointsEarned: 100.0,
      pointsPossible: 100.0,
      isAssessment: true
    );

    Assignment finalExam4 = Assignment(
      title: "final",
      pointsEarned: 100.0,
      pointsPossible: 100.0
    );
      class4.gradeCalculator.addCategory(homework);
      class4.gradeCalculator.addCategory(exam1);
      class4.gradeCalculator.addCategory(exam2);
      class4.addTodoItem("assignment", assignment: hw4, category: homework);
      class4.addTodoItem("assessment", assignment: midterm4, category: exam1);
      class4.addTodoItem("assessment", assignment: finalExam4, category: exam2);

      term.addClass(class1);
      term.addClass(class2);
      term.addClass(class3);
      term.addClass(class4);
      
      AcademicTerm term1 = AcademicTerm("Spring 2018", DateTime(2018), DateTime(2019));
    Class class11 = Class(subjectArea: "CS", courseNumber: "160", location: "SJSU", units: 3);
    Class class21 = Class(subjectArea: "CS", courseNumber: "157A", location: "SJSU", units: 3);
    Class class31 = Class(subjectArea: "CS", courseNumber: "175", location: "SJSU", units: 3);
    Class class41 = Class(subjectArea: "CS", courseNumber: "152", location: "SJSU", units: 3);

     Assignment hw11 = Assignment(
      title: "hw1",
      pointsEarned: 100.0,
      pointsPossible: 100.0
    );

    Assignment midterm1 = Assignment(
      title: "midterm",
      pointsEarned: 100.0,
      pointsPossible: 100.0,
      isAssessment: true
    );

    Assignment finalExam1 = Assignment(
      title: "final",
      pointsEarned: 100.0,
      pointsPossible: 100.0
    );

    Category homework1 = Category(
      title: "Homework", 
      weightInPercentage: 30.0);

      Category exam11 = Category(
      title: "Midterm", 
      weightInPercentage: 30.0);

      Category exam21 = Category(
      title: "Final", 
      weightInPercentage: 40.0);

      class11.gradeCalculator.addCategory(homework1);
      class11.gradeCalculator.addCategory(exam11);
      class11.gradeCalculator.addCategory(exam21);
      class11.addTodoItem("assignment", assignment: hw11, category: homework1);
      class11.addTodoItem("assessment", assignment: midterm1, category: exam11);
      class11.addTodoItem("assessment", assignment: finalExam1, category: exam21);

      Assignment hw21 = Assignment(
      title: "hw1",
      pointsEarned: 92.0,
      pointsPossible: 100.0
    );

    Assignment midterm21 = Assignment(
      title: "midterm",
      pointsEarned: 95.0,
      pointsPossible: 100.0,
      isAssessment: true
    );

    Assignment finalExam21 = Assignment(
      title: "final",
      pointsEarned: 90.0,
      pointsPossible: 100.0
    );
      class21.gradeCalculator.addCategory(homework1);
      class21.gradeCalculator.addCategory(exam11);
      class21.gradeCalculator.addCategory(exam21);
      class21.addTodoItem("assignment", assignment: hw21, category: homework1);
      class21.addTodoItem("assessment", assignment: midterm21, category: exam11);
      class21.addTodoItem("assessment", assignment: finalExam21, category: exam21);

      Assignment hw31 = Assignment(
      title: "hw1",
      pointsEarned: 100.0,
      pointsPossible: 100.0
    );

    Assignment midterm31 = Assignment(
      title: "midterm",
      pointsEarned: 100.0,
      pointsPossible: 100.0,
      isAssessment: true
    );

    Assignment finalExam31 = Assignment(
      title: "final",
      pointsEarned: 70.0,
      pointsPossible: 100.0
    );
      class31.gradeCalculator.addCategory(homework1);
      class31.gradeCalculator.addCategory(exam11);
      class31.gradeCalculator.addCategory(exam21);
      class31.addTodoItem("assignment", assignment: hw31, category: homework1);
      class31.addTodoItem("assessment", assignment: midterm31, category: exam11);
      class31.addTodoItem("assessment", assignment: finalExam31, category: exam21);

      Assignment hw41 = Assignment(
      title: "hw1",
      pointsEarned: 92.0,
      pointsPossible: 100.0
    );

    Assignment midterm41 = Assignment(
      title: "midterm",
      pointsEarned: 95.0,
      pointsPossible: 100.0,
      isAssessment: true
    );

    Assignment finalExam41 = Assignment(
      title: "final",
      pointsEarned: 90.0,
      pointsPossible: 100.0
    );
      class41.gradeCalculator.addCategory(homework1);
      class41.gradeCalculator.addCategory(exam11);
      class41.gradeCalculator.addCategory(exam21);
      class41.addTodoItem("assignment", assignment: hw41, category: homework1);
      class41.addTodoItem("assessment", assignment: midterm41, category: exam11);
      class41.addTodoItem("assessment", assignment: finalExam41, category: exam21);

      term1.addClass(class11);
      term1.addClass(class21);
      term1.addClass(class31);
      term1.addClass(class41);

    gp.addTerm(term);
    gp.addTerm(term1);
    print(gp.gpa);
  });
}