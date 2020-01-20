import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cognito/database/database.dart';
import 'package:cognito/models/academic_term.dart';
import 'package:cognito/models/class.dart';
import 'package:firebase_auth/firebase_auth.dart';

///Model for the GPA calculator
///@author Praneet Singh

class GPACalculator {
  final double maxGPMultiplier = 4.0;
  DataBase dataBase = DataBase();
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
  void addTerm(AcademicTerm term, FirebaseUser user) {
    terms.add(term);
    calculateTermGPA(term, user);
    calculateGPA();
  }

  ///Calculates the GPA for each term and
  ///stores in the map
  Future calculateTermGPA(AcademicTerm term, FirebaseUser user) async {
    double gradePointsEarned = 0.0;
    double gradePointMultiplier = 0.0;
    double gradePointsPossible = 0.0;
    int units = 0;
    double gpaTemp = 0.0;
    //Get the all Classes of a term
    List<Class> classes = await dataBase.getClassForTerm(term, user.uid);
    if (classes == null || classes.isEmpty) {
      print("Classes is null for the term: " + term.termName);
    } else {
      for (Class c in classes) {
        String g = c.getGrade(null, null, null);
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

  String getGPAFromGradeLetters(List<String> gradeLetters)
  {
    double sum = 0;
    for(String str in gradeLetters)
      {
        if(str == null) continue;
        sum = sum + gradePointsMultiplier[str];
      }
    print("Sum: " + sum.toString());
    return gradeLetters.length > 0 ? num.parse((sum/gradeLetters.length).toStringAsFixed(3)).toString():"Grades not issued";
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
