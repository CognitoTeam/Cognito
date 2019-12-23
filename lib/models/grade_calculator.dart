// Copyright 2019 UniPlan. All rights reserved.

import 'dart:collection';

import 'package:cognito/models/assignment.dart';
import 'package:cognito/models/category.dart';

/// Calculates grade
/// @author Julian Vu
class GradeCalculator {
  /// Grade book that maps assignment to a category
  Map<Assignment, Category> gradeBook;

  /// Grade book that is meant to be hypothetical grade
  Map<Assignment, Category> mutableGradeBook;

  /// Letter grade representation
  String letterGrade;

  /// Grade as a percentage
  double percentage;

  /// Map of letter grade to minimum percentage
  Map<String, double> gradeScale;

  /// List of categories
  List<Category> categories;

  /// Grade point multiplier to be used in calculating GPA
  double gradePointMultiplier;

  GradeCalculator(
      List<Category> categories, Map<Assignment, Category> gradeBook) {
    this.gradeBook = gradeBook;
    mutableGradeBook = Map();
    letterGrade = "";
    percentage = 0.0;

    /// Default grade scale
    gradeScale = {
      "A+": 97.0,
      "A": 93.0,
      "A-": 90.0,
      "B+": 87.0,
      "B": 83.0,
      "B-": 80.0,
      "C+": 77.0,
      "C": 73.0,
      "C-": 70.0,
      "D+": 67.0,
      "D": 63.0,
      "D-": 60.0,
      "F+": 57.0,
      "F": 0.0
    };
    this.categories = categories;
    gradePointMultiplier = 0.0;
  }

  /// Calculates grade
  void calculateGrade() {
    // Reset points for each category
    //Calculate how much category weight should be
    categories.forEach((category) {
      if (category.title.toLowerCase() == "default") {
        category.pointsEarned = 1.0;
        category.pointsPossible = 1.0;
      } else {
        category.pointsEarned = 0.0;
        category.pointsPossible = 0.0;
      }
    });

    double sumOfCurrentAssignedCategories = 0;
    List<Category> uniqueCategoriesUsed = List();
    // Re-count points for every assignment
    for (Assignment assignment in gradeBook.keys) {
      //Figure out sum of currently assigned categories
      if(!uniqueCategoriesUsed.contains(assignment.category))
        {
          sumOfCurrentAssignedCategories += assignment.category.weightInPercentage;
          uniqueCategoriesUsed.add(assignment.category);
        }
      assignment.category.pointsEarned += assignment.pointsEarned;
      assignment.category.pointsPossible += assignment.pointsPossible;
    }

    // Reset and recalculate percentage
    percentage = 0.0;
    uniqueCategoriesUsed.forEach((category) {
      percentage += (category.pointsPossible == 0.0
          ? 0.0
          : double.parse(((category.pointsEarned / category.pointsPossible) *
                  category.weightInPercentage)
              .toStringAsFixed(2)));
    });
    //Add default percentage

    percentage += (100 - sumOfCurrentAssignedCategories);

    // Determine letter grade from percentage value
    if (percentage >= gradeScale["F"] && percentage < gradeScale["F+"]) {
      letterGrade = "F";
    } else if (percentage >= gradeScale["F+"] &&
        percentage < gradeScale["D-"]) {
      letterGrade = "F+";
    } else if (percentage >= gradeScale["D-"] && percentage < gradeScale["D"]) {
      letterGrade = "D-";
    } else if (percentage >= gradeScale["D"] && percentage < gradeScale["D+"]) {
      letterGrade = "D";
    } else if (percentage >= gradeScale["D+"] &&
        percentage < gradeScale["C-"]) {
      letterGrade = "D+";
    } else if (percentage >= gradeScale["C-"] && percentage < gradeScale["C"]) {
      letterGrade = "C-";
    } else if (percentage >= gradeScale["C"] && percentage < gradeScale["C+"]) {
      letterGrade = "C";
    } else if (percentage >= gradeScale["C+"] &&
        percentage < gradeScale["B-"]) {
      letterGrade = "C+";
    } else if (percentage >= gradeScale["B-"] && percentage < gradeScale["B"]) {
      letterGrade = "B-";
    } else if (percentage >= gradeScale["B"] && percentage < gradeScale["B+"]) {
      letterGrade = "B";
    } else if (percentage >= gradeScale["B+"] &&
        percentage < gradeScale["A-"]) {
      letterGrade = "B+";
    } else if (percentage >= gradeScale["A-"] && percentage < gradeScale["A"]) {
      letterGrade = "A-";
    } else if (percentage >= gradeScale["A"] && percentage < gradeScale["A+"]) {
      letterGrade = "A";
    } else {
      letterGrade = "A+";
    }

    setGradePointMultiplier();
  }

  /// Sets grade point multiplier
  void setGradePointMultiplier() {
    switch (letterGrade) {
      case "F":
        gradePointMultiplier = 0.0;
        break;
      case "D-":
        gradePointMultiplier = 0.7;
        break;
      case "D":
        gradePointMultiplier = 1.0;
        break;
      case "D+":
        gradePointMultiplier = 1.3;
        break;
      case "C-":
        gradePointMultiplier = 1.7;
        break;
      case "C":
        gradePointMultiplier = 2.0;
        break;
      case "C+":
        gradePointMultiplier = 2.3;
        break;
      case "B-":
        gradePointMultiplier = 2.7;
        break;
      case "B":
        gradePointMultiplier = 3.0;
        break;
      case "B+":
        gradePointMultiplier = 3.3;
        break;
      case "A-":
        gradePointMultiplier = 3.7;
        break;
      default:
        gradePointMultiplier = 4.0;
    }
  }
}
