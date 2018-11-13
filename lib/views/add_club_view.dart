import 'package:cognito/models/event.dart';
import 'package:cognito/models/officer.dart';
import 'package:cognito/models/task.dart';
import 'package:cognito/views/add_event_view.dart';
import 'package:cognito/views/add_task_view.dart';
import 'package:cognito/views/event_details_view.dart';
import 'package:cognito/views/task_details_view.dart';
/// club creation view
/// View screen to create a new club object
/// @author Praneet Singh
///
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cognito/models/club.dart';

enum Day {M, Tu, W, Th, F, Sat, Sun}

class AddClubView extends StatefulWidget {
  @override
  _AddClubViewState createState() => _AddClubViewState();
}

class _AddClubViewState extends State<AddClubView> {
  Club club = Club();
  DateTime startTime, endTime;
  List<int> daysOfEvent = List();

  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();

  ListTile textFieldTile(
      {Widget leading,
      Widget trailing,
      TextInputType keyboardType,
      String hint,
      Widget subtitle,
      TextEditingController controller}) {
    return ListTile(
      leading: leading,
      trailing: trailing,
      title: TextFormField(
        controller: controller,
        autofocus: false,
        keyboardType: keyboardType,
        style: Theme.of(context).accentTextTheme.body1,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.black45),
        ),
      ),
      subtitle: subtitle,
    );
  }

  /// Helper function for selecting a day
  /// Adds a day to the list of repeated days for this Club
  /// The day to add is the index of the day + 1 since enums start from 0
  void selectDay(Day day) {
    setState(() {
      daysOfEvent.add(day.index + 1);
    });
  }

  /// Helper function for deselcting a day
  /// Removes a day from list of repeated days for this club
  /// The day to remove is the index of the day + 1 since enums start from 0
  void deselectDay(Day day) {
    setState(() {
      daysOfEvent.remove(day.index + 1);
    });
  }

  /// Creates a Column object that contains a label for the day to be selected
  /// and a check box for that day
  Column daySelectionColumn(Day day) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(day.toString().substring(4)),
        Checkbox(
          value: daysOfEvent.contains(day.index + 1),
          onChanged: (bool e) {
            daysOfEvent.contains(day.index + 1) ? deselectDay(day) : selectDay(day);
          },
        ),
      ],
    );
  }

  Future<Null> _selectTime(bool isStart, BuildContext context) async {
    // Hide keyboard before showing time picker
    FocusScope.of(context).requestFocus(FocusNode());

    // Add delay to be sure keyboard is no longer visible
    await Future.delayed(Duration(milliseconds: 200));

    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      print("Date selected: ${picked.toString()}");
      setState(() {
        isStart
            ? startTime = DateTime(2018, 1, 1, picked.hour, picked.minute)
            : endTime = DateTime(2018, 1, 1, picked.hour, picked.minute);
        print(isStart ? startTime.toString() : endTime.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New club"),
        backgroundColor: Theme.of(context).primaryColorDark,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              Navigator.of(context).pop(_titleController.text != null
                  ? Club(
                      title: _titleController.text,
                      location: _locationController.text,
                      description: _descriptionController.text,
                      start: startTime,
                      end: endTime)
                  : null);
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Padding(padding: EdgeInsets.all(0.0)),
          textFieldTile(
              hint: "Club title", controller: _titleController),
          textFieldTile(hint: "Location (Optional)", controller: _locationController),
          ListTile(
            title: TextFormField(
              controller: _descriptionController,
              autofocus: false,
              style: Theme.of(context).accentTextTheme.body1,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.done,
              maxLines: 5,
              decoration: InputDecoration(
                  hintText: "Description",
                  hintStyle: TextStyle(color: Colors.black45)),
            ),
          ),

          ExpandableOfficerList(club),
          ExpandableEventList(club),
          ExpandableTaskList(club)
        ],
      ),
    );
  }
}
class ExpandableOfficerList extends StatefulWidget {
  final Club club;

  ExpandableOfficerList(this.club);

  @override
  _ExpandableOfficerListState createState() => _ExpandableOfficerListState();
}

class _ExpandableOfficerListState extends State<ExpandableOfficerList> {

  final _officerNameController = TextEditingController();
  final _officerPosController = TextEditingController();

  List<Widget> _listOfOfficers() {
    List<Widget> listOfficers = List();
    if (widget.club.officers.isNotEmpty) {
      for (Officer o in widget.club.officers) {
        listOfficers.add(
          ListTile(
              title: Text(
                o.officerName +" ("+ o.officerPosition+")",
                style: Theme.of(context).accentTextTheme.body2,
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    _officerNameController.text = o.officerName;
                    _officerPosController.text = o.officerPosition;
                    return SimpleDialog(
                      title: Text("Edit an Officer"),
                      children: <Widget>[
                        TextField(
                          controller: _officerNameController,
                          style: Theme.of(context).accentTextTheme.body2,
                          decoration: InputDecoration(
                            hintText: "Officer Name",
                            hintStyle: TextStyle(color: Colors.black45),
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          ),
                          textInputAction: TextInputAction.done,
                        ),
                        TextField(
                          controller: _officerPosController,
                          style: Theme.of(context).accentTextTheme.body2,
                          decoration: InputDecoration(
                            hintText: "Officer Position",
                            hintStyle: TextStyle(color: Colors.black45),
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          ),
                          textInputAction: TextInputAction.done,
                        ), 
                        RaisedButton(
                          child: Text("Submit"),
                          onPressed: (){
                            o.officerName =_officerNameController.text;
                            o.officerPosition = _officerPosController.text;
                            _officerNameController.text = "";
                            _officerPosController.text = "";
                             Navigator.pop(context);
                          },
                        )
                      ],
                    );
                  });
              }),
        );
      }
    } else {
      listOfficers.add(ListTile(
          title: Text(
        "No Officers so far",
        style: Theme.of(context).accentTextTheme.body2,
      )));
    }
    listOfficers.add(
      ListTile(
        title: Text(
          "Add a new Officer",
          style: Theme.of(context).accentTextTheme.body2,
        ),
        leading: Icon(Icons.add),
        onTap: () {
          showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SimpleDialog(
                      title: Text("Add an Officer"),
                      children: <Widget>[
                        TextField(
                          controller: _officerNameController,
                          style: Theme.of(context).accentTextTheme.body2,
                          decoration: InputDecoration(
                            hintText: "Officer Name",
                            hintStyle: TextStyle(color: Colors.black45),
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          ),
                          textInputAction: TextInputAction.done,
                        ),
                        TextField(
                          controller: _officerPosController,
                          style: Theme.of(context).accentTextTheme.body2,
                          decoration: InputDecoration(
                            hintText: "Officer Position",
                            hintStyle: TextStyle(color: Colors.black45),
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          ),
                          textInputAction: TextInputAction.done,
                        ), 
                        RaisedButton(
                          child: Text("Add"),
                          onPressed: (){
                            widget.club.addOfficer(Officer(_officerNameController.text, _officerPosController.text));
                            _officerNameController.text = "";
                            _officerPosController.text = "";
                             Navigator.pop(context);
                          },
                        )
                      ],
                    );
                  });
        },
      ),
    );
    return listOfficers;
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        leading: Icon(Icons.person_outline),
        title: Text(
          "Officers",
          style: Theme.of(context).accentTextTheme.body2,
        ),
        children: _listOfOfficers());
  }
}

class ExpandableTaskList extends StatefulWidget {
  final Club club;

  ExpandableTaskList(this.club);

  @override
  _ExpandableTaskListState createState() => _ExpandableTaskListState();
}
class _ExpandableTaskListState extends State<ExpandableTaskList> {
  List<Widget> _listOfTasks() {
    List<Widget> listTasks = List();
    if (widget.club.tasks.isNotEmpty) {
      for (Task t in widget.club.tasks) {
        listTasks.add(
          ListTile(
              title: Text(
                t.title,
                style: Theme.of(context).accentTextTheme.body2,
              ),
              onTap: () async {
                Task result = await Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => TaskDetailsView(task: t)));
                if (result != null) {
                  print("Task updated: " + result.title);
                }
              }),
        );
      }
    } else {
      listTasks.add(ListTile(
        title: Text(
          "No Tasks so far",
          style: Theme.of(context).accentTextTheme.body2,
        ),
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
          Task result = await Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddTaskView()));
          if (result != null) {
            print(result.title);
            widget.club.addTask(result);
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
  final Club club;

  ExpandableEventList(this.club);

  @override
  _ExpandableEventListState createState() => _ExpandableEventListState();
}

class _ExpandableEventListState extends State<ExpandableEventList> {
  List<Widget> _listOfEvents() {
    List<Widget> listEvents = List();
    if (widget.club.events.isNotEmpty) {
      for (Event e in widget.club.events) {
        listEvents.add(
          ListTile(
              title: Text(
                e.title,
                style: Theme.of(context).accentTextTheme.body2,
              ),
              onTap: () async {
                Event result = await Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => EventDetailsView(event: e)));
                if (result != null) {
                  print("Event updated " + result.title);
                }
              }),
        );
      }
    } else {
      listEvents.add(ListTile(
          title: Text(
        "No Events so far",
        style: Theme.of(context).accentTextTheme.body2,
      )));
    }
    listEvents.add(
      ListTile(
        title: Text(
          "Add a new Event",
          style: Theme.of(context).accentTextTheme.body2,
        ),
        leading: Icon(Icons.add),
        onTap: () async {
          Event result = await Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddEventView()));
          if (result != null) {
            print(result.title);
            widget.club.addEvent(result);
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

