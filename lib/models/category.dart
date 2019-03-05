// Copyright 2019 UniPlan. All rights reserved.

/// Models a category of an assignment in a grade book
import 'package:json_annotation/json_annotation.dart';
part 'category.g.dart';

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

  double getPercentage() {
    if (pointsPossible > 0.0) {
      return pointsEarned / pointsPossible * weightInPercentage;
    }
    return 0.0;
  }

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}