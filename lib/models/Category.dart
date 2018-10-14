/// Models a category of an assignment in a grade book
import 'package:json_annotation/json_annotation.dart';
part 'Category.g.dart';

@JsonSerializable()

class Category {

  String title;
  double weightInPercentage, pointsEarned, pointsPossible;

  Category({String title, double weightInPercentage}) {
    this.title = title;
    this.weightInPercentage = weightInPercentage;
    this.pointsEarned = 0.0;
    this.pointsPossible = 0.0;
  }

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}