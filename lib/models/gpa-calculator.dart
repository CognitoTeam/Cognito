import 'package:cognito/models/academic_term.dart';
import 'package:cognito/models/class.dart';

///Model for the GPA calculator
///@author Praneet Singh

class GPACalculator{

  double gpa = 0.0;
  Map<AcademicTerm, double> termsMap = Map();//maps an academic term to its GPA
  
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

void calculateTermGPA(AcademicTerm term){
  double gpaTemp = 0.0;
  for(Class c in term.classes){
    c.gradeCalculator.calculateGrade();
    String g = c.gradeCalculator.letterGrade;
    gpaTemp += gradePointsMultiplier[g];
  }
  gpaTemp = gpaTemp/term.classes.length;
  termsMap[term] = gpaTemp;
}

void calculateGPA(){
  if(termsMap.isEmpty){
    print("No terms have been added yet");
  }else{
    termsMap.forEach((academicTerm, termGPA) => gpa+= termGPA);
  }
  gpa = gpa/termsMap.length;
  print(gpa);
}




}