import 'package:cognito/models/academic_term.dart';
import 'package:cognito/models/class.dart';

///Model for the GPA calculator
///@author Praneet Singh

class GPACalculator {
  final double maxGPMultiplier = 4.0;
  double gpa = 0.0;
  List<AcademicTerm> terms = List(); // List of the Academic terms
  Map<AcademicTerm, double> termsMap =
      Map(); // Maps an academic term to its GPA

  Map<String, double> gradePointsMultiplier = {
    //Maps Letter grade to GP multiplier
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
  void addTerm(AcademicTerm term) {
    terms.add(term);
    calculateTermGPA(term);
    calculateGPA();
  }

  ///Calculates the GPA for each term and
  ///stores in the map
  void calculateTermGPA(AcademicTerm term) {
    double gradePointsEarned = 0.0;
    double gradePointMultiplier = 0.0;
    double gradePointsPossible = 0.0;
    int units = 0;
    double gpaTemp = 0.0;
    if (term.classes.isEmpty) {
      print("No classes have been added to the class yet");
    } else {
      for (Class c in term.classes) {
        String g = c.getGrade();
        if (g != "No Grades yet") {
          gradePointMultiplier = gradePointsMultiplier[g];
          units = c.units;
          gradePointsEarned += gradePointMultiplier * units;
          gradePointsPossible += (units * maxGPMultiplier);
        }
      }
      if(gradePointsEarned != 0.0 && gradePointsPossible != 0.0){
        gpaTemp = ((gradePointsEarned / gradePointsPossible) * maxGPMultiplier);
        termsMap[term] = gpaTemp;
      }else{
        termsMap[term] = 4.0;
      }
     
    }
  }

//Calculates the final GPA for all terms
  void calculateGPA() {
    double finalGPA = 0.0;
    if (termsMap.isEmpty) {
      print("No terms have been added yet");
    } else {
      for (AcademicTerm t in termsMap.keys) {
        finalGPA += termsMap[t];
      }
    }
    gpa = finalGPA / termsMap.length;
  }
}
