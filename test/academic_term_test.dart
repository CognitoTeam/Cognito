import 'dart:convert';

///Tester for Academic Term model

import 'package:cognito/models/academic_term.dart';
import 'package:cognito/models/class.dart';
import 'package:test/test.dart';
import 'package:cognito/models/club.dart';

void main() {
  test('Add class to set of classes', () {
    AcademicTerm term =
        AcademicTerm(termName: "Spring 2018", startTime: DateTime(2018), endTime: DateTime(2019));
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
    for (Class c in term.classes) {
      print(c.courseNumber);
    }
    expect(term.classes.length, equals(4));
    for (Club c in term.clubs) {
      print(c.title);
    }
    expect(term.clubs.length, equals(4));

    term.removeClass(class1);
    term.removeClub(club2);
    for (Class c in term.classes) {
      print(c.courseNumber);
    }
    expect(term.classes.length, equals(3));
    for (Club c in term.clubs) {
      print(c.title);
    }
    expect(term.clubs.length, equals(3));
  });

  test('Academic Term to JSON', () {
    AcademicTerm term =
        AcademicTerm(termName: "Spring 2018", startTime: DateTime(2018), endTime: DateTime(2019));
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
    print("Classes:");
    for (Class c in term.classes) {
      print(c.courseNumber);
    }
    expect(term.classes.length, equals(4));

    for (Club c in term.clubs) {
      print(c.title);
    }
    expect(term.clubs.length, equals(4));


    String jsonString = json.encode(term);
    final jsonEvent = json.decode(jsonString);

//    AcademicTerm academicTerm = AcademicTerm.fromJson(jsonEvent);
    print(jsonString);

//    print("Classes:");
//    for (Class c in academicTerm.classes) {
//      print(c.courseNumber);
//    }
//    expect(academicTerm.classes.length, equals(term.classes.length));
//    for (Club c in academicTerm.clubs) {
//      print(c.title);
//    }
//    expect(academicTerm.clubs.length, equals(term.clubs.length));
    
  });
}
