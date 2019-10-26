import 'package:cognito/database/database.dart';
import 'package:cognito/database/firebase_login.dart';
import 'package:cognito/database/notifications.dart';
import 'package:cognito/models/academic_term.dart';
import 'package:cognito/models/all_terms.dart';
import 'package:cognito/views/GPAView.dart';
import 'package:cognito/views/academic_term_view.dart';
import 'package:cognito/views/agenda_view.dart';
import 'package:cognito/views/class_view.dart';
import 'package:cognito/views/clubs_view.dart';
import 'package:cognito/views/energy_view.dart';
import 'package:cognito/views/login_selection_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatefulWidget {
  static MainDrawer _instance;
  factory MainDrawer() => _instance ??= new MainDrawer._();
  MainDrawer._();

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  Notifications noti = Notifications();
  AcademicTerm term;
  DataBase database = DataBase();
  final FireBaseLogin _fireBaseLogin = FireBaseLogin();
  String _userID = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      //TODO: what is this here for
      _getUserID();
    });
  }

  Future<String> _getUserID() async {
    String userID = await _fireBaseLogin.userName();
    if (userID != null) {
      setState(() {
        _userID = userID;
      });
    } else {
      //print("User ID null");
    }
    return userID;
  }

  Future<bool> _signOutUser() async {
    final api = await _fireBaseLogin.signOutUser();
    if (api != null) {
      return false;
    } else {
      DataBase dataBase = DataBase();
      dataBase.closeDatabase();
      await noti.cancelAllNotifications();
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    return FutureBuilder<AcademicTerm>(
      future: database.getCurrentTerm(user),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.connectionState == ConnectionState.done)
        {
          return Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Row(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text(_userID,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 22.0,
                              )),
                        ],
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Theme
                        .of(context)
                        .accentColor,
                  ),
                ),
                ListTile(
                    title: Text("Agenda"),
                    onTap: () {
                      if (snapshot == null) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return SimpleDialog(
                                title: Text(
                                    "Oops, looks like there is no current term. Create one in Academic terms."),
                                children: <Widget>[],
                              );
                            });
                      } else {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) =>
                                AgendaView(snapshot.data)));
                      }
                    }),
                ListTile(
                    title: Text("Personal Energy Levels"),
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => EnergyView()));
                    }),
                ListTile(
                  title: Text('Classes'),
                  onTap: () {
                    if (snapshot.data == null) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return SimpleDialog(
                              title: Text(
                                  "Oops, looks like there is no current term. Create one in Academic terms."),
                              children: <Widget>[],
                            );
                          });
                    }
                    else {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) =>
                              ClassView(snapshot.data)));
                    }
                  },
                ),
                ListTile(
                  title: Text('Academic Terms'),
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => AcademicTermView()));
                  },
                ),
                ListTile(
                    title: Text('Clubs'),
                    onTap: () {
                      if (snapshot == null) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return SimpleDialog(
                                title: Text(
                                    "Oops, looks like there is no current term. Create one in Academic terms."),
                                children: <Widget>[],
                              );
                            });
                      } else {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) =>
                                ClubView(snapshot.data)));
                      }
                    }
                ),
                ListTile(
                    title: Text("GPA"),
                    onTap: () {
                      term == null
                          ? showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return SimpleDialog(
                              title: Text(
                                  "Oops, looks like there is no current term. Create one in Academic terms."),
                              children: <Widget>[],
                            );
                          })
                          : Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => GPAView()));
                    }),
                RaisedButton(
                  color: Colors.red,
                  child: Text(
                    "Sign out",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  onPressed: () async {
                    bool b = await _signOutUser();
                    b
                        ? Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => LoginSelectionView()),
                        ModalRoute.withName("/LoginSelection"))
                        : print("Error SignOut!");
                  },
                ),
              ],
            ),
          );
        }
        else
          {
            return new Text("Awaiting Result...");
          }
      },
    );
  }
}
