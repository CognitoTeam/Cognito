// Copyright 2019 UniPlan. All rights reserved.

import 'package:cognito/models/academic_term.dart';
import 'package:cognito/models/assignment.dart';
import 'package:cognito/models/category.dart';
import 'package:cognito/models/class.dart';
import 'package:flutter/material.dart';

class GradeBookView extends StatefulWidget {
  final Class selectedClass;

  GradeBookView({Key key, @required this.selectedClass}) : super(key: key);

  @override
  _GradeBookViewState createState() => _GradeBookViewState();
}

class _GradeBookViewState extends State<GradeBookView> {
  AcademicTerm term;

  List<Widget> rowsOfWidgets() {
    List<Widget> rowsOfWidgets = [];
    Class selectedClass = widget.selectedClass;

    rowsOfWidgets.add(ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: <Widget>[
              Text(
                "Name",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Text(
                "Status",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Text(
                "Grade",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          )
        ],
      ),
    ));

    // Assignments
    if (selectedClass.assignments.isNotEmpty) {
      for (Assignment a in selectedClass.assignments) {
        rowsOfWidgets.add(ListTile(
          leading: Column(
            children: <Widget>[
              Text(a.title),
            ],
          ),
          title: Column(
            children: <Widget>[
              Text("STATUS"),
            ],
          ),
          trailing: Column(
            children: <Widget>[
              Text(a.pointsEarned.toString() +
                  "/" +
                  a.pointsPossible.toString()),
            ],
          ),
        ));
        rowsOfWidgets.add(Divider());
      }
    }

    // Assessments
    if (selectedClass.assessments.isNotEmpty) {
      for (Assignment a in selectedClass.assessments) {
        rowsOfWidgets.add(ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(a.title),
              Text("STATUS"),
              Text(a.pointsEarned.toString() +
                  "/" +
                  a.pointsPossible.toString()),
            ],
          ),
        ));
        rowsOfWidgets.add(Divider());
      }
    }

    // Categorical breakdown
    rowsOfWidgets.add(Divider());
    for (Category c in selectedClass.categories) {
      rowsOfWidgets.add(ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(c.title),
            Text(c.getPercentage().toString() + "%")
          ],
        ),
      ));
    }
    rowsOfWidgets.add(Divider());

    // Total Grade
    rowsOfWidgets.add(Divider());
    rowsOfWidgets.add(ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "Total",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            selectedClass.getPercentage() + " - " + selectedClass.getGrade(),
            style: TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    ));
    return rowsOfWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: rowsOfWidgets());
  }
}
