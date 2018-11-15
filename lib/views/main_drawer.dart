import 'package:cognito/models/academic_term.dart';
import 'package:cognito/database/firebase_login.dart';
import 'package:cognito/views/clubs_view.dart';
import 'package:cognito/views/login_selection_view.dart';
import 'package:flutter/material.dart';
import 'package:cognito/views/class_view.dart';
import 'package:cognito/views/academic_term_view.dart';
import 'package:cognito/views/agenda_view.dart';

class MainDrawer extends StatefulWidget {
  AcademicTerm term;

  MainDrawer({Key key, @required this.term});

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  final FireBaseLogin _fireBaseLogin = FireBaseLogin();
  String _userID = "";

  @override
  void initState() {
    super.initState();
    setState(() {
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
      print("User ID null");
    }
    return userID;
  }

  Future<bool> _signOutUser() async {
    final api = await _fireBaseLogin.signOutUser();
    if (api != null) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 270,
        child: Drawer(
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
                    FlatButton(
                          child: Text(
                            "Sign out",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          onPressed: () async {
                            bool b = await _signOutUser();
                            b
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            LoginSelectionView()))
                                : print("Error SignOut!");
                          },
                        ),
                  ],
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                ),
              ),
              ListTile(
                title: Text('Classes'),
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => ClassView(term: widget.term)));
                },
              ),
              ListTile(
                title: Text('Academic Terms'),
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => AcademicTermView()));
                },
              ),
              ListTile(
                  title: Text('Clubs'),
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => ClubView(term: widget.term)));
                  })
            ],
          ),
        ));
  }
}
