/// Class view
/// Displays list of Class cards
/// @author Julian Vu
import 'package:flutter/material.dart';
import 'package:cognito/models/class.dart';
import 'package:cognito/models/academic_term.dart';

class ClassView extends StatefulWidget {
  // Academic term object
  final AcademicTerm term;

  // Constructor that takes in an academic term object
  ClassView({Key key, @required this.term}) : super(key: key);

  @override
  _ClassViewState createState() => _ClassViewState();
}

class _ClassViewState extends State<ClassView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.term.termName + " - Classes",
          style: Theme.of(context).primaryTextTheme.title,
        ),
        backgroundColor: Theme.of(context).primaryColorDark,
      ),
    );
  }
}
