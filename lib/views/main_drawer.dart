import 'package:cognito/database/database.dart';
import 'package:cognito/database/firebase_login.dart';
import 'package:cognito/database/notifications.dart';
import 'package:cognito/models/academic_term.dart';
import 'package:cognito/views/GPAView.dart';
import 'package:cognito/views/clubs_view.dart';
import 'package:cognito/views/login_selection_view.dart';
import 'package:flutter/material.dart';
import 'package:cognito/views/class_view.dart';
import 'package:cognito/views/academic_term_view.dart';
import 'package:cognito/views/agenda_view.dart';
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
      _getUserID();
      getCurrentTerm();
    });
  }

  Future<String> _getUserID() async {
    String userID = await _fireBaseLogin.userName();
    if (userID != null) {
      setState(() {
        _userID = userID;
      });
    } else {
      print("User ID null");
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

  AcademicTerm getCurrentTerm() {
    for (AcademicTerm term in database.allTerms.terms) {
      if (DateTime.now().isAfter(term.startTime) &&
          DateTime.now().isBefore(term.endTime)) {
        setState(() {
          this.term = term;
        });
        return term;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
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
              color: Theme.of(context).accentColor,
            ),
          ),
          ListTile(
              title: Text("Agenda"),
              onTap: () {
                term == null
                    ? showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return SimpleDialog(
                            title: Text(
                                "You have to create an Academic term first!"),
                            children: <Widget>[],
                          );
                        })
                    : Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => AgendaView()));
              }),
          ListTile(
            title: Text('Classes'),
            onTap: () {
              term == null
                  ? showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return SimpleDialog(
                          title: Text(
                              "You have to create an Academic term first!"),
                          children: <Widget>[],
                        );
                      })
                  : Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => ClassView()));
            },
          ),
          ListTile(
            title: Text('Academic Terms'),
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => AcademicTermView()));
            },
          ),
          ListTile(
              title: Text('Clubs'),
              onTap: () {
                term == null
                    ? showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return SimpleDialog(
                            title: Text(
                                "You have to create an Academic term first!"),
                            children: <Widget>[],
                          );
                        })
                    : Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => ClubView()));
              }),
          ListTile(
              title: Text("GPA"),
              onTap: () {
                term == null
                    ? showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return SimpleDialog(
                            title: Text(
                                "You have to create an Academic term first!"),
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
}
