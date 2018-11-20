import 'package:cognito/models/assignment.dart';
import 'package:cognito/models/event.dart';
import 'package:cognito/models/task.dart';
import 'package:cognito/views/add_assessment_view.dart';
import 'package:cognito/views/add_assignment_view.dart';
import 'package:cognito/views/add_event_view.dart';
import 'package:cognito/views/assessment_details_view.dart';
import 'package:cognito/views/class_details_view.dart';
import 'package:cognito/views/event_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar/flutter_calendar.dart';
import 'package:cognito/models/academic_term.dart';
import 'package:cognito/models/class.dart';
import 'package:cognito/database/database.dart';
import 'package:cognito/views/main_drawer.dart';

/// Agenda view screen
/// Displays daily agenda
/// @author Julian Vu

class AgendaView extends StatefulWidget {
  AcademicTerm term;
  DateTime selectedDate = DateTime.now();

  AgendaView({Key key, @required this.term}) : super(key: key);

  @override
  _AgendaViewState createState() => _AgendaViewState();
}

class _AgendaViewState extends State<AgendaView>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeIn;
  double _fabHeight = 56.0;
  DataBase database = DataBase();

  AcademicTerm getCurrentTerm() {
    for (AcademicTerm term in database.allTerms.terms) {
      if (DateTime.now().isAfter(term.startTime) &&
          DateTime.now().isBefore(term.endTime)) {
        widget.term = term;
        return term;
      }
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _initializeDatabase();
      getCurrentTerm();
    });
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
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

  List<Widget> _listOfClassAssign() {
    List<Widget> listTasks = List();
    if (widget.term.classes.isNotEmpty) {
      for (Class c in widget.term.classes) {
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
                            )));
                if (result != null) {
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
    if (widget.term.classes.isNotEmpty) {
      for (Class c in widget.term.classes) {
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
                            )));
                if (result != null) {
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

  Widget assessment() {
    return Container(
      child: FloatingActionButton(
        heroTag: "assessmentButton",
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return SimpleDialog(
                    title: Text("Choose a class"),
                    children: _listOfClassAssess());
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
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return SimpleDialog(
                    title: Text("Choose a class"),
                    children: _listOfClassAssign());
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
          Event result = await Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddEventView()));
          if (result != null) {
            print("Event returned: " + result.title);
            widget.term.addEvent(result);
            database.updateDatabase();
          }
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

  Future<bool> _initializeDatabase() async {
    await database.startFireStore();
    setState(() {}); //update the view
  }

  @override
  Widget build(BuildContext context) {
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
        drawer: MainDrawer(
          term: getCurrentTerm(),
        ),
        appBar: AppBar(
          title: Text(
            "Agenda",
            style: Theme.of(context).primaryTextTheme.title,
          ),
          backgroundColor: Theme.of(context).primaryColorDark,
        ),
        body: ListView(
          children: <Widget>[
            Calendar(
              onDateSelected: (DateTime date) {
                setState(() {
                  widget.selectedDate = date;
                });
              },
            ),
            FilteredClassExpansion(widget.term, widget.selectedDate, database),
            FilteredAssignmentExpansion(
                widget.term, widget.selectedDate, false, database),
            FilteredAssignmentExpansion(
                widget.term, widget.selectedDate, true, database),
            FilteredEventExpansion(widget.term, widget.selectedDate, database),
          ],
        ));
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
  List<Widget> _classes() {
    List<Widget> classesList = List();
    if (widget.term.classes.isNotEmpty) {
      for (Class c in widget.term.classes) {
        if (c.daysOfEvent.contains(widget.date.weekday)) {
          classesList.add(ListTile(
            title: Text(
              c.title,
              style: Theme.of(context).accentTextTheme.body2,
            ),
            onTap: () async {
              Class result = await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ClassDetailsView(
                        classObj: c,
                      )));
              if (result != null) {
                print("Class updated: " + result.title);
                widget.database.updateDatabase();
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
      initiallyExpanded: true,
      leading: Icon(Icons.class_),
      title: Text(
        "Classes",
        style: Theme.of(context).accentTextTheme.body2,
      ),
      children: _classes(),
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
  List<Widget> _assignments() {
    List<Widget> assignmentList = List();
    if (widget.term.classes.isNotEmpty) {
      for (Class c in widget.term.classes) {
        if (c.todo.isNotEmpty) {
          if (widget.isAssessment) {
            if (c.todo.containsKey(c.ASSESSMENTTAG)) {
              //ERROR: type 'Task' is not a subtype of type 'Assignment'
              for (Task a in c.todo[c.ASSESSMENTTAG]) {
                if (widget.date.day == a.dueDate.day &&
                    widget.date.month == a.dueDate.month &&
                    widget.date.year == a.dueDate.year) {
                  assignmentList.add(ListTile(
                    title: Text(a.title),
                    subtitle: Text(
                      c.title,
                      style: Theme.of(context).accentTextTheme.body2,
                    ),
                    onTap: () async {
                      Assignment result =
                          await Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AssessmentDetailsView(
                                    aClass: c,
                                    assignment: a,
                                  )));
                      if (result != null) {
                        print("Assessment updated: " + result.title);
                        widget.database.updateDatabase();
                      }
                    },
                  ));
                }
              }
            }
          } else {
            if (c.todo.containsKey(c.ASSIGNMENTTAG)) {
              //ERROR: type 'Task' is not a subtype of type 'Assignment'
              for (Task a in c.todo[c.ASSIGNMENTTAG]) {
                if (widget.date.day == a.dueDate.day &&
                    widget.date.month == a.dueDate.month &&
                    widget.date.year == a.dueDate.year) {
                  assignmentList.add(ListTile(
                    title: Text(a.title),
                    subtitle: Text(
                      c.title,
                      style: Theme.of(context).accentTextTheme.body2,
                    ),
                    onTap: () async {
                      Assignment result =
                          await Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AssessmentDetailsView(
                                    aClass: c,
                                    assignment: a,
                                  )));
                      if (result != null) {
                        print("Assignment updated: " + result.title);
                        widget.database.updateDatabase();
                      }
                    },
                  ));
                }
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
            onTap: () async {
              Event result = await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => EventDetailsView(
                        event: e,
                      )));
              if (result != null) {
                print("Event updated: " + result.title);
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
    );
  }
}
