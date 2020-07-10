// Copyright 2019 UniPlan. All rights reserved.
import 'dart:async';
import 'dart:math';

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
import 'package:cognito/views/add_class_view.dart';
import 'package:cognito/views/add_event_view.dart';
import 'package:cognito/views/assessment_details_view.dart';
import 'package:cognito/views/assignment_details_view.dart';
import 'package:cognito/views/calendar_view.dart';
import 'package:cognito/views/class_details_view.dart';
import 'package:cognito/views/components/agenda_header.dart';
import 'package:cognito/views/components/agenda_navigator.dart';
import 'package:cognito/views/components/popup/choose_class.dart';
import 'package:cognito/views/event_details_view.dart';
import 'package:cognito/views/main_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../utils/PriorityAgenda/priority_agenda.dart';
import '../utils/main_agenda.dart';
import 'AgendaListItems/classes_list_view.dart';

/// Agenda view screen
/// Displays daily agenda
/// @author Julian Vu


///Footer commented code kept for logic

class AgendaView extends StatefulWidget {
  AcademicTerm term;

  AgendaView(AcademicTerm term)
  {
    if(term == null)
      {
        //TODO: Fix this
        term = new AcademicTerm();
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
  Animation<double> _translateButton;

  ScrollController _scrollController;
  double titleXAlignment = -0.8;
  double titleYAlignment= 0.15;
  AnimatedOpacity agendaHeader;
  bool _headerVisible = true;
  AnimationController _opacityController;
  Animation _opacityTween;

  Curve _curve = Curves.easeIn;
  double _fabHeight = 56.0;
  DataBase database = DataBase();

  String gradesDocID = "";
  bool gradesDocIDFound = false;

  DataBase db = DataBase();
  List<Class> classes = new List();
  StreamSubscription sub;
  Map data;

  String message = "";

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if(_scrollController.position.minScrollExtent == _scrollController.offset && _headerVisible == false)
      {
        setState(() {
          _headerVisible = true;
        });
      }
      if(_scrollController.position.minScrollExtent != _scrollController.offset && _headerVisible == true)
      {
        setState(() {
          _headerVisible = false;
        });
      }
        setState(() {
          titleXAlignment = (1 - _scrollController.offset/_scrollController.position.maxScrollExtent) * -.8;
          titleYAlignment = ((_scrollController.offset/_scrollController.position.maxScrollExtent)* 0.85) + 0.15;
        });
    });
    sub = Firestore.instance.collection('terms').document('id').snapshots().listen((snap) {
      setState(() {
        data = snap.data;
      });
    });

    setState(() {
      selectedDate = DateTime.now();
      agendaHeader = AnimatedOpacity(
        opacity: _headerVisible ? 1.0 : 0.0,
        duration: Duration(milliseconds: 500),
        child: AgendaHeader(selectedDate: selectedDate, calendarView:CalendarView(
          onDateSelected: (DateTime date) {
            setState(() {
              selectedDate = date;
            });
          },
        ),
        ),
      );
    });


    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200))
          ..addListener(() {
            setState(() {});
          });
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
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Widget getSpeedDial()
  {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    return SpeedDial(
      marginRight: 15,
      marginBottom: 20,
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      closeManually: false,
      curve: Curves.bounceIn,
      overlayOpacity: 0.5,
      backgroundColor: Theme.of(context).buttonColor,
      foregroundColor: Colors.white,
      elevation: 8.0,
      shape: CircleBorder(),
      children: [
        SpeedDialChild(
          child: Icon(
            Icons.class_,
            color: Colors.white,
          ),
          backgroundColor: Color(0xFF6FCF97),
          label: 'Class',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () async {
            await Navigator.push(context,
                MaterialPageRoute(
                    builder: (context) =>
                        AddClassView(
                            widget.term
                        )
                )
            );
          }
        ),
        SpeedDialChild(
          child: Icon(
            Icons.assignment,
            color: Colors.white,
          ),
          backgroundColor: Color(0xFFFFB8B8),
          label: 'Assignment',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext buildContext) {
                  return ChooseClassDialog(classes);
                }
              );
          },
        ),
        SpeedDialChild(
            child: Icon(
              Icons.calendar_view_day,
              color: Colors.white,
            ),
            backgroundColor: Color(0xFF706FD3),
            label: 'Term',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () => print('FIRST CHILD')
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    classes = Provider.of<List<Class>>(context);
    database.getCurrentTerm(user);
    
    void onTabTapped(int index)
    {
      setState(
          () {
            _currentIndex = index;
          }
      );
    }

    var todayAgenda = Text("Daily Agenda",
      style: TextStyle(
          color: Colors.black,
          fontSize: 20.0
      ),
    );

    var agendaItems = [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          new Text(
          "Classes",
          style: Theme.of(context).primaryTextTheme.bodyText1
      ),
          new Icon(Icons.class_)
        ],
      ),
      Center(
        child: Container(
          padding: EdgeInsets.all(7),
          child: ClassesListView(selectedDate, classes)
        )
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          new Text(
              "Assignments",
              style: Theme.of(context).primaryTextTheme.bodyText1
          ),
          new Icon(Icons.assignment)
        ],
      ),
      Center(
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 7, 0, 15),
            child: Text(
                "There are no assignments currently",
                style: Theme.of(context).primaryTextTheme.bodyText2
            ),
          )
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          new Text(
              "Assessments",
              style: Theme.of(context).primaryTextTheme.bodyText1
          ),
          new Icon(Icons.assessment)
        ],
      ),
      Center(
          child: Container(
            padding: EdgeInsets.all(7),
            child: Text(
                "There are no assessments currently",
                style: Theme.of(context).primaryTextTheme.bodyText2
            ),
          )
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          new Text(
              "Events",
              style: Theme.of(context).primaryTextTheme.bodyText1
          ),
          new Icon(Icons.group)
        ],
      ),
      Center(
          child: Container(
            padding: EdgeInsets.all(7),
            child: Text(
                "There are no events currently",
                style: Theme.of(context).primaryTextTheme.bodyText2
            ),
          )
      ),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      drawer: MainDrawer(),
      floatingActionButton: getSpeedDial(),
      body: NestedScrollView(
        body: ListView.builder(
          itemCount: agendaItems.length,
          itemBuilder: (context, index) => Container(
            padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
            child: Material(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.circular(5.0),
              child: Center(
                child: agendaItems[index],
              ),
            ),
          )
        ),
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              elevation: 0,
              onStretchTrigger: () {
                return;
                },
              expandedHeight: 265.0,
              floating: false,
              pinned: true,
              backgroundColor: Theme.of(context).primaryColorDark,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
//                  collapseMode: CollapseMode.pin,
                  centerTitle: true,
                  background: AnimatedOpacity(
                    opacity: _headerVisible ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 500),
                    child: AgendaHeader(selectedDate: selectedDate, calendarView:CalendarView(
                      onDateSelected: (DateTime date) {
                        setState(() {
                          selectedDate = date;
                        });
                      },
                    ),
                    ),
                  ),
                  title: Align(
                    alignment: Alignment(
                        titleXAlignment,
                        titleYAlignment
                    ),
                    child: todayAgenda,
                  )
                ),
              ),
            ];
          },
        ),
    );
  }
}

/*
  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  //Edit snapshot
  List<Widget> _listOfClassAssign(List<Class> classes) {
    List<Widget> listTasks = List();
    if (classes != null && classes.length > 0) {
      classes.forEach((Class c) {
        listTasks.add(
          ListTile(
              title: Text(
                c.title,
                style: Theme
                    .of(context)
                    .accentTextTheme
                    .body2,
              ),
              onTap: () async {
                setState(() {
                  isOpened = !isOpened;
                  animate();
                });

                Navigator.of(context).pop();
                Assignment result =
                await Navigator.push(context, MaterialPageRoute(
                    builder: (context) =>
                        AddAssignmentView(
                          aClass: c,
                          term: widget.term,
                        )));
                if (result != null) {
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
                  c.addTodoItem(c.ASSIGNMENTTAG, assignment: result);
                }
              }),
        );
      });
    }
    return listTasks;
  }

  List<Widget> _listOfClassAssess(List<Class> classes) {
    List<Widget> listTasks = List();
          if (classes != null && classes.length > 0) {
            classes.forEach((c){
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
                        c.addTodoItem(c.ASSESSMENTTAG, assignment: result);
                        database.updateDatabase();
                      }
                    }),
              );
            });
          }
    return listTasks;
  }

  Widget classes(FirebaseUser user)
  {
    return Column(
      children: [
        Text(
          "Classes",
          style: Theme.of(context).primaryTextTheme.headline2
        )
      ],
    );
  }

  Widget assessment(FirebaseUser user) {
          return Container(
            child: FloatingActionButton(
              heroTag: "assessmentButton",
              onPressed: () {
                showDialog(
                context: context,
                builder: (BuildContext context) {
                  return StreamBuilder<List<Class>>(
                      stream: database.streamClasses(user, widget.term),
                      builder: (BuildContext context, snapshot) {
                        return SimpleDialog(
                            title: Text("Choose a class"),
                            children: (snapshot.data != null && snapshot.data.length > 0)
                                ? _listOfClassAssess(snapshot.data)
                                : [ListTile(
                                    title: Text(
                                  "No classes have been added yet!",
                                  style: Theme.of(context).accentTextTheme.body2,
                                  ),
                                  )]
                        );
                      });
                });
                setState(() {
                  animate();
                });
              },
              tooltip: 'Assessment',
              child: Icon(Icons.assessment),
            ),
          );
  }

  Widget assignment(FirebaseUser user) {
          return Container(
            child: FloatingActionButton(
            heroTag: "assignmentButton",
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return StreamBuilder<List<Class>>(
                    stream: database.streamClasses(user, widget.term),
                    builder: (BuildContext context, AsyncSnapshot<List<Class>> snapshot) {
                      return SimpleDialog(
                          title: Text("Choose a class"),
                          children: (snapshot.data != null &&
                              snapshot.data.length > 0)
                              ? _listOfClassAssign(snapshot.data)
                              : [ListTile(
                            title: Text(
                              "No classes have been added yet!",
                              style: Theme
                                  .of(context)
                                  .accentTextTheme
                                  .body2,
                            ),
                          )
                          ]
                      );
                    });
                }
              );
              setState(() {
                animate();
              });
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
          Event result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddEventView(widget.term)));
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

  List<Widget> _classes(List<Class> classes) {
    List<Widget> classesList = List();
      classes.forEach((Class c) {
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
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    if (widget.term != null) {
      return StreamBuilder<List<Class>>(
          stream: widget.database.streamClasses(user, widget.term),
          builder: (BuildContext context, snapshot) {
            return ExpansionTile(
              leading: Icon(Icons.class_),
              title: Text(
                "Classes",
                style: Theme
                    .of(context)
                    .accentTextTheme
                    .body2,
              ),
              children: _classes(snapshot.data ?? []),
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
        children: [
          ListTile(
            title: Text(
              "No classes today",
              style: Theme.of(context).accentTextTheme.body2,
            ))],
        initiallyExpanded: true,
      );
    }
  }
}

class FilteredAssignmentProvider extends StatelessWidget {
  final db = DataBase();
  final AcademicTerm term;
  final DateTime date;
  final bool isAssessment;
  DateTime selectedDate;

  FilteredAssignmentProvider(this.term, this.date, this.isAssessment, this.selectedDate);

  @override
  Widget build(BuildContext context) {
    String userId = Provider.of<FirebaseUser>(context).uid;
    return Container(
      child: StreamProvider<List<String>>.value(
        value: db.streamGradeDocID(userId, term.id),
        child: FilteredAssignmentExpansion(term, date, this.isAssessment, db, selectedDate),
      )
    );
  }

}
class FilteredAssignmentExpansion extends StatefulWidget {
  final AcademicTerm term;
  final DateTime date;
  final bool isAssessment;
  final DataBase database;
  DateTime selectedDate;

  FilteredAssignmentExpansion(
      this.term, this.date, this.isAssessment, this.database, this.selectedDate);

  @override
  _FilteredAssignmentExpansionState createState() =>
      _FilteredAssignmentExpansionState();
}

class _FilteredAssignmentExpansionState
    extends State<FilteredAssignmentExpansion> {

  Notifications noti = Notifications();
  DateTime oneWeekFromToday = DateTime.now().add(Duration(days: 7));
  String gradesDocID = "";
  bool gradesDocIDFound = true;
  DataBase database = DataBase();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> gradeIDs = Provider.of<List<String>>(context);
    String gradeID = gradeIDs != null && gradeIDs.length > 0 ? gradeIDs[0] : null;
    if(gradeID != null) {
      print(widget.isAssessment);
        return StreamBuilder<List<Assignment>>(
            stream: database.streamAssignments(gradeID, widget.isAssessment),
            builder: (BuildContext context, snapshot) {
              List<Assignment> assignments = snapshot.data;
                return ExpansionTile(
                  leading: Icon(Icons.class_),
                  title: Text(
                    widget.isAssessment ? "Assessments" : "Assignments",
                    style: Theme
                        .of(context)
                        .accentTextTheme
                        .body2,
                  ),
                  children: _assignments(assignments),
                  //Expanded is true however value is not synchronized
                  initiallyExpanded: true,
                );
            }
            );
      }else
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
                ))
            ],
            initiallyExpanded: true,
          );
        }
  }

  Widget getAssignmentListTile(Assignment a, bool isDueToday)
  {
    return StreamBuilder<Class>(
        stream: database.getClass(a.classObjId),
        builder: (context, snapshot)
        {
          if(snapshot.connectionState == ConnectionState.done || snapshot.connectionState == ConnectionState.active) {
            if(snapshot.data != null)
              {
                Class c = snapshot.data;
                return ListTile(
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
                    if (result != null) {
                      print("Assignment updated: " + result.title);
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
                );
              }else
                {
                  return ListTile(
                      title: Text(
                        "No assignments due today",
                        style: Theme
                            .of(context)
                            .accentTextTheme
                            .body2,
                      ));
                }
          }
          else
            {
              return ListTile(
                  title: Text(
                      "Getting assignments for today",
                  style: Theme
                      .of(context)
                  .accentTextTheme
                  .body2,));
            }
        }
    );
  }

  Widget getAssessmentListTile(Assignment a, bool isDueToday)
  {
    return StreamBuilder<Class>(
      stream: database.getClass(a.classObjId),
      builder: (context, snapshot)
      {
        if(snapshot.connectionState == ConnectionState.done || snapshot.connectionState == ConnectionState.active) {
          if(snapshot.data != null)
          {
            Class c = snapshot.data;
            print("Title ${c.title}");
            return ListTile(
              title: Text(a.title),
              subtitle: Text(
                c.title,
              ),
              trailing: isDueToday
                  ? Text(
                "Today at ${DateFormat.jm().format(a.dueDate)}",
                style: TextStyle(color: Colors.red),
              )
                  : Text("${(a.dueDate
                  .difference(DateTime.now())
                  .inDays + 1)
                  .toString()} days"),
              onLongPress: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return SimpleDialog(
                          title: Text(
                              "Are you sure you want to delete ${a.title}"),
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
                      body: "${result.title} for ${c.title} is due at ${dateTime.hour.toString()}:${dateTime.minute.toString()}",
                      dateTime: dateTime,
                      id: result.id);
                  widget.database.updateDatabase();
                  setState(() {});
                }
              },
            );
          }
          else
            {
            return ListTile(
            title: Text(
            "No assessments due today",
            style: Theme
                .of(context)
                .accentTextTheme
                .body2,
            ));
            }
        }
        else
          {
            return ListTile(
                title: Text(
                  "Getting assessments for today",
                  style: Theme
                      .of(context)
                      .accentTextTheme
                      .body2,));
          }
      },
    );
  }

  List<Widget> _assignments(List<Assignment> assignments) {
    List<Widget> assignmentList = List();
    //Snapshot has data
    if (assignments != null && assignments.length > 0) {
      assignments.forEach((Assignment a) {
//        print("ID: ${a.classObjId}");
        //For each assignment get its class
        bool isWithinWeek = a.dueDate.isAfter(widget.date) &&
            a.dueDate.isBefore(oneWeekFromToday);
        bool isDueToday = widget.date.day == a.dueDate.day &&
            widget.date.month == a.dueDate.month &&
            widget.date.year == a.dueDate.year;
        //Particular assessment is within the time
        if (a.isAssessment && (isWithinWeek || isDueToday)) {
          //Get the data
          assignmentList.add(getAssessmentListTile(a, isDueToday));
        }
        //Particular assessment is within the time
        else if (!a.isAssessment && (isWithinWeek || isDueToday)) {
          assignmentList.add(getAssignmentListTile(a, isDueToday));
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
      }
      );
    }
    //No data
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


  List<Widget> _events(List<Event> events) {
    List<Widget> eventsList = List();
    if (events.isNotEmpty) {
      for (Event e in events) {
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
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    if(widget.term != null) {
      return StreamBuilder<List<Event>>(
        stream: widget.database.streamEvents(user, widget.term),
        builder: (context, snapshot)
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
            children: _events(snapshot.data ?? []),
            initiallyExpanded: true,
          );
        },
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
            children: _events([]),
            initiallyExpanded: true,
        );
      }
  }
}

 */