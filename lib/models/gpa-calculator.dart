import 'package:cognito/models/academic_term.dart';
import 'package:cognito/models/class.dart';
import 'package:cognito/models/grade_calculator.dart';

///Model for the GPA calculator
///@author Praneet Singh

class GPACalculator{

  double gpa = 0.0;
  List<AcademicTerm> terms = List();
  Map<AcademicTerm, double> termsMap = Map();//maps an academic term to its GPA
  GradeCalculator grader = GradeCalculator();
  
  Map<String, double> gradePointsMultiplier = {
     "A+": 4.0,
      "A": 4.0,
      "A-": 3.7,
      "B+": 3.3,
      "B": 3.0,
      "B-": 2.7,
      "C+": 2.3,
      "C": 2.0,
      "C-": 1.7,
      "D+": 1.3,
      "D": 1.0,
      "D-": 0.7,
      "F+": 0.0,
      "F": 0.0
  };

///Everytime a new term is added 
///the GPA is recalculated
void addTerm(AcademicTerm term){
  terms.add(term);
  calculateTermGPA(term);
  calculateGPA();
}

void calculateTermGPA(AcademicTerm term){
  double gradePointsEarned = 0.0;
  double gradePointMultiplier = 0.0;
  double gradePointsPossible = 0.0;
  int units = 0;
  double gpaTemp = 0.0;
  for(Class c in term.classes){
    c.gradeCalculator.calculateGrade();
    String g = c.gradeCalculator.letterGrade;
    gradePointMultiplier= gradePointsMultiplier[g];
    units = c.units;
    gradePointsEarned += gradePointMultiplier*units;
    gradePointsPossible += (units*4.0);
  }
  gpaTemp = ((gradePointsEarned/gradePointsPossible)*4.0);
  termsMap[term] = gpaTemp;

}

void calculateGPA(){
   double finalGPA = 0.0;
  if(termsMap.isEmpty){
    print("No terms have been added yet");
  }else{
    for(AcademicTerm t in termsMap.keys){
      finalGPA += termsMap[t];
    }
  }
  gpa = finalGPA/termsMap.length;
}
}