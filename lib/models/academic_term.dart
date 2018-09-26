///Model for Academic term
///@author Praneet Singh

import 'package:cognito/models/class.dart';
import 'package:cognito/models/club.dart';

class AcademicTerm {

    DateTime startTime; //Academic term start 
    DateTime endTime;   //Academic term end

    Set<Class> classes;
    Set<Club> clubs;

    AcademicTerm(this.startTime, this.endTime){
      classes = Set();
      clubs = Set();
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
}