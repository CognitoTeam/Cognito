import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cognito/database/database.dart';
import 'package:cognito/models/academic_term.dart';
import 'package:cognito/models/assignment.dart';
import 'package:cognito/models/class.dart';
import 'package:cognito/models/gpa_calculator.dart';
import 'package:cognito/models/grade_calculator.dart';
import 'package:cognito/views/main_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GPATermsProviderView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    DataBase db = DataBase();
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    return Container(
      child: StreamProvider<List<AcademicTerm>>.value(
        value: db.streamTerms(user),
        child: GPAView(),
      ),
    );
  }
}

class GPAView extends StatefulWidget {

  @override
  _GPAViewState createState() => _GPAViewState();
}

class _GPAViewState extends State<GPAView> {
  DataBase database = DataBase();

  List<Widget> allTermGPA(List<AcademicTerm> terms, FirebaseUser user) {
    List<Widget> all = List();
    GPACalculator gpa = GPACalculator();
    for (AcademicTerm t in terms) {
      gpa.addTerm(t, user);
    }
    //Get GPA of each term
    for (AcademicTerm t in gpa.termsMap.keys) {
      all.add(ListTile(
        title: Text(t.termName),
        trailing: Text(gpa.termsMap[t].toStringAsFixed(2)),
      ));
    }
    return all;
  }

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  double calculateGPA(List<AcademicTerm> terms, FirebaseUser user) {
    GPACalculator gpa = GPACalculator();
    for (AcademicTerm t in terms) {
      gpa.addTerm(t, user);
    }
    return gpa.gpa;
  }

  Widget getClasses(AcademicTerm term, FirebaseUser user) {
    return StreamProvider<List<Class>>.value(
      value: database.streamClasses(user, term),
      child: TermClassesView(term)
    );
  }

  Widget rowOfTermsAndGPA(FirebaseUser user, List<AcademicTerm> terms)
  {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: getClasses(terms[index], user)
        );
      },
      itemCount: 1,
    );
  }

  String averageGPA(List<String> gpaList)
  {
    double sum = 0;
    for(String gpa in gpaList)
      {
        if(gpa == null || gpa == "Grades not issued") continue;
        sum += double.parse(gpa);
      }
    print("sum: " + sum.toString());
    return num.parse((sum/gpaList.length).toStringAsFixed(3)).toString();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    List<AcademicTerm> terms = Provider.of<List<AcademicTerm>>(context);
    List<String> termsGPA = List();
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text("GPA", style: Theme
            .of(context)
            .primaryTextTheme
            .title,),
        backgroundColor: Theme
            .of(context)
            .primaryColorDark,),
      body:
        terms != null && terms.length > 0 ? ListView.builder(
          itemBuilder: (context, index) {
            if(index < terms.length) {
              termsGPA.add(terms[index].gpa);
              return Padding(
                padding: EdgeInsets.all(16.0),
                child: getClasses(terms[index], user),
              );
            }else
              {
                print("Overall GPA: " + averageGPA(termsGPA));
                return Padding(
                  padding: EdgeInsets.all(16.0),
                  child: ListTile(title: Text("Overall GPA"),
                  trailing: Text(averageGPA(termsGPA)),),
                );
              }
          },
          itemCount: terms.length + 1,
        )
            :
        ListTile(title: Text("No GPA Yet"),)
    );
  }
}

class TermClassesView extends StatelessWidget {

  final AcademicTerm term;

  TermClassesView(this.term);

  @override
  Widget build(BuildContext context) {
    ScrollController _scrollController = new ScrollController();
    List<Class> classes = Provider.of<List<Class>>(context);
    return Container(
      child: ListView(
        shrinkWrap: true,
        children: _term(classes),
        controller: _scrollController,
      ),
    );
  }


  List<Widget> _term(List<Class> classes) {
    List<Widget> classesList = List();
    List<String> gradeLetters = List();
    classesList.add(ListTile(
      title: Text(term.termName),
    ));
    if(classes != null) {
      classes.forEach((Class c) {
        term.classes.add(c);
        classesList.add(
            _class(c),
        );
        if(c.gradeLetter != null)
          {
            gradeLetters.add(c.gradeLetter);
          }
      });
    }
    GPACalculator gpaCalculator = GPACalculator();
    String gpaDisplay = gpaCalculator.getGPAFromGradeLetters(gradeLetters);
    //TODO: grades is returning nothing and override correct answer
    term.gpa = gpaDisplay;
    print(gpaDisplay);
      classesList.add(ListTile(title: Text(term.termName + " GPA:"),
          trailing: Text(
              gpaDisplay
          )));
    return classesList;
  }

  Widget _class(Class c) {
    DataBase db = DataBase();
    return StreamBuilder(
        stream: Firestore.instance.collection('classes').document(c.id).collection("assignments").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          c.assignments.clear();
          c.assessments.clear();
          List<Assignment> assignments = List();
          List<Assignment> assessments = List();
          if (snapshot.data != null && snapshot.data.documents.length > 0) {
            for (int i = 0; i <= snapshot.data.documents.length - 1; i++) {
              Assignment c = db.documentToAssignment(snapshot.data.documents[i]);
              if(c.isAssessment)
                {
                  assessments.add(c);
                }
              else
                {
                  assignments.add(c);

                }
            }
          }
          c.assessments = assessments;
          c.assignments = assignments;
          String grade = calculateGrade(c);
          return ListTile(
            title: Text(c.subjectArea + " " + c.courseNumber),
            trailing: Text(grade),
          );
    });
  }

  String calculateGrade(Class c){
    GradeCalculator calculator = new GradeCalculator(c.returnCategories(), c.returnGradeBook());
    calculator.calculateGrade();
    c.gradeLetter = calculator.letterGrade;
    return c.gradeLetter;
  }
}

class ClassGrade extends StatelessWidget {
  final Class c;
  ClassGrade(this.c);

  @override
  Widget build(BuildContext context) {
    //List<Assignment> assignments = Provider.of<List<Assignment>>(context) ?? [];
    //print(assignments.length);
    return ListTile(
          title: Text(c.subjectArea + " " + c.courseNumber),
          trailing: Text("Calculate"),
        );
  }

}