import 'dart:convert';

import 'package:cognito/models/academic_term.dart';
import 'package:cognito/models/all_terms.dart';
import 'package:cognito/models/class.dart';
import 'package:cognito/models/club.dart';
import 'package:test/test.dart';

void main() {
  test('Academic Term to JSON', () {
    AcademicTerm term =
        AcademicTerm("Spring 2018", DateTime(2018), DateTime(2019));
    Class class1 = Class(
        subjectArea: "CS", courseNumber: "160", location: "SJSU", units: 3);
    Class class2 = Class(
        subjectArea: "CS", courseNumber: "157A", location: "SJSU", units: 3);
    Class class3 = Class(
        subjectArea: "CS", courseNumber: "175", location: "SJSU", units: 3);
    Class class4 = Class(
        subjectArea: "CS", courseNumber: "152", location: "SJSU", units: 3);

    Club club =
        Club(title: "Computer science club", location: "Macquarrie Hall");
    Club club1 = Club(title: "Jogging club", location: "Pier 18");
    Club club2 = Club(title: "Hiking club", location: "Mission Peak");
    Club club3 = Club(title: "Shooting club", location: "Morgan Hill");
    term.addClass(class1);
    term.addClass(class2);
    term.addClass(class3);
    term.addClass(class4);

    term.addClub(club);
    term.addClub(club1);
    term.addClub(club2);
    term.addClub(club3);
    AcademicTerm term1 =
        AcademicTerm("Spring 2018", DateTime(2018), DateTime(2019));
    Class class11 = Class(
        subjectArea: "CS", courseNumber: "160", location: "SJSU", units: 3);
    Class class21 = Class(
        subjectArea: "CS", courseNumber: "157A", location: "SJSU", units: 3);
    Class class31 = Class(
        subjectArea: "CS", courseNumber: "175", location: "SJSU", units: 3);
    Class class41 = Class(
        subjectArea: "CS", courseNumber: "152", location: "SJSU", units: 3);

    Club club12 =
        Club(title: "Computer science club", location: "Macquarrie Hall");
    Club club11 = Club(title: "Jogging club", location: "Pier 18");
    Club club21 = Club(title: "Hiking club", location: "Mission Peak");
    Club club31 = Club(title: "Shooting club", location: "Morgan Hill");
    term1.addClass(class11);
    term1.addClass(class21);
    term1.addClass(class31);
    term1.addClass(class41);

    term1.addClub(club12);
    term1.addClub(club11);
    term1.addClub(club21);
    term1.addClub(club31);

    List<AcademicTerm> actualTerms = List();
    actualTerms.add(term);
    actualTerms.add(term1);

    AllTerms terms = AllTerms();
    terms.addTerm(term);
    terms.addTerm(term1);

    String jsonString = json.encode(terms);
    final jsonList = json.decode(jsonString);
    AllTerms t = AllTerms.fromJson(jsonList);
    List<AcademicTerm> allTheTerms = t.terms;
    //print(jsonList);
    
    expect(allTheTerms.length, equals(actualTerms.length));

    print(jsonString);
  });
}
