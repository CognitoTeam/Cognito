import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cognito/models/category.dart';
import 'package:cognito/models/class.dart';
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
  String classObjId;
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
        Category category,
        String classObjId,
        String id,
        int priority = 1,
        Duration duration}) : super(
      title: title,
      description: description,
      location: location,
      start: start,
      end: end,
      dueDate: dueDate,
      id: id,
      priority: priority,
      duration: duration
  ) {
    this.pointsPossible = pointsPossible;
    this.pointsEarned = pointsEarned;
    this.isAssessment = isAssessment;
    this.category = category;
    this.classObjId = classObjId;
    calculateRawScore();
  }

  factory Assignment.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    int minutes = data['duration_in_minutes'];
    Duration d = new Duration(minutes: minutes);
    Assignment a = Assignment(
      classObjId: data['class_id'],
      title: data['title'],
      isAssessment: data['is_assessment'],
      description: data['description'],
      location: data['location'],
      dueDate: data['due_date'].toDate(),
      id: doc.documentID,
      priority: data['priority'],
      duration: d,
      pointsEarned: data['points_earned'],
      pointsPossible: data['points_possible'],
      category: Category(
        title: data['category_title'],
        weightInPercentage: data['category_weight_in_percentage'])
    );
    return a;
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