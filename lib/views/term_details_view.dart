import 'package:cognito/models/club.dart';
import 'package:cognito/models/event.dart';
import 'package:cognito/models/task.dart';
import 'package:cognito/views/add_event_view.dart';
import 'package:cognito/views/add_task_view.dart';
import 'package:cognito/views/event_details_view.dart';
import 'package:cognito/views/task_details_view.dart';

/// Academic term details view
/// View screen to edit an AcademicTerm object
/// @author Julian Vu
///
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cognito/models/academic_term.dart';
import 'package:cognito/models/class.dart';
import 'package:cognito/views/add_class_view.dart';

class TermDetailsView extends StatefulWidget {
  // Hold academic term object
  final AcademicTerm term;

  // Constructor that takes in an academic term object
  TermDetailsView({Key key, @required this.term}) : super(key: key);

  @override
  _TermDetailsViewState createState() => _TermDetailsViewState();
}

class _TermDetailsViewState extends State<TermDetailsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: BackButtonIcon(),
          onPressed: () {
            print("Returning a term");
            Navigator.of(context).pop(widget.term);
          },
        ),
        title: Text(
          widget.term.termName,
          style: Theme.of(context).primaryTextTheme.title,
        ),
        backgroundColor: Theme.of(context).primaryColorDark,
        actions: <Widget>[
          // Edit term title
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.white,
            ),
            onPressed: () async {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SimpleDialog(
                      title: Text("Change Term Title"),
                      children: <Widget>[
                        TextFormField(
                          style: Theme.of(context).accentTextTheme.body2,
                          decoration: InputDecoration(
                            hintText: "Term Title",
                            hintStyle: TextStyle(color: Colors.black45),
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          ),
                          onFieldSubmitted: (val) {
                            print(val);
                            setState(() {
                              widget.term.termName = val;
                            });
                            Navigator.pop(context);
                          },
                          textInputAction: TextInputAction.done,
                        )
                      ],
                    );
                  });
            },
          ),
        ],
      ),
      body: ListView(
          children: <Widget>[
            // Start Date
            DateRow(true, widget.term),
            Divider(),

            // End Date
            DateRow(false, widget.term),
            Divider(),

            // Classes
            ExpandableClassList(widget.term),
            ExpandableEventList(widget.term),
            ExpandableTaskList(widget.term),
            ExpandableClubList(widget.term)
          ],
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          print("Tapped on plus button");
          
        },
        child: Icon(
          Icons.add,
          size: 42.0,
        ),
        backgroundColor: Theme.of(context).accentColor,
        foregroundColor: Colors.black,
      ),
    );
  }
}

// Helper class to modularize date row creation
class DateRow extends StatefulWidget {
  // Flag for whether this date is start date
  final bool _isStart;
  final AcademicTerm term;

  DateRow(this._isStart, this.term);

  @override
  _DateRowState createState() => _DateRowState();
}

class _DateRowState extends State<DateRow> {
  Future<Null> _selectDate(BuildContext context) async {
    // Make sure keyboard is hidden before showing date picker
    FocusScope.of(context).requestFocus(FocusNode());

    await Future.delayed(Duration(milliseconds: 200));

    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime(3000),
    );

    if (picked != null) {
      print("Date selected: ${picked.toString()}");
      setState(() {
        widget._isStart
            ? widget.term.startTime = picked
            : widget.term.endTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.calendar_today),
      title: Text(
        widget._isStart ? "Start Date" : "End Date",
        style: Theme.of(context).accentTextTheme.body2,
      ),
      trailing: Text(widget._isStart
          ? widget.term.getStartDateAsString()
          : widget.term.getEndDateAsString()),
      onTap: () {
        print("Tapped on" + (widget._isStart ? " Start Date" : " End Date"));
        _selectDate(context);
      },
    );
  }
}

class ExpandableClassList extends StatefulWidget {
  final AcademicTerm term;

  ExpandableClassList(this.term);

  @override
  _ExpandableClassListState createState() => _ExpandableClassListState();
}

class _ExpandableClassListState extends State<ExpandableClassList> {
    List<Widget> _listOfClass() {
    List<Widget> listTasks = List();
    if (widget.term.classes.isNotEmpty) {
      for (Class c in widget.term.classes) {
        listTasks.add(
          ListTile(
              title: Text(
                c.title,
                style: Theme.of(context).accentTextTheme.body2,
              ),
              onTap: () {
              }),
        );
      }
    } else {
      listTasks.add(ListTile(
        title: Text("No Classes so far",
        style: Theme.of(context).accentTextTheme.body2,)
      ));
    }
    listTasks.add(
      ListTile(
        title: Text(
          "Add a new Class",
          style: Theme.of(context).accentTextTheme.body2,
        ),
        leading: Icon(Icons.add),
        onTap: () async {
          //TODO
          Class result = await Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddClassView()));
          if (result != null) {
            print(result.title);
            widget.term.addClass(result);
          } else {

          }
        },
      ),
    );
    return listTasks;
  }
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        leading: Icon(Icons.class_),
        title: Text(
          "Classes",
          style: Theme.of(context).accentTextTheme.body2,
        ),
        children: _listOfClass()
        );
  }
}

class ExpandableTaskList extends StatefulWidget {
  final AcademicTerm term;

  ExpandableTaskList(this.term);

  @override
  _ExpandableTaskListState createState() => _ExpandableTaskListState();
}

class _ExpandableTaskListState extends State<ExpandableTaskList> {
  List<Widget> _listOfTasks() {
    List<Widget> listTasks = List();
    if (widget.term.tasks.isNotEmpty) {
      for (Task t in widget.term.tasks) {
        listTasks.add(
          ListTile(
              title: Text(
                t.title,
                style: Theme.of(context).accentTextTheme.body2,
              ),
              onTap: () async {
                Task result = await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => TaskDetailsView(task:t)));
                if (result != null) {
                  print("Task updated: " + result.title);
                }
              }),
        );
      }
    } else {
      listTasks.add(ListTile(
        title: Text("No Tasks so far",
        style: Theme.of(context).accentTextTheme.body2,),
      ));
    }
    listTasks.add(
      ListTile(
        title: Text(
          "Add a new Task",
          style: Theme.of(context).accentTextTheme.body2,
        ),
        leading: Icon(Icons.add),
        onTap: () async {
          //TODO
          Task result = await Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddTaskView()));
          if (result != null) {
            print(result.title);
            widget.term.addTask(result);
          } else {
            print("Task returned null");
          }
        },
      ),
    );
    return listTasks;
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        leading: Icon(Icons.check_box),
        title: Text(
          "Tasks",
          style: Theme.of(context).accentTextTheme.body2,
        ),
        children: _listOfTasks());
  }
}
class ExpandableEventList extends StatefulWidget {
  final AcademicTerm term;

  ExpandableEventList(this.term);

  @override
  _ExpandableEventListState createState() => _ExpandableEventListState();
}

class _ExpandableEventListState extends State<ExpandableEventList> {
  List<Widget> _listOfEvents() {
    List<Widget> listEvents = List();
    if (widget.term.events.isNotEmpty) {
      for (Event e in widget.term.events) {
        listEvents.add(
          ListTile(
              title: Text(
                e.title,
                style: Theme.of(context).accentTextTheme.body2,
              ),
              onTap: () async {
                Event result = await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => EventDetailsView(event: e)));
                if (result != null) {
                  print("Event updated "+result.title);
                }
              }),
        );
      }
    } else {
      listEvents.add(ListTile(
        title: Text("No Events so far",
        style: Theme.of(context).accentTextTheme.body2,)
      ));
    }
    listEvents.add(
      ListTile(
        title: Text(
          "Add a new Event",
          style: Theme.of(context).accentTextTheme.body2,
        ),
        leading: Icon(Icons.add),
        onTap: () async {
          //TODO
          Event result = await Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddEventView()));
          if (result != null) {
            print(result.title);
            widget.term.addEvent(result);
          } else {
            print("Event returned null");
          }
        },
      ),
    );
    return listEvents;
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        leading: Icon(Icons.event),
        title: Text(
          "Events",
          style: Theme.of(context).accentTextTheme.body2,
        ),
        children: _listOfEvents());
  }
}
class ExpandableClubList extends StatefulWidget {
  final AcademicTerm term;

  ExpandableClubList(this.term);

  @override
  _ExpandableClubListState createState() => _ExpandableClubListState();
}

class _ExpandableClubListState extends State<ExpandableClubList> {
  List<Widget> _listOfClus() {
    List<Widget> listClubs = List();
    if (widget.term.clubs.isNotEmpty) {
      for (Club c in widget.term.clubs) {
        listClubs.add(
          ListTile(
              title: Text(
                c.title,
                style: Theme.of(context).accentTextTheme.body2,
              ),
              onTap: () async {
                /*Task result = await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => TaskDetailsView(task:t)));
                if (result != null) {
                  print(result.title);
                  widget.term.addTask(result);
                }*/
              }),
        );
      }
    } else {
      listClubs.add(ListTile(
        title: Text("No Clubs so far",
        style: Theme.of(context).accentTextTheme.body2,),
      ));
    }
    listClubs.add(
      ListTile(
        title: Text(
          "Add a new Club",
          style: Theme.of(context).accentTextTheme.body2,
        ),
        leading: Icon(Icons.add),
        onTap: () async {
          //TODO
          /*Club result = await Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddEventView()));
          if (result != null) {
            print(result.title);
            widget.term.addEvent(result);
          } else {
            print("Event returned null");
          }*/
        },
      ),
    );
    return listClubs;
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        leading: Icon(Icons.people),
        title: Text(
          "Clubs",
          style: Theme.of(context).accentTextTheme.body2,
        ),
        children: _listOfClus());
  }
}
