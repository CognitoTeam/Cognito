import 'package:cognito/models/Category.dart';
/// Calculates grade
/// @author Julian Vu

import 'package:cognito/models/assignment.dart';
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

  GradeCalculator() {
    gradeBook = Map();
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
    categories = List();
    gradePointMultiplier = 0.0;
  }

  /// Adds a new category to the list of categories
  ///
  /// @param  categoryTitle       title of new category
  /// @param  weightInPercentage  weight of category in percentage
  void addCategory(Category category) {
    categories.add(category);
  }

  /// Adds grade to grade book
  ///
  /// Recalculates grade with every new grade added
  ///
  /// @param  assignment    Assignment to add to grade book
  /// @param  category      Category of assignment
  void addGrade(Assignment assignment, Category category) {
    if (!categories.contains(category)) {
      print("Could not add grade--category does not exist.");
    }
    else {
      gradeBook[assignment] = category;
      calculateGrade();
    }
  }

  /// Calculates grade
  void calculateGrade() {
    // Reset points for each category
    categories.forEach((category) {
      category.pointsEarned = 0.0;
      category.pointsPossible = 0.0;
    });

    // Re-count points for every assignment
    for (Assignment assignment in gradeBook.keys) {
      Category category = categories[categories.indexOf(gradeBook[assignment])];
      category.pointsEarned += assignment.pointsEarned;
      category.pointsPossible += assignment.pointsPossible;
    }

    // Reset and recalculate percentage
    percentage = 0.0;
    categories.forEach((category) {
      percentage += double.parse(((category.pointsEarned / category.pointsPossible)
          * category.weightInPercentage).toStringAsFixed(2));
    });

    // Determine letter grade from percentage value
    if (percentage >= gradeScale["F"] && percentage < gradeScale["F+"]) {
      letterGrade = "F";
    }
    else if (percentage >= gradeScale["F+"] && percentage < gradeScale["D-"]) {
      letterGrade = "F+";
    }
    else if (percentage >= gradeScale["D-"] && percentage < gradeScale["D"]) {
      letterGrade = "D-";
    }
    else if (percentage >= gradeScale["D"] && percentage < gradeScale["D+"]) {
      letterGrade = "D";
    }
    else if (percentage >= gradeScale["D+"] && percentage < gradeScale["C-"]) {
      letterGrade = "D+";
    }
    else if (percentage >= gradeScale["C-"] && percentage < gradeScale["C"]) {
      letterGrade = "C-";
    }
    else if (percentage >= gradeScale["C"] && percentage < gradeScale["C+"]) {
      letterGrade = "C";
    }
    else if (percentage >= gradeScale["C+"] && percentage < gradeScale["B-"]) {
      letterGrade = "C+";
    }
    else if (percentage >= gradeScale["B-"] && percentage < gradeScale["B"]) {
      letterGrade = "B-";
    }
    else if (percentage >= gradeScale["B"] && percentage < gradeScale["B+"]) {
      letterGrade = "B";
    }
    else if (percentage >= gradeScale["B+"] && percentage < gradeScale["A-"]) {
      letterGrade = "B+";
    }
    else if (percentage >= gradeScale["A-"] && percentage < gradeScale["A"]) {
      letterGrade = "A-";
    }
    else if (percentage >= gradeScale["A"] && percentage < gradeScale["A+"]) {
      letterGrade = "A";
    }
    else {
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

