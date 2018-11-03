///Model for Academic term
///@author Praneet Singh

import 'package:cognito/models/class.dart';
import 'package:cognito/models/club.dart';
import 'package:cognito/models/event.dart';
import 'package:cognito/models/task.dart';
import 'package:json_annotation/json_annotation.dart';
part 'academic_term.g.dart';

@JsonSerializable()

class AcademicTerm {
    String termName;
    DateTime startTime; //Academic term start 
    DateTime endTime;   //Academic term end

    Set<Class> classes;
    Set<Club> clubs;
    Set<Task> tasks;
    Set<Event> events;
    AcademicTerm(this.termName, this.startTime, this.endTime){
      classes = Set();
      clubs = Set();
      tasks = Set();
      events = Set();
    }
    factory AcademicTerm.fromJson(Map<String, dynamic> json) => _$AcademicTermFromJson(json);


  Map<String, dynamic> toJson() => _$AcademicTermToJson(this);

    String getStartDateAsString() {
      return "${startTime.month}/${startTime.day}/${startTime.year}";
    }

    String getEndDateAsString() {
      return "${endTime.month}/${endTime.day}/${endTime.year}";
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