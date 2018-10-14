
import 'package:cognito/models/academic_term.dart';
import 'package:json_annotation/json_annotation.dart';
part 'all_terms.g.dart';

@JsonSerializable()
class AllTerms {
  List<AcademicTerm> terms;

  AllTerms(){
      terms = List();
  }

void addTerms(AcademicTerm term){
  terms.add(term);
}

void removeTerm(AcademicTerm term){
    if(terms.contains(term)){
      terms.remove(term);
    }
}
  factory AllTerms.fromJson(Map<String, dynamic> json) =>
      _$AllTermsFromJson(json);

  Map<String, dynamic> toJson() => _$AllTermsToJson(this);
}
