import 'dart:async';

import 'package:cognito/database/firebase_login.dart';
import 'package:cognito/views/login_selection_view.dart';
import 'package:flutter/material.dart';


class HomeView extends StatefulWidget {
  
  static String tag = "home-view";
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  FireBaseLogin _fireBaseLogin = FireBaseLogin();

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
     final signOut = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: ButtonTheme(
        minWidth: 200.0,
        height: 42.0,
        child: RaisedButton(
          onPressed: () async {
                          bool b = await _signOutUser();

                          b ? Navigator.push(context, MaterialPageRoute(builder: (context) => LoginSelectionView()))
                              : print("Error SignOut!");
                          },
          color: Theme.of(context).accentColor,
          child: Text("Sign Out", style: Theme.of(context).accentTextTheme.body1),
        ),
      ),
    );
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: ListView(
          children: <Widget>[
            Text("Welcome!"),
            signOut            
          ],
        )
      )
    );}
}