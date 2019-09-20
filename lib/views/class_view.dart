// Copyright 2019 UniPlan. All rights reserved.

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cognito/database/database.dart';
import 'package:cognito/database/notifications.dart';
import 'package:cognito/models/academic_term.dart';
import 'package:cognito/models/assignment.dart';
import 'package:cognito/models/class.dart';
import 'package:cognito/models/category.dart';
import 'package:cognito/views/add_class_view.dart';
import 'package:cognito/views/class_editing_view.dart';
import 'package:cognito/views/gradebook_view.dart';
import 'package:cognito/views/main_drawer.dart';
import 'package:flutter/material.dart';

/// Class view
/// Displays list of Class cards
/// [author] Julian Vu
class ClassView extends StatefulWidget {
  @override
  _ClassViewState createState() => _ClassViewState();
}

class _ClassViewState extends State<ClassView> {
  Notifications noti = Notifications();
  AcademicTerm term;
  List<Class> classes;
  Class undoClass;
  DataBase database = DataBase();
  String classDocID = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      updateTerm();
      updateClasses();
    });
  }

  /// Removes class from [AcademicTerm]
  void removeClass(Class classToRemove) {
    setState(() {
      term.removeClass(classToRemove);
      database.removeClass(classToRemove, term);
    });
  }

  Future updateClasses() async {
    classes = await database.getClasses();
  }

  /// Gets the current [AcademicTerm]
  AcademicTerm updateTerm() {
    for (AcademicTerm term in database.allTerms.terms) {
      if (DateTime.now().isAfter(term.startTime) &&
          DateTime.now().isBefore(term.endTime)) {
        this.term = term;
        return term;
      }
    }
    return null;
  }

  /// Shows bottom modal sheet for creating a [Class]
  Future<Class> _showModalSheet() async {
    final classToReturn = await showModalBottomSheet(
        context: context,
        builder: (builder) {
          return AddClassView(term);
        });
    return classToReturn;
  }

  /// Re-adds [Class] into [AcademicTerm] after being deleted
  void undo(Class undo) {
    setState(() {
      term.addClass(undo);
    });
  }

  Future updateGradebookValues(Class c)
  async {
    //TODO: these are empty when there is more than one class
    List<Assignment> assignments = await database.getAssignments(c, term, false);
    List<Assignment> assessments = await database.getAssignments(c, term, true);
    List<Category> categories = await database.getCategories(c, term);
    //c is passed by reference
    c.assessments = assessments;
    c.assignments = assignments;
    c.categories = categories;
    return [assignments, assessments, categories];
  }
  /// Gets the grade from this the given [Class]
  //TODO: Not graded when there are more than one classes
  Future<String> calculateGrade(Class c) async {
    var gradeBookValue = await updateGradebookValues(c);
    String value = c.getGrade(gradeBookValue[1], gradeBookValue[0], gradeBookValue[2]);
    return "Grade: " + value;
  }


  Future updateClassStream(Class c) async
  {
    QuerySnapshot snapshot = await Firestore.instance.collection('classes')
        .where('user_id', isEqualTo: database.userID)
        .where('term_name', isEqualTo: term.termName)
        .where('title', isEqualTo: c.title)
        .where('instructor', isEqualTo: c.instructor).getDocuments();
    //This is the document of grades now we need assignments collection doc
    if(snapshot.documents.length == 1)
    {
      classDocID = snapshot.documents[0].documentID;
    }
    else if(snapshot.documents.length > 1)
    {
      print("ERROR: Query for grade found more than 1 length");
    }
  }

  /// Builds [Card]s from the [AcademicTerm]'s list of [Class] objects
  /// in the form of a [ListView]
  Widget _getClassCards() {
    Query classesForUserQuery = Firestore.instance.collection("classes")
        .where('user_id', isEqualTo: database.userID)
        .where('term_name', isEqualTo: term.termName);
    return StreamBuilder<QuerySnapshot>(
      stream: classesForUserQuery.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

        if(snapshot.hasData) {
          return new ListView(
            children: snapshot.data.documents.map((document) {
              Class classObj = database.documentToClass(document);
              updateClassStream(classObj);
              updateGradebookValues(classObj);
              return Container(
                margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                child: InkWell(
                  onTap: () async {
                    for (int i in classObj.daysOfEvent) {
                      noti.cancelNotification(classObj.id);
                    }
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                GradeBookView(
                                  selectedClass: classObj,
                                  term: term,
                                )));

                    for (int i in classObj.daysOfEvent) {
                      noti.showWeeklyAtDayAndTime(
                          title: classObj.title,
                          body: classObj.title + " is starting in 15 mins",
                          id: classObj.id,
                          dayToRepeat: i,
                          timeToRepeat:
                          classObj.startTime.subtract(Duration(minutes: 15)));
                    }
                  },
                  child: Dismissible(
                    key: Key(classObj.toString()),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction)
                    {
                      for (int i in classObj.daysOfEvent) {
                        noti.cancelNotification(classObj.id);
                      }

                      undoClass = classObj;
                      snapshot.data.documents.remove(document);
                      database.removeClass(classObj, term);
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text("${classObj.title} deleted"),
                        action: SnackBarAction(
                          label: "Undo",
                          onPressed: () {
                            undo(undoClass);
                          },
                        ),
                        duration: Duration(seconds: 3),
                      ));
                    },
                    child: Card(
                      elevation: 10.0,
                      color: Theme
                          .of(context)
                          .primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      //StreamBuilder stream of only one
                      child:  ListTile(
                              leading: Icon(
                                Icons.label,
                                color: Colors.white,
                              ),
                              subtitle: new FutureBuilder(
                                //TODO: Not graded when there are more than one classes
                                  future: calculateGrade(classObj),
                                  builder: (BuildContext context, AsyncSnapshot<String> snapshot){
                                    updateGradebookValues(classObj);
                                    switch(snapshot.connectionState) {
                                      case ConnectionState.waiting:
                                        return new Text(
                                        'Calculting result...',
                                            style: Theme
                                            .of(context)
                                            .primaryTextTheme
                                            .body1,
                                      );
                                      default:
                                        return new Text(
                                          '${snapshot.data}',
                                              style: Theme
                                              .of(context)
                                              .primaryTextTheme
                                              .body1,
                                        );
                                    }
                              }),
                              title: Text(
                                classObj.subjectArea +
                                    " " +
                                    classObj.courseNumber +
                                    " - " +
                                    classObj.title,
                                style: Theme
                                    .of(context)
                                    .primaryTextTheme
                                    .body1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.info_outline,
                                  color: Colors.white,
                                ),
                                onPressed: () async {
                                  for (int i in classObj.daysOfEvent) {
                                    noti.cancelNotification(classObj.id);
                                  }
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ClassEditingView(
                                                  classObj: classObj)));

                                  for (int i in classObj.daysOfEvent) {
                                    noti.showWeeklyAtDayAndTime(
                                        title: classObj.title,
                                        body: classObj.title +
                                            " is starting in 15 mins",
                                        id: classObj.id,
                                        dayToRepeat: i,
                                        timeToRepeat: classObj.startTime
                                            .subtract(Duration(minutes: 15)));
                                  }
                                },
                              ),
                            )
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        }
        else
          {
            return new Container();
          }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
//    updateGradeStream(term);
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text(
          term.termName + " - Classes",
          style: Theme.of(context).primaryTextTheme.title,
        ),
        backgroundColor: Theme.of(context).primaryColorDark,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Class result = await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AddClassView(term)));
          if (result != null) {
            setState(() {});
            for (int i in result.daysOfEvent) {
              noti.showWeeklyAtDayAndTime(
                  title: result.title,
                  body: result.title + " is starting in 15 mins",
                  id: result.id,
                  dayToRepeat: i,
                  timeToRepeat:
                      result.startTime.subtract(Duration(minutes: 15)));
            }
          }
        },
        child: Icon(
          Icons.add,
          size: 42.0,
        ),
        backgroundColor: Theme.of(context).accentColor,
        foregroundColor: Colors.black,
      ),
      body: _getClassCards(),
    );
  }
}
