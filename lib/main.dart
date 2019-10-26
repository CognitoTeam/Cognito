import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cognito/database/database.dart';
import 'package:cognito/models/academic_term.dart';
import 'package:cognito/views/login_selection_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main(){

  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context){
    DataBase db = DataBase();
    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser>.value(
          value: FirebaseAuth.instance.onAuthStateChanged,
      ),
    ],
      child: new MaterialApp(
        title: "UniPlan",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color(0xFF00227a),
          primaryColorLight: Color(0xFF6e74dc),
          primaryColorDark: Color(0xFF00227a),
          accentColor: Color(0xFFfbc02d),
          primaryTextTheme: TextTheme(
              title: TextStyle(color: Colors.white),
              body1: TextStyle(color: Colors.white, fontSize: 14.0),
              body2: TextStyle(color: Colors.white70)),
          accentTextTheme:
              TextTheme(body1: TextStyle(color: Colors.black, fontSize: 14.0)),
          inputDecorationTheme: InputDecorationTheme(
            hintStyle: TextStyle(
              color: Colors.white70,
            ),
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          ),
          hintColor: Color(0xFFfbc02d),
        ),
        home: LoginSelectionView(),
      )
    );
  }
}
