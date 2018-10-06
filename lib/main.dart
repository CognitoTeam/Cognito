import 'package:flutter/material.dart';
import 'package:cognito/views/login_view.dart';
import 'package:cognito/views/login_selection_view.dart';
import 'package:cognito/views/academic_term_view.dart';
import 'package:cognito/views/add_term_view.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final routes = <String, WidgetBuilder> {
    LoginSelectionView.tag: (context)=>LoginSelectionView(),
    LoginView.tag: (context)=>LoginView(),
    AcademicTermView.tag: (context) => AcademicTermView(),
    AddTermView.tag: (context) => AddTermView(),
  };

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Cognito",
      theme: ThemeData(
        primaryColor: Color(0xFF3849aa),
        primaryColorLight: Color(0xFF6e74dc),
        primaryColorDark: Color(0xFF00227a),
        accentColor: Color(0xFFfbc02d),
        primaryTextTheme: TextTheme(
          title: TextStyle(color: Colors.white),
          body1: TextStyle(color: Colors.white),
          body2: TextStyle(color: Colors.white70)
        ),
        accentTextTheme: TextTheme(
          body1: TextStyle(color: Colors.black)
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(color: Colors.white70,),
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),

        ),
        hintColor: Color(0xFFfbc02d),
      ),
      home: LoginSelectionView(),
      routes: routes,
    );
  }
}