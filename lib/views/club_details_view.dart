import 'package:cognito/models/club.dart';
import 'package:cognito/models/event.dart';
import 'package:cognito/models/officer.dart';
import 'package:cognito/models/task.dart';
import 'package:cognito/views/add_event_view.dart';
import 'package:cognito/views/add_task_view.dart';
import 'package:cognito/views/event_details_view.dart';
import 'package:cognito/views/task_details_view.dart';

/// Club details view
/// View screen to edit an Club object
/// @author Praneet Singh
///
import 'package:flutter/material.dart';
import 'dart:async';

class ClubDetailsView extends StatefulWidget {
  // Hold Club object
  final Club club;

  // Constructor that takes in an academic Club object
  ClubDetailsView({Key key, @required this.club}) : super(key: key);

  @override
  _ClubDetailsViewState createState() => _ClubDetailsViewState();
}

class _ClubDetailsViewState extends State<ClubDetailsView> {
  TextEditingController _locationController, _descriptionController;
  @override
  void initState() {
    super.initState();
    _locationController = TextEditingController(text: widget.club.location);
    _descriptionController =
        TextEditingController(text: widget.club.description);
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: BackButtonIcon(),
          onPressed: () {
            print("Returning a club");
            Navigator.of(context).pop(widget.club);
          },
        ),
        title: Text(
          widget.club.title,
          style: Theme.of(context).primaryTextTheme.title,
        ),
        backgroundColor: Theme.of(context).primaryColorDark,
        actions: <Widget>[
          // Edit club title
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
                      title: Text("Change Club Title"),
                      children: <Widget>[
                        TextFormField(
                          style: Theme.of(context).accentTextTheme.body2,
                          decoration: InputDecoration(
                            hintText: "Club Title",
                            hintStyle: TextStyle(color: Colors.black45),
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          ),
                          onFieldSubmitted: (val) {
                            print(val);
                            setState(() {
                              widget.club.title = val;
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
          textFieldTile(hint: "Location", controller: _locationController),
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
          ExpandableOfficerList(widget.club),
          ExpandableEventList(widget.club),
          ExpandableTaskList(widget.club)
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
          //TODO
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
          //TODO
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
