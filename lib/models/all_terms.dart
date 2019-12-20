import 'package:cognito/models/academic_term.dart';
import 'package:json_annotation/json_annotation.dart';
//part 'all_terms.g.dart';

@JsonSerializable()
class AllTerms {
  List<AcademicTerm> terms;
  List<String> subjects;

  AllTerms() {
    terms = List<AcademicTerm>();
    subjects = List();
  }

  void addTerm(AcademicTerm term) {
    terms.add(term);
  }

  void addTerms(List<AcademicTerm> terms)
  {
    terms.addAll(terms);
  }

  void removeTerm(AcademicTerm term) {
    if (terms.contains(term)) {
      terms.remove(term);
    }
  }

  void updateTerm(AcademicTerm term) {
    int index;
    for (AcademicTerm t in terms) {
      if (t.termName == term.termName) {
        index = terms.indexOf(t);  
      }
    }
    terms.removeAt(index);
     terms.insert(index, term);
  }

  void addSubject(String subject) {
    subjects.add(subject);
  }

  void removeSubject(String subject) {
    if (subjects.contains(subject)) {
      terms.remove(subject);
    }
  }

  List<AcademicTerm> getTerms()
  {
    return terms;
  }
}
