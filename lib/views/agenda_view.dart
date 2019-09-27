// Copyright 2019 UniPlan. All rights reserved.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cognito/database/database.dart';
import 'package:cognito/database/notifications.dart';
import 'package:cognito/models/academic_term.dart';
import 'package:cognito/models/all_terms.dart';
import 'package:cognito/models/assignment.dart';
import 'package:cognito/models/class.dart';
import 'package:cognito/models/event.dart';
import 'package:cognito/views/add_assessment_view.dart';
import 'package:cognito/views/add_assignment_view.dart';
import 'package:cognito/views/add_event_view.dart';
import 'package:cognito/views/assessment_details_view.dart';
import 'package:cognito/views/assignment_details_view.dart';
import 'package:cognito/views/calendar_view.dart';
import 'package:cognito/views/class_details_view.dart';
import 'package:cognito/views/event_details_view.dart';
import 'package:cognito/views/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../views/utils/PriorityAgenda/priority_agenda.dart';
import '../views/utils/main_agenda.dart';

/// Agenda view screen
/// Displays daily agenda
/// @author Julian Vu

class AgendaView extends StatefulWidget {
  AcademicTerm term;

  AgendaView(AcademicTerm term)
  {
    if(term == null)
      {
        term = new AcademicTerm("", null, null);
      }
    else
      {
        this.term = term;
      }
  }

  @override
  _AgendaViewState createState(){
    return _AgendaViewState();
  }
}

class _AgendaViewState extends State<AgendaView>
    with SingleTickerProviderStateMixin {

  int _currentIndex = 0;

  Notifications noti = Notifications();

  DateTime selectedDate;

  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeIn;
  double _fabHeight = 56.0;
  DataBase database = DataBase();

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedDate = DateTime.now();
      database.getCurrentTerm();
    });
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200))
          ..addListener(() {
            setState(() {});
          });
    _buttonColor = ColorTween(
      begin: Color(0xFFfbc02d),
      end: Colors.red,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  List<Widget> _listOfClassAssign(AsyncSnapshot<QuerySnapshot> snapshot) {
    List<Widget> listTasks = List();
          if (snapshot.data.documents.length == 0 ||snapshot.hasData) {
              snapshot.data.documents.forEach((document) {
                Class c = database.documentToClass(document);
                listTasks.add(
                  ListTile(
                      title: Text(
                        c.title,
                        style: Theme.of(context).accentTextTheme.body2,
                      ),
                      onTap: () async {
                        setState(() {
                          isOpened = !isOpened;
                          animate();
                        });

                        Navigator.of(context).pop();
                        Assignment result =
                        await Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AddAssignmentView(
                              aClass: c,
                              term: widget.term,
                            )));
//                        if (result != null) {
//                          DateTime dateTime = DateTime(
//                              result.dueDate.year,
//                              result.dueDate.month,
//                              result.dueDate.day,
//                              c.startTime.hour,
//                              c.startTime.minute);
//                          dateTime = dateTime.subtract(Duration(minutes: 15));
//                          noti.scheduleNotification(
//                              title: "Assignment due",
//                              body: result.title +
//                                  " for " +
//                                  c.title +
//                                  " is due at " +
//                                  dateTime.hour.toString() +
//                                  ":" +
//                                  dateTime.minute.toString(),
//                              dateTime: dateTime,
//                              id: result.id);
//                          c.addTodoItem(c.ASSIGNMENTTAG, assignment: result);
//                          database.updateDatabase();
//                        }
                      }),
                );
              });
            } else {
            listTasks.add(ListTile(
              title: Text(
                "No classes have been added yet!",
                style: Theme.of(context).accentTextTheme.body2,
              ),
            ));
          }
    return listTasks;
  }

  List<Widget> _listOfClassAssess(AsyncSnapshot<QuerySnapshot> snapshot) {
    List<Widget> listTasks = List();
          if (snapshot.data.documents.length == 0 || snapshot.hasData) {
            snapshot.data.documents.forEach((document){
              Class c = database.documentToClass(document);
              listTasks.add(
                ListTile(
                    title: Text(
                      c.title,
                      style: Theme.of(context).accentTextTheme.body2,
                    ),
                    onTap: () async {
                      setState(() {
                        isOpened = !isOpened;
                        animate();
                      });

                      Navigator.of(context).pop();
                      Assignment result =
                      await Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AddAssessmentView(
                            aClass: c,
                            term: widget.term,
                          )));
                      if (result != null) {

                        c.addTodoItem(c.ASSESSMENTTAG, assignment: result);
                        database.updateDatabase();
                      }
                    }),
              );
            });
          } else {
            listTasks.add(ListTile(
              title: Text(
                "No classes have been added yet!",
                style: Theme.of(context).accentTextTheme.body2,
              ),
            ));
          }
    return listTasks;
  }

  Widget assessment() {
          return Container(
            child: FloatingActionButton(
              heroTag: "assessmentButton",
              onPressed: () {
                setState(() {
                  animate();
                });
                showDialog(
                context: context,
                builder: (BuildContext context) {
                  return StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance.collection('classes')
                          .where('user_id', isEqualTo: database.userID)
                          .where('term_name', isEqualTo: widget.term.termName)
                          .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        return SimpleDialog(
                            title: Text("Choose a class"),
                            children: _listOfClassAssess(snapshot));
                      });
                });
              },
              tooltip: 'Assessment',
              child: Icon(Icons.assessment),
            ),
          );
  }

  Widget assignment() {
          return Container(
            child: FloatingActionButton(
            heroTag: "assignmentButton",
            onPressed: () {
              setState(() {
                animate();
              });
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance.collection('classes')
                      .where('user_id', isEqualTo: database.userID)
                      .where('term_name', isEqualTo: widget.term.termName).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  return SimpleDialog(
                    title: Text("Choose a class"),
                    children: _listOfClassAssign(snapshot));
                  }
                  );
              }
            );
            },
            tooltip: 'Assignment',
            child: Icon(Icons.assignment),
            ),
          );
  }

  Widget event() {
    return Container(
      child: FloatingActionButton(
        heroTag: "eventButton",
        onPressed: () async {
          Event result = await Navigator.of(context)
          //TODO: Add Event
              .push(MaterialPageRoute(builder: (context) => AddEventView(null)));
          if (result != null) {
            //result occurs in a day
            if (result.daysOfEvent.isNotEmpty) {
              //on that day show notification 15 minutes before
              for (int i in result.daysOfEvent) {
                noti.showWeeklyAtDayAndTime(
                    title: "Event starting",
                    body: result.title + " is starting in 15 mins",
                    id: result.id,
                    dayToRepeat: i,
                    timeToRepeat:
                        result.startTime.subtract(Duration(minutes: 15)));
              }
            } else {
              DateTime now = DateTime.now();
              DateTime input;
              if (result.startTime.hour < now.hour ||
                  result.endTime.hour < now.hour ||
                  (result.startTime.hour == now.hour &&
                      result.startTime.minute < now.minute) ||
                  (result.endTime.hour == now.hour &&
                      result.endTime.minute < now.minute)) {
                print("CONDITIONS MET");
                input = DateTime(now.year, now.month, now.day,
                    result.startTime.hour, result.startTime.minute);
                input.add(Duration(days: 1));
              } else {
                print("CONDITIONS NOT MET");

                input = DateTime(now.year, now.month, now.day,
                    result.startTime.hour, result.startTime.minute);
              }
              input.subtract(Duration(minutes: 15));
              noti.scheduleNotification(
                  title: "Event today",
                  body: result.title + " will take place in 15 mins.",
                  dateTime: input,
                  id: result.id);
            }

            print(
              "Event returned: " + result.title,
            );
            widget.term.addEvent(result);
            database.updateDatabase();
          }
          setState(() {
            animate();
          });
        },
        tooltip: 'Event',
        child: Icon(Icons.event),
      ),
    );
  }

  Widget toggle() {
    return Container(
      child: FloatingActionButton(
          heroTag: "mainButton",
          backgroundColor: _buttonColor.value,
          onPressed: animate,
          tooltip: 'Toggle',
          child: Icon(Icons.add)),
    );
  }

  @override
  Widget build(BuildContext context) {

    Expanded mainAgenda = Expanded(
      child: ListView(
        children: <Widget>[
          FilteredClassExpansion(widget.term, selectedDate, database),
          FilteredAssignmentExpansion(
              widget.term, selectedDate, false, database),
          FilteredAssignmentExpansion(
              widget.term, selectedDate, true, database),
          FilteredEventExpansion(widget.term, selectedDate, database),
        ],
      ),
    );

    Expanded priorityAgenda = Expanded(
      child: new PriorityAgenda("PriorityAgenda"),
    );
    
    void onTabTapped(int index)
    {
      //print(index);
      setState(
          () {
            _currentIndex = index;
          }
      );
    }

    return Scaffold(
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Transform(
              transform: Matrix4.translationValues(
                0.0,
                _translateButton.value * 3.0,
                0.0,
              ),
              child: assignment(),
            ),
            Transform(
              transform: Matrix4.translationValues(
                0.0,
                _translateButton.value * 2.0,
                0.0,
              ),
              child: assessment(),
            ),
            Transform(
              transform: Matrix4.translationValues(
                0.0,
                _translateButton.value,
                0.0,
              ),
              child: event(),
            ),
            toggle(),
          ],
        ),
        drawer: MainDrawer(),
        appBar: AppBar(
          elevation: 0,
          title: Text(
            DateFormat.MMMMEEEEd().format(selectedDate),
            style: Theme.of(context).primaryTextTheme.title,
          ),
          backgroundColor: Theme.of(context).primaryColorDark,
        ),

        body: Column(
          children: <Widget>[
            CalendarView(
              onDateSelected: (DateTime date) {
                setState(() {
                  selectedDate = date;
                });
              },
            ),
            (_currentIndex == 0) ? mainAgenda : priorityAgenda
          ],
        ),
        bottomNavigationBar : BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: onTabTapped,
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.home),
              title: new Text('Agenda'),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.list),
              title: new Text('Priorities'),
            ),
          ],
        ),
    );
  }
}

class FilteredClassExpansion extends StatefulWidget {
  final AcademicTerm term;
  final DateTime date;
  final DataBase database;

  FilteredClassExpansion(this.term, this.date, this.database);

  @override
  _FilteredClassExpansionState createState() => _FilteredClassExpansionState();
}

class _FilteredClassExpansionState extends State<FilteredClassExpansion> {
  Notifications noti = Notifications();

  List<Widget> _classes(AsyncSnapshot<QuerySnapshot> snapshot) {
    List<Widget> classesList = List();
    if(snapshot.data != null) {
      snapshot.data.documents.forEach((document) {
        Class c = widget.database.documentToClass(document);
        if (c.daysOfEvent.contains(widget.date.weekday)) {
          classesList.add(ListTile(
            title: Text(
              c.subjectArea + " " + c.courseNumber + " - " + c.title,
              style: Theme
                  .of(context)
                  .accentTextTheme
                  .body2,
            ),
            subtitle: Text(DateFormat.jm().format(c.startTime) +
                " - " +
                DateFormat.jm().format(c.endTime)),
            onTap: () async {
              noti.cancelNotification(c.id);

              Class result = await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      ClassDetailsView(
                        classObj: c,
                      )));
              if (result != null) {
                print("Class updated: " + result.title);
                widget.database.updateDatabase();
                for (int i in result.daysOfEvent) {
                  noti.showWeeklyAtDayAndTime(
                      title: result.title,
                      body: result.title + " is starting in 15 mins",
                      id: result.id,
                      dayToRepeat: i,
                      timeToRepeat:
                      result.startTime.subtract(Duration(minutes: 15)));
                }
                setState(() {});
              }
            },
          ));
        }
      }
      );
    }
      if(classesList.length == 0)
        {
          classesList.add(ListTile(
              title: Text(
                "No classes today",
                style: Theme.of(context).accentTextTheme.body2,
              )));
        }
    return classesList;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.term != null) {
      return StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('classes')
              .where('user_id', isEqualTo: widget.database.userID)
              .where('term_name', isEqualTo: widget.term.termName).snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshot) {
            return ExpansionTile(

              leading: Icon(Icons.class_),
              title: Text(
                "Classes",
                style: Theme
                    .of(context)
                    .accentTextTheme
                    .body2,
              ),
              children: _classes(snapshot),
              initiallyExpanded: true,
            );
          });
    }
    else {
      return ExpansionTile(

        leading: Icon(Icons.class_),
        title: Text(
          "Classes",
          style: Theme
              .of(context)
              .accentTextTheme
              .body2,
        ),
        children: [ListTile(
            title: Text(
              "No classes today",
              style: Theme.of(context).accentTextTheme.body2,
            ))],
        initiallyExpanded: true,
      );
    }
  }
}

class FilteredAssignmentExpansion extends StatefulWidget {
  final AcademicTerm term;
  final DateTime date;
  final bool isAssessment;
  final DataBase database;

  FilteredAssignmentExpansion(
      this.term, this.date, this.isAssessment, this.database);

  @override
  _FilteredAssignmentExpansionState createState() =>
      _FilteredAssignmentExpansionState();
}

class _FilteredAssignmentExpansionState
    extends State<FilteredAssignmentExpansion> {

  Notifications noti = Notifications();
  DateTime oneWeekFromToday = DateTime.now().add(Duration(days: 7));
  String docID = "";

  Future updateGradeStream(AcademicTerm term)
  async {
    QuerySnapshot snapshot = await Firestore.instance.collection('grades')
        .where('user_id', isEqualTo: widget.database.userID)
        .where('term_name', isEqualTo: term.termName).getDocuments();
    //This is the document of grades now we need assignments collection doc
    if(snapshot.documents.length == 1)
      {
        docID = snapshot.documents[0].documentID;
      }
    else if(snapshot.documents.length > 1)
      {
        print("ERROR: Query for grade found more than 1 length");
      }

  }

  @override
  Widget build(BuildContext context) {
    if(widget.term != null) {
      updateGradeStream(widget.term);
      return StreamBuilder<QuerySnapshot>(
        //Want multiple documents
        //Get to collection
        //docID may be null
          stream: (docID == "" ? null : Firestore.instance.collection('grades')
              .document(docID)
              .collection((widget.isAssessment ? 'assessments' : 'assignments'))
              .snapshots()),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshot) {
            return ExpansionTile(
              leading: Icon(Icons.class_),
              title: Text(
                widget.isAssessment ? "Assessments" : "Assignments",
                style: Theme
                    .of(context)
                    .accentTextTheme
                    .body2,
              ),
              children: _assignments(snapshot),
              initiallyExpanded: true,
            );
          });
    }
    else
      {
        return ExpansionTile(
            leading: Icon(Icons.class_),
            title: Text(
            widget.isAssessment ? "Assessments" : "Assignments",
            style: Theme
                .of(context)
                .accentTextTheme
                .body2,
            ),
            children: [ListTile(
                title: Text(
                  widget.isAssessment
                      ? "No assessments due today"
                      : "No assignments due today",
                  style: Theme
                      .of(context)
                      .accentTextTheme
                      .body2,
                ))],
            initiallyExpanded: true,
        );
      }
  }

  List<Widget> _assignments(AsyncSnapshot<QuerySnapshot> snapshot) {
    List<Widget> assignmentList = List();
    if (snapshot.hasData && snapshot.data.documents.length > 0) {
      snapshot.data.documents.forEach((document) async {
        Assignment a = widget.database.documentToAssignment(document);
        if (a.isAssessment) {
          bool isWithinWeek = a.dueDate.isAfter(widget.date) &&
              a.dueDate.isBefore(oneWeekFromToday);
          bool isDueToday = widget.date.day == a.dueDate.day &&
              widget.date.month == a.dueDate.month &&
              widget.date.year == a.dueDate.year;
          if (isWithinWeek || isDueToday) {
            QuerySnapshot snapshot = await Firestore.instance.collection("classes").where("user_id", isEqualTo: widget.database.userID)
                .where("title", isEqualTo: document['class_title']).where("subject_area", isEqualTo: document["class_subject"])
                .where("course_number", isEqualTo: document['class_number']).getDocuments();
            Class c = widget.database.documentToClass(snapshot.documents[0]);
            assignmentList.add(ListTile(
              title: Text(a.title),
              subtitle: Text(
                c.title,
              ),
              trailing: isDueToday
                  ? Text(
                "Today at " + DateFormat.jm().format(a.dueDate),
                style: TextStyle(color: Colors.red),
              )
                  : Text((a.dueDate
                  .difference(DateTime.now())
                  .inDays + 1)
                  .toString() +
                  " days"),
              onLongPress: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return SimpleDialog(
                          title: Text(
                              "Are you sure you want to delete " + a.title),
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                RaisedButton(
                                  color: Colors.white,
                                  child: Text("Yes"),
                                  onPressed: () {
                                    setState(() {
                                      c.assessments.remove(a);
                                      Navigator.of(context).pop();
                                      widget.database.updateDatabase();
                                    });
                                  },
                                ),
                                RaisedButton(
                                  color: Colors.white,
                                  child: Text("Cancel"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            )
                          ]);
                    });
              },
              onTap: () async {
                noti.cancelNotification(a.id);
                Assignment result =
                await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        AssessmentDetailsView(
                          aClass: c,
                          assignment: a,
                        )));
                if (result != null) {
                  print("Assessment updated: " + result.title);
                  DateTime dateTime = DateTime(
                      result.dueDate.year,
                      result.dueDate.month,
                      result.dueDate.day,
                      c.startTime.hour,
                      c.startTime.minute);
                  dateTime = dateTime.subtract(Duration(minutes: 15));
                  noti.scheduleNotification(
                      title: "Assignment due",
                      body: result.title +
                          " for " +
                          c.title +
                          " is due at " +
                          dateTime.hour.toString() +
                          ":" +
                          dateTime.minute.toString(),
                      dateTime: dateTime,
                      id: result.id);
                  widget.database.updateDatabase();
                  setState(() {});
                }
              },
            ));
          }
        }
        else {
          QuerySnapshot snapshot = await Firestore.instance.collection("classes").where("user_id", isEqualTo: widget.database.userID)
              .where("title", isEqualTo: document['class_title']).where("subject_area", isEqualTo: document["class_subject"])
              .where("course_number", isEqualTo: document['class_number']).getDocuments();
          Class c = widget.database.documentToClass(snapshot.documents[0]);
          bool isWithinWeek = a.dueDate.isAfter(widget.date) &&
              a.dueDate.isBefore(oneWeekFromToday);
          bool isDueToday = widget.date.day == a.dueDate.day &&
              widget.date.month == a.dueDate.month &&
              widget.date.year == a.dueDate.year;
          if (isWithinWeek || isDueToday) {
            assignmentList.add(ListTile(
              title: Text(a.title),
              subtitle: Text(
                c.title,
              ),
              trailing: isDueToday
                  ? Text(
                "Due today",
                style: TextStyle(color: Colors.red),
              )
                  : Text("Due in " +
                  (a.dueDate
                      .difference(DateTime.now())
                      .inDays + 1)
                      .toString() +
                  " days"),
              onLongPress: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return SimpleDialog(
                          title: Text("Are you sure you want to delete " +
                              a.title +
                              " ?"),
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                RaisedButton(
                                  color: Colors.white,
                                  child: Text("Yes"),
                                  onPressed: () {
                                    setState(() {
                                      c.assignments.remove(a);
                                      Navigator.of(context).pop();
                                      widget.database.updateDatabase();
                                    });
                                  },
                                ),
                                RaisedButton(
                                  color: Colors.white,
                                  child: Text("Cancel"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            )
                          ]);
                    });
              },
              onTap: () async {
                noti.cancelNotification(a.id);
                Assignment result =
                await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        AssignmentDetailsView(
                          aClass: c,
                          assignment: a,
                        )));
//                if (result != null) {
//                  print("Assignment updated: " + result.title);
//                  DateTime dateTime = DateTime(
//                      result.dueDate.year,
//                      result.dueDate.month,
//                      result.dueDate.day,
//                      c.startTime.hour,
//                      c.startTime.minute);
//                  dateTime = dateTime.subtract(Duration(minutes: 15));
//                  noti.scheduleNotification(
//                      title: "Assignment due",
//                      body: result.title +
//                          " for " +
//                          c.title +
//                          " is due at " +
//                          dateTime.hour.toString() +
//                          ":" +
//                          dateTime.minute.toString(),
//                      dateTime: dateTime,
//                      id: result.id);
//                  widget.database.updateDatabase();
//                  setState(() {});
//                }
              },
            ));
          }
        }
      });
    }
    else {
      assignmentList.add(ListTile(
          title: Text(
            widget.isAssessment
                ? "No assessments due today"
                : "No assignments due today",
            style: Theme
                .of(context)
                .accentTextTheme
                .body2,
          )));
    }
    return assignmentList;
  }
}

class FilteredEventExpansion extends StatefulWidget {
  final AcademicTerm term;
  final DateTime date;
  final DataBase database;

  FilteredEventExpansion(this.term, this.date, this.database);

  @override
  _FilteredEventExpansionState createState() => _FilteredEventExpansionState();
}

class _FilteredEventExpansionState extends State<FilteredEventExpansion> {
  Notifications noti = Notifications();
  List<Widget> _events() {
    List<Widget> eventsList = List();
    if (widget.term.events.isNotEmpty) {
      for (Event e in widget.term.events) {
        if (e.daysOfEvent.contains(widget.date.weekday)) {
          eventsList.add(ListTile(
            title: Text(
              e.title,
              style: Theme.of(context).accentTextTheme.body2,
            ),
            onLongPress: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SimpleDialog(
                        title: Text("Are you sure you want to delete " +
                            e.title +
                            " ?"),
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              RaisedButton(
                                color: Colors.white,
                                child: Text("Yes"),
                                onPressed: () {
                                  setState(() {
                                    widget.term.events.remove(e);
                                    Navigator.of(context).pop();
                                    widget.database.updateDatabase();
                                  });
                                },
                              ),
                              RaisedButton(
                                color: Colors.white,
                                child: Text("Cancel"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          )
                        ]);
                  });
            },
            onTap: () async {
              noti.cancelNotification(e.id);
              Event result = await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => EventDetailsView(
                        event: e,
                      )));
              if (result != null) {
                e = result;
                print("Event updated: " + result.title);
                if (result.daysOfEvent.isNotEmpty) {
                  for (int i in result.daysOfEvent) {
                    noti.showWeeklyAtDayAndTime(
                        title: "Event starting",
                        body: result.title + " is starting in 15 mins",
                        id: result.id,
                        dayToRepeat: i,
                        timeToRepeat:
                            result.startTime.subtract(Duration(minutes: 15)));
                  }
                } else {
                  DateTime now = DateTime.now();
                  DateTime input;
                  if (result.startTime.hour < now.hour ||
                      result.endTime.hour < now.hour ||
                      (result.startTime.hour == now.hour &&
                          result.startTime.minute < now.minute) ||
                      (result.endTime.hour == now.hour &&
                          result.endTime.minute < now.minute)) {
                    print("CONDITIONS MET");
                    input = DateTime(now.year, now.month, now.day,
                        result.startTime.hour, result.startTime.minute);
                    input.add(Duration(days: 1));
                  } else {
                    print("CONDITIONS NOT MET");

                    input = DateTime(now.year, now.month, now.day,
                        result.startTime.hour, result.startTime.minute);
                  }
                  input.subtract(Duration(minutes: 15));
                  noti.scheduleNotification(
                      title: "Event today",
                      body: result.title + " will take place in 15 mins.",
                      dateTime: input,
                      id: result.id);
                }
                widget.database.updateDatabase();
              }
            },
          ));
        }
      }
    }
    if (eventsList.isEmpty) {
      eventsList.add(ListTile(
          title: Text(
        "No events today",
        style: Theme.of(context).accentTextTheme.body2,
      )));
    }
    return eventsList;
  }

  @override
  Widget build(BuildContext context) {
    if(widget.term != null) {
      return ExpansionTile(
        leading: Icon(Icons.event),
        title: Text(
          "Events",
          style: Theme
              .of(context)
              .accentTextTheme
              .body2,
        ),
        children: _events(),
        initiallyExpanded: true,
      );
    }
    else
      {
        return ExpansionTile(
          leading: Icon(Icons.event),
          title: Text(
            "Events",
            style: Theme
                .of(context)
                .accentTextTheme
                .body2,
          ),
          children: [ListTile(
              title: Text(
                "No events today",
                style: Theme.of(context).accentTextTheme.body2,
              ))],
          initiallyExpanded: true,
        );
      }
  }
}
