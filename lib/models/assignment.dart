import 'package:cognito/models/category.dart';
/// Models an assignment for a class
/// @author Julian Vu
///
import 'package:cognito/models/task.dart';
import 'package:json_annotation/json_annotation.dart';

part 'assignment.g.dart';

@JsonSerializable()


class Assignment extends Task {
  
  double pointsPossible, pointsEarned, _rawScore;
  bool isAssessment;
  Category category;
  Assignment(
      {String title,
        String description = "",
        String location = "",
        DateTime start,
        DateTime end,
        DateTime dueDate,
        double pointsPossible = 0.0,
        double pointsEarned = 0.0,
        bool isAssessment = false,
        Category category}) : super(
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
    this.category = category;
    calculateRawScore();
  }
factory Assignment.fromJson(Map<String, dynamic> json) => _$AssignmentFromJson(json);


  Map<String, dynamic> toJson() => _$AssignmentToJson(this);
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