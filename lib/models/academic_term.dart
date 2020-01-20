import 'package:cloud_firestore/cloud_firestore.dart';
///Model for Academic term
///@author Praneet Singh

import 'package:cognito/models/class.dart';
import 'package:cognito/models/club.dart';
import 'package:cognito/models/event.dart';
import 'package:cognito/models/task.dart';
import 'package:json_annotation/json_annotation.dart';
//part 'academic_term.g.dart';

@JsonSerializable()

class AcademicTerm {
    String termName;
    DateTime startTime; //Academic term start
    DateTime endTime;   //Academic term end
    String id;
    List<Class> classes;
    List<Club> clubs;
    List<Task> tasks;
    List<Event> events;
    double gpa;
    AcademicTerm({this.id, this.termName, this.startTime, this.endTime}){
      classes = List();
      clubs = List();
      tasks = List();
      events = List();
    }

    factory AcademicTerm.fromFirestore(DocumentSnapshot doc) {
      Map data = doc.data;
      AcademicTerm term = new AcademicTerm(
        id: doc.documentID.toString(),
        termName: data['term_name'],
        startTime: data['start_date'].toDate(),
        endTime: data['end_date'].toDate(),
      );
      term.gpa = data['gpa'].toDouble();
      return term;
    }

    Map<String, double> gradePointsMultiplier = {
      //Maps Letter grade to GP multiplier
      "A+": 4.0,
      "A": 4.0,
      "A-": 3.7,
      "B+": 3.3,
      "B": 3.0,
      "B-": 2.7,
      "C+": 2.3,
      "C": 2.0,
      "C-": 1.7,
      "D+": 1.3,
      "D": 1.0,
      "D-": 0.7,
      "F+": 0.0,
      "F": 0.0
    };

    String getStartDateAsString() {
      return "${startTime.month}/${startTime.day}/${startTime.year}";
    }

    String getEndDateAsString() {
      return "${endTime.month}/${endTime.day}/${endTime.year}";
    }

    String getID(){
      return id;
    }
    void addEvent(Event event){
      events.add(event);
    }

    void removeEvent(Event event){
      events.remove(event);
    }
    void addTask(Task task){
      tasks.add(task);
    }
    void removeTask(Task task){
      tasks.remove(task);
    }
    void addClass(Class aClass){
      classes.add(aClass);
    }

    void addClub(Club club){
      clubs.add(club);
    }

    void removeClass(Class aClass){
      classes.remove(aClass);
    }

    void removeClub(Club club){
      clubs.remove(club);
    }

    @override
    String toString() {
      return this.termName + this.startTime.toIso8601String() + this.endTime.toIso8601String();
    }


}