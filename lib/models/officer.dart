/// Models a officer
/// @Praneet Singh
import 'package:json_annotation/json_annotation.dart';

part 'officer.g.dart';

@JsonSerializable()

class Officer{
  String officerName, officerPosition;

  Officer(this.officerName, this.officerPosition);
factory Officer.fromJson(Map<String, dynamic> json) => _$OfficerFromJson(json);

  Map<String, dynamic> toJson() => _$OfficerToJson(this);
 
}
