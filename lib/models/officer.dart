import 'package:cloud_firestore/cloud_firestore.dart';
/// Models a officer
/// @Praneet Singh
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()

class Officer{
  String officerName, officerPosition;

  Officer(this.officerName, this.officerPosition);

  factory Officer.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return Officer(
      data['officer_name'], data['officer_position']
    );
  }

}
