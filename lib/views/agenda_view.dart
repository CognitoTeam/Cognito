// Copyright 2019 UniPlan. All rights reserved.
import 'package:cognito/database/database.dart';
import 'package:cognito/database/notifications.dart';
import 'package:cognito/models/academic_term.dart';
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
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';

/// Agenda view screen
/// Displays daily agenda
/// @author Julian Vu

class AgendaView extends StatefulWidget {
  @override
  _AgendaViewState createState() => _AgendaViewState();
}

class _AgendaViewState extends State<AgendaView>
    with SingleTickerProviderStateMixin {
  Notifications noti = Notifications();

  DateTime selectedDate;
  AcademicTerm term;
  bool isOpened = false;
  DataBase database = DataBase();
  int _currentBottomNavIndex = 0;
  TabController _tabController;

  List<Widget> _tabList() {
    return [
      ListView(
        children: <Widget>[
          FilteredClassExpansion(term, selectedDate, database),
          FilteredAssignmentExpansion(term, selectedDate, false, database),
          FilteredAssignmentExpansion(term, selectedDate, true, database),
          FilteredEventExpansion(term, selectedDate, database),
        ],
      ),
      FilteredSchedule(term, selectedDate, database),
    ];
  }

  AcademicTerm getCurrentTerm() {
    for (AcademicTerm term in database.allTerms.terms) {
      if (DateTime.now().isAfter(term.startTime) &&
          DateTime.now().isBefore(term.endTime)) {
        this.term = term;
        return term;
      }
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabList().length, vsync: this);
    setState(() {
      selectedDate = DateTime.now();
      getCurrentTerm();
    });
  }

  @override
  dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Widget> _listOfClassAssign() {
    List<Widget> listTasks = List();
    if (term.classes.isNotEmpty) {
      for (Class c in term.classes) {
        listTasks.add(
          ListTile(
              title: Text(
                c.title,
                style: Theme.of(context).accentTextTheme.body2,
              ),
              onTap: () async {
                setState(() {
                  isOpened = !isOpened;
                });

                Navigator.of(context).pop();
                Assignment result =
                    await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AddAssignmentView(
                              aClass: c,
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
                  database.updateDatabase();
                }
              }),
        );
      }
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

  List<Widget> _listOfClassAssess() {
    List<Widget> listTasks = List();
    if (term.classes.isNotEmpty) {
      for (Class c in term.classes) {
        listTasks.add(
          ListTile(
              title: Text(
                c.title,
                style: Theme.of(context).accentTextTheme.body2,
              ),
              onTap: () async {
                setState(() {
                  isOpened = !isOpened;
                });

                Navigator.of(context).pop();
                Assignment result =
                    await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AddAssessmentView(
                              aClass: c,
                            )));
                if (result != null) {
                  DateTime input = DateTime(
                      result.dueDate.year,
                      result.dueDate.month,
                      result.dueDate.day,
                      result.dueDate.hour,
                      result.dueDate.minute);
                  input = input.subtract(Duration(minutes: 15));
                  noti.scheduleNotification(
                      title: "Assessment today",
                      body: result.title +
                          " for " +
                          c.title +
                          " starts in 15 mins",
                      dateTime: input,
                      id: result.id);

                  c.addTodoItem(c.ASSESSMENTTAG, assignment: result);
                  database.updateDatabase();
                }
              }),
        );
      }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22),
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.white,
        overlayOpacity: 0.5,
        shape: CircleBorder(),
        children: <SpeedDialChild>[
          SpeedDialChild(
              child: Icon(Icons.assignment),
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              label: "Add Assignment",
              labelStyle: Theme.of(context).accentTextTheme.body1,
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return SimpleDialog(
                          title: Text("Choose a class"),
                          children: _listOfClassAssign());
                    });
              }),
          SpeedDialChild(
              child: Icon(Icons.assessment),
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              label: "Add Assessment",
              labelStyle: Theme.of(context).accentTextTheme.body1,
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return SimpleDialog(
                          title: Text("Choose a class"),
                          children: _listOfClassAssess());
                    });
              }),
          SpeedDialChild(
              child: Icon(Icons.event),
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              label: "Add Event",
              labelStyle: Theme.of(context).accentTextTheme.body1,
              onTap: () async {
                Event result = await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AddEventView()));
                if (result != null) {
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

                  print(
                    "Event returned: " + result.title,
                  );
                  term.addEvent(result);
                  database.updateDatabase();
                }
              }),
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
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _tabList(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              _currentBottomNavIndex = index;
              _tabController.animateTo(_currentBottomNavIndex);
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.dashboard), title: Text("Dashboard")),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today), title: Text("Schedule"))
          ]),
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
  List<Widget> _classes() {
    List<Widget> classesList = List();
    if (widget.term.classes.isNotEmpty) {
      for (Class c in widget.term.classes) {
        if (c.daysOfEvent.contains(widget.date.weekday)) {
          classesList.add(ListTile(
            title: Text(
              c.subjectArea + " " + c.courseNumber + " - " + c.title,
              style: Theme.of(context).accentTextTheme.body2,
            ),
            subtitle: Text(DateFormat.jm().format(c.startTime) +
                " - " +
                DateFormat.jm().format(c.endTime)),
            onTap: () async {
              noti.cancelNotification(c.id);

              Class result = await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ClassDetailsView(
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
    }
    if (classesList.isEmpty) {
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
    return ExpansionTile(
      leading: Icon(Icons.class_),
      title: Text(
        "Classes",
        style: Theme.of(context).accentTextTheme.body2,
      ),
      children: _classes(),
      initiallyExpanded: true,
    );
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
  List<Widget> _assignments() {
    List<Widget> assignmentList = List();
    if (widget.term.classes.isNotEmpty) {
      for (Class c in widget.term.classes) {
        if (widget.isAssessment) {
          if (c.assessments.isNotEmpty) {
            for (Assignment a in c.assessments) {
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
                          "Today at " + DateFormat.jm().format(a.dueDate),
                          style: TextStyle(color: Colors.red),
                        )
                      : Text((a.dueDate.difference(DateTime.now()).inDays + 1)
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
                            builder: (context) => AssessmentDetailsView(
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
          }
        } else {
          if (c.assignments.isNotEmpty) {
            for (Assignment a in c.assignments) {
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
                          (a.dueDate.difference(DateTime.now()).inDays + 1)
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
                            builder: (context) => AssignmentDetailsView(
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
                ));
              }
            }
          }
        }
      }
    }
    if (assignmentList.isEmpty) {
      assignmentList.add(ListTile(
          title: Text(
        widget.isAssessment
            ? "No assessments due today"
            : "No assignments due today",
        style: Theme.of(context).accentTextTheme.body2,
      )));
    }
    return assignmentList;
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading:
          widget.isAssessment ? Icon(Icons.assessment) : Icon(Icons.assignment),
      title: Text(
        widget.isAssessment ? "Assessments" : "Assignments",
        style: Theme.of(context).accentTextTheme.body2,
      ),
      children: _assignments(),
      initiallyExpanded: true,
    );
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
    return ExpansionTile(
      leading: Icon(Icons.event),
      title: Text(
        "Events",
        style: Theme.of(context).accentTextTheme.body2,
      ),
      children: _events(),
      initiallyExpanded: true,
    );
  }
}

class FilteredSchedule extends StatefulWidget {
  final AcademicTerm term;
  final DateTime date;
  final DataBase database;

  FilteredSchedule(this.term, this.date, this.database);

  @override
  _FilteredScheduleState createState() => _FilteredScheduleState();
}

class _FilteredScheduleState extends State<FilteredSchedule> {
  Notifications noti = Notifications();
  DateTime oneWeekFromToday = DateTime.now().add(Duration(days: 7));

  List<Widget> _assignments() {
    List<Widget> assignmentList = List();
    if (widget.term.classes.isNotEmpty) {
      for (Class c in widget.term.classes) {
        if (c.assignments.isNotEmpty) {
          for (Assignment a in c.assignments) {
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
                        (a.dueDate.difference(DateTime.now()).inDays + 1)
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
                          builder: (context) => AssignmentDetailsView(
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
              ));
            }
          }
        }
      }
    }
    if (assignmentList.isEmpty) {
      assignmentList.add(ListTile(
          title: Text(
        "No assignments due today",
        style: Theme.of(context).accentTextTheme.body2,
      )));
    }
    return assignmentList;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: _assignments(),
    );
  }
}
