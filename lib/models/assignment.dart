/// Models an assignment for a class
/// @author Julian Vu
///
import 'package:cognito/models/task.dart';
import 'package:flutter/material.dart';

class Assignment extends Task {
  double pointsPossible, pointsEarned, _rawScore;
  bool isAssessment;

  Assignment(
      {String title,
        String description = "",
        String location = "",
        TimeOfDay start,
        TimeOfDay end,
        DateTime dueDate,
        double pointsPossible = 0.0,
        double pointsEarned = 0.0,
        bool isAssessment = false}) : super(
      title: title,
      description: description,
      location: location,
      start: start,
      end: end,
      dueDate: dueDate
  ) {
    this.pointsPossible = pointsPossible;
    this.pointsEarned = pointsEarned;
    this.isAssessment = isAssessment;
    calculateRawScore();
  }

  /// Calculates raw score and then returns
  get rawScore {
    _rawScore = calculateRawScore();
    return _rawScore;
  }

  /// Calculates raw score from points possible and points earned on this
  /// assignment
  double calculateRawScore() {
    if (pointsPossible > 0.0) {
      return pointsEarned/pointsPossible;
    }
    return 0.0;
  }
}