/// Academic term view screen
/// View, create, edit academic terms
/// @author Julian Vu
import 'package:flutter/material.dart';
import 'package:cognito/models/academic_term.dart';
import 'package:cognito/views/add_term_view.dart';
import 'dart:async';

class AcademicTermView extends StatefulWidget {
  static String tag = "academic-term-view";
  @override
  _AcademicTermViewState createState() => _AcademicTermViewState();
}

class _AcademicTermViewState extends State<AcademicTermView> {
  List<AcademicTerm> _terms = List();



  _addTerm() {
    print("Adding new term...");

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Academic Terms",
            style: Theme.of(context).primaryTextTheme.title,
          ),
          backgroundColor: Theme.of(context).primaryColorDark,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.add_circle,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () {
                print("Pressed plug button.");
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print("Pressed floating button.");
            Navigator.of(context).pushNamed(AddTermView.tag);
          },
          child: Icon(
            Icons.add,
            size: 42.0,
          ),
          backgroundColor: Theme.of(context).accentColor,
          foregroundColor: Colors.black,
        ),
        backgroundColor: Theme.of(context).primaryColor,
      );
  }
}
