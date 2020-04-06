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
  List<double> termsGPA = List();

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    List<AcademicTerm> terms = Provider.of<List<AcademicTerm>>(context)??[];
    List<double> termsGPA = List();
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
        ListView(
          shrinkWrap: true,
          children: list(terms, user, termsGPA),
        )
    );
  }

  List<Widget> list(List<AcademicTerm> terms, FirebaseUser user, List<double> termsGPA) {
    List<Widget> retWidget = List();
    double projectSum = 0;
    double currentSum = 0;
    for(AcademicTerm term in terms) {
      projectSum += term.gpa;
      if(term.endTime.isBefore(DateTime.now()))
        {
          currentSum += term.gpa;
        }
      retWidget.add(Padding(
        padding: EdgeInsets.all(16.0),
        child: getClasses(term, user, termsGPA),
      ));
    }
    if(terms != null && terms.length != 0) {
      retWidget.add(Padding(
        padding: EdgeInsets.all(16.0),
        child: ListTile(title: Text("Finalized GPA"),
          trailing: Text(
              (currentSum / (terms.length.toDouble())).toString()),),));
      retWidget.add(Padding(
        padding: EdgeInsets.all(16.0),
        child: ListTile(title: Text("Projected GPA"),
          trailing: Text(
              (projectSum / (terms.length.toDouble())).toString()),),));
    }
    else {
      ListTile(title: Text("No GPA Yet"),);
    }
    return retWidget;
  }

  Widget getClasses(AcademicTerm term, FirebaseUser user, List<double> termsGPA) {
    return StreamProvider<List<Class>>.value(
        value: database.streamClasses(user, term),
        child: TermClassesView(term, termsGPA)
    );
  }
}

class TermClassesView extends StatefulWidget {

  final AcademicTerm term;
  final List<double> termsGPA;

  TermClassesView(this.term, this.termsGPA);

  @override
  _TermClassesViewState createState() => _TermClassesViewState();
}

class _TermClassesViewState extends State<TermClassesView> {

  @override
  Widget build(BuildContext context) {
    ScrollController _scrollController = new ScrollController();
    List<Class> classes = Provider.of<List<Class>>(context) ?? [];
    return ListView(
      children: _term(classes),
      controller: _scrollController,
      shrinkWrap: true,
    );
  }


  List<Widget> _term(List<Class> classes) {
    List<Widget> classesList = List();
    classesList.add(ListTile(
      title: Text(widget.term.termName),
    ));
    classes.forEach((Class c) {
        classesList.add(
            _class(c),
        );
      });
    classes.length != 0 ?
      classesList.add(ListTile(title: Text(widget.term.termName + " GPA:"),
          trailing: Text(
              widget.term.gpa.toString()
          ))):
      classesList.add(ListTile(title: Text(widget.term.termName + " GPA:"),
        trailing: Text(
            "TBA"
        )));
    return classesList;
  }

  Widget _class(Class c) {
    return ListTile(
      title: Text(c.subjectArea + " " + c.courseNumber),
      trailing: Text(calculateGrade(c)),
    );
  }

  String calculateGrade(Class c){
    GradeCalculator calculator = new GradeCalculator(c.returnCategories(), c.returnGradeBook());
    calculator.percentage = c.grade;
    return calculator.getLetterGrade();
  }
}