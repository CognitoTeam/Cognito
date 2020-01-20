// Copyright 2019 UniPlan. All rights reserved.

import 'package:cognito/database/database.dart';
import 'package:cognito/models/academic_term.dart';
import 'package:cognito/models/assignment.dart';
import 'package:cognito/models/category.dart';
import 'package:cognito/models/class.dart';
import 'package:flutter/material.dart';

class GradeBookView extends StatefulWidget {
  final Class selectedClass;
  final AcademicTerm term;
  DataBase database = DataBase();

  GradeBookView({Key key, @required this.selectedClass, @required this.term}) : super(key: key);

  @override
  _GradeBookViewState createState() => _GradeBookViewState();
}

class _GradeBookViewState extends State<GradeBookView> {
  List<Widget> rowsOfWidgets() {
    List<Widget> rowsOfWidgets = [];
    Class selectedClass = widget.selectedClass;
    rowsOfWidgets.add(ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "Title",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            "Grade",
            style: TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    ));

    // Assignments
    if (selectedClass.assignments.isNotEmpty) {
      for (Assignment a in selectedClass.assignments) {
        rowsOfWidgets.add(ListTile(
          title: Text(
            a.title,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Text(
              a.pointsEarned.toString() + "/" + a.pointsPossible.toString()),
        ));
        rowsOfWidgets.add(Divider());
      }
    }

    // Assessments
    if (selectedClass.assessments.isNotEmpty) {
      for (Assignment a in selectedClass.assessments) {
        rowsOfWidgets.add(
          ListTile(
            title: Text(a.title),
            trailing: Text(
                a.pointsEarned.toString() + "/" + a.pointsPossible.toString()),
          ),
        );
        rowsOfWidgets.add(Divider());
      }
    }

    // Categorical breakdown
    rowsOfWidgets.add(Divider());
    for (Category c in selectedClass.categories) {
      rowsOfWidgets.add(
        ListTile(
            title: Text(c.title),
            trailing: Text(c.weightInPercentage.toString() + "%")),
      );
    }
    rowsOfWidgets.add(Divider());

    // Total Grade
    rowsOfWidgets.add(Divider());
    rowsOfWidgets.add(ListTile(
        title: Text(
          "Total",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: Text(
          selectedClass.getGrade(selectedClass.assessments, selectedClass.assignments, selectedClass.categories),
          style: TextStyle(fontWeight: FontWeight.bold),
        )));
    return rowsOfWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        title: Text("Grades for " +
            widget.selectedClass.subjectArea +
            widget.selectedClass.courseNumber),
        leading: IconButton(
          icon: BackButtonIcon(),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ListView(children: rowsOfWidgets()),
    );
  }
}
