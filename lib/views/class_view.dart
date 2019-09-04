// Copyright 2019 UniPlan. All rights reserved.

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cognito/database/database.dart';
import 'package:cognito/database/notifications.dart';
import 'package:cognito/models/academic_term.dart';
import 'package:cognito/models/class.dart';
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

  /// Gets the grade from this the given [Class]
  String calculateGrade(Class c) {
    return "Grade: " + c.getGrade();
  }

  /// Builds [Card]s from the [AcademicTerm]'s list of [Class] objects
  /// in the form of a [ListView]
  Widget _getClassCards() {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection("classes")
          .where('user_id', isEqualTo: database.userID)
          .where('term_name', isEqualTo: term.termName).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if(snapshot.hasData) {
          return new ListView(
            children: snapshot.data.documents.map((document) {
              Class classObj = database.documentToClass(document);
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
                    onDismissed: (direction) {
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
                      child: ListTile(
                        leading: Icon(
                          Icons.label,
                          color: Colors.white,
                        ),
                        subtitle: Text(
                          calculateGrade(classObj),
                          style: Theme
                              .of(context)
                              .primaryTextTheme
                              .body1,
                        ),
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
                                        ClassEditingView(classObj: classObj)));

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
                      ),
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
