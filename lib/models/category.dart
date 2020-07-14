// Copyright 2019 UniPlan. All rights reserved.

import 'package:cloud_firestore/cloud_firestore.dart';
/// Models a category of an assignment in a grade book
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()

class Category {

  String title;
  String id;
  double weightInPercentage, pointsEarned, pointsPossible;

  Category({String title, double weightInPercentage, String id}) {
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

  factory Category.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    Category cat = Category(
        id: doc.documentID,
        title: data['category_title'],
        weightInPercentage: data['category_weight_in_percentage']
    );
    return cat;
  }
}