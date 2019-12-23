import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cognito/database/database.dart';
import 'package:cognito/models/academic_term.dart';
import 'package:firebase_auth/firebase_auth.dart';
/// Club details view
/// View screen to edit an Club object
/// @author Praneet Singh
///
import 'package:flutter/material.dart';
import 'package:cognito/models/club.dart';
import 'package:cognito/models/event.dart';
import 'package:cognito/models/officer.dart';
import 'package:cognito/models/task.dart';
import 'package:cognito/views/add_event_view.dart';
import 'package:cognito/views/add_task_view.dart';
import 'package:cognito/views/event_details_view.dart';
import 'package:cognito/views/task_details_view.dart';
import 'package:provider/provider.dart';

class ClubDetailsView extends StatefulWidget {
  // Hold Club object
  final Club club;
  final AcademicTerm term;
  // Constructor that takes in an academic Club object
  ClubDetailsView({Key key, @required this.club, this.term}) : super(key: key);

  @override
  _ClubDetailsViewState createState() => _ClubDetailsViewState();
}

class _ClubDetailsViewState extends State<ClubDetailsView> {
  TextEditingController _locationController, _descriptionController;
  DataBase database = DataBase();

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
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: BackButtonIcon(),
          onPressed: () {
            widget.club.description = _descriptionController.text;
            widget.club.location = _locationController.text;
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
                            setState(() {
                              widget.club.title = val;
                            });
                            database.updateClubName(widget.club.id, val);
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
      body: FutureBuilder(
        future: database.getCurrentTerm(user),
        builder: (context, snapshot) {
          return ListView(
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
              ExpandableOfficerList(widget.club, snapshot.data),
              ExpandableEventList(widget.club, snapshot.data),
              ExpandableTaskList(widget.club, snapshot.data)
            ],
          );
        },
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
  final AcademicTerm term;

  ExpandableOfficerList(this.club, this.term);

  @override
  _ExpandableOfficerListState createState() => _ExpandableOfficerListState();
}

class _ExpandableOfficerListState extends State<ExpandableOfficerList> {
  final _officerNameController = TextEditingController();
  final _officerPosController = TextEditingController();
  String userID;
  bool userIDLoaded = false;
  String docID = "";
  DataBase dataBase = DataBase();

  @override
  void initState() {
    super.initState();
  }

  List<Widget> _listOfOfficers(List<Officer> officers) {
    List<Widget> listOfficers = List();
    if (officers != null && officers.length != 0) {
      officers.forEach((Officer o){
        listOfficers.add(
          ListTile(
              title: Text(
                "${o.officerName} ( ${o.officerPosition} )",
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
                            onPressed: () {
                              o.officerName = _officerNameController.text;
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
      });
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
                      onPressed: () {
                        Officer o = Officer(
                            _officerNameController.text,
                            _officerPosController.text);
                        widget.club.addOfficer(o);
                        _officerNameController.text = "";
                        _officerPosController.text = "";
                        dataBase.addOfficer(o, widget.club.id);
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
      return StreamBuilder<List<Officer>>(
          stream: dataBase.streamClubOfficers(widget.club.id),
          builder: (context,snapshot) {
            if(snapshot.connectionState == ConnectionState.done || snapshot.connectionState == ConnectionState.active)
            {
              return ExpansionTile(
                  leading: Icon(Icons.person_outline),
                  title: Text(
                    "Officers",
                    style: Theme.of(context).accentTextTheme.body2,
                  ),
                  children: _listOfOfficers(snapshot.data));
            }
            else {
              return ExpansionTile(
                  leading: Icon(Icons.person_outline),
                  title: Text(
                    "Officers",
                    style: Theme
                        .of(context)
                        .accentTextTheme
                        .body2,
                  ),
                  children: _listOfOfficers(null));
            }});
  }
}

class ExpandableTaskList extends StatefulWidget {
  final Club club;
  final AcademicTerm enteredTerm;
  ExpandableTaskList(this.club, this.enteredTerm);

  @override
  _ExpandableTaskListState createState() => _ExpandableTaskListState();
}

class _ExpandableTaskListState extends State<ExpandableTaskList> {

  DataBase dataBase = DataBase();

  @override
  void initState() {
    super.initState();
  }

  List<Widget> _listOfTasks(List<Task> tasks, FirebaseUser user) {
    List<Widget> listTasks = List();
    if (tasks != null && tasks.length != 0) {
      tasks.forEach((Task t){
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
      });
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
              .push(MaterialPageRoute(builder: (context) => AddTaskView(widget.enteredTerm, true)));
          if (result != null) {
            dataBase.addClubTask(user.uid,
                result.title,
                result.location,
                result.description,
                result.daysOfEvent,
                result.isRepeated,
                result.dueDate,
                result.priority,
                result.duration,
                widget.enteredTerm,
                widget.club.id);
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
      FirebaseUser user = Provider.of<FirebaseUser>(context);
      return StreamBuilder<List<Task>>(
          stream: dataBase.streamClubTasks(widget.club.id),
          builder: (context,snapshot) {
            if (snapshot.connectionState == ConnectionState.done ||
                snapshot.connectionState == ConnectionState.active) {
              return ExpansionTile(
                  leading: Icon(Icons.person_outline),
                  title: Text(
                    "Tasks",
                    style: Theme
                        .of(context)
                        .accentTextTheme
                        .body2,
                  ),
                  children: _listOfTasks(snapshot.data, user));
            }
            else
            {
              return ExpansionTile(
                  leading: Icon(Icons.event),
                  title: Text(
                    "Tasks",
                    style: Theme
                        .of(context)
                        .accentTextTheme
                        .body2,
                  ),
                  children: _listOfTasks(null, user));
            }
          });
  }
}

class ExpandableEventList extends StatefulWidget {
  final Club club;
  final AcademicTerm term;

  ExpandableEventList(this.club, this.term);

  @override
  _ExpandableEventListState createState() => _ExpandableEventListState();
}

class _ExpandableEventListState extends State<ExpandableEventList> {

  DataBase dataBase = DataBase();

  @override
  void initState() {
    super.initState();
  }

  /// Gets the current user's ID from Firebase.
  void getCurrentUserID() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
  }

  List<Widget> _listOfEvents(List<Event> events) {
    List<Widget> listEvents = List();
    if (events != null && events.length != 0) {
      events.forEach((Event e) {
        listEvents.add(
          ListTile(
              title: Text(
                e.title,
                style: Theme
                    .of(context)
                    .accentTextTheme
                    .body2,
              ),
              onTap: () async {
                Event result = await Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => EventDetailsView(event: e)));
                if (result != null) {
                }
              }),
        );
      });
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
              .push(MaterialPageRoute(builder: (context) => AddEventView(widget.term)));
          if (result != null) {
            print(result.title);
            dataBase.addClubEvent(result, widget.club.id, widget.term);
          } else {
          }
        },
      ),
    );
    return listEvents;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Event>>(
        stream: dataBase.streamClubEvents(widget.club.id),
        builder: (context,snapshot) {
          if(snapshot.connectionState == ConnectionState.done || snapshot.connectionState == ConnectionState.active) {
            return ExpansionTile(
                leading: Icon(Icons.event),
                title: Text(
                  "Events",
                  style: Theme
                      .of(context)
                      .accentTextTheme
                      .body2,
                ),
                children: _listOfEvents(snapshot.data));
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
                  children: _listOfEvents(null));
            }
        });
  }
}
