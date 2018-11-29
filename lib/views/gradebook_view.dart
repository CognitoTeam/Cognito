import 'package:cognito/database/database.dart';
import 'package:cognito/models/academic_term.dart';
import 'package:cognito/models/assignment.dart';
import 'package:cognito/models/class.dart';
import 'package:flutter/material.dart';

class GradeBookView extends StatefulWidget {
  @override
  _GradeBookViewtate createState() => _GradeBookViewtate();
}

class _GradeBookViewtate extends State<GradeBookView> {
  AcademicTerm term;
  AcademicTerm getCurrentTerm() {
    for (AcademicTerm term in database.allTerms.terms) {
      if (DateTime.now().isAfter(term.startTime) &&
          DateTime.now().isBefore(term.endTime)) {
        this.term = term;
        return term;
      }
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      getCurrentTerm();
    });
  }

  Class selected;
  DataBase database = DataBase();
  List<Widget> _listOfClass() {
    List<Widget> listTasks = List();
    if (term.classes.isNotEmpty) {
      for (Class c in term.classes) {
        listTasks.add(
          ListTile(
              title: Text(
                c.title,
                style: Theme.of(context).accentTextTheme.body2,
              ),
              onTap: () {
                setState(() {
                  selected = c;
                });
              }),
        );
      }
    } else {
      listTasks.add(ListTile(
          title: Text(
        "No Classes so far",
        style: Theme.of(context).accentTextTheme.body2,
      )));
    }
    return listTasks;
  }

  List<Widget> rowsOfWidgets(Class c) {
    List<Widget> rowsOfWidgets = List();
    rowsOfWidgets.add(ExpansionTile(
        title: Text(selected == null ? "Select a class" : selected.title),
        children: _listOfClass()));
    if (c == null) {
      return rowsOfWidgets;
    } else {
      if (c.assignments.isNotEmpty) {
        for (Assignment a in c.assignments) {
          rowsOfWidgets.add(ListTile(
            title: Text(a.title + "\t"),
            trailing: Text(
                ((a.pointsEarned / a.pointsPossible) * 100).toString() + "%"),
            subtitle: Text(
                a.pointsEarned.toString() + "/" + a.pointsPossible.toString()),
          ));
        }
      }
      if (c.assessments.isNotEmpty) {
        for (Assignment a in c.assessments) {
          rowsOfWidgets.add(ListTile(
            title: Text(a.title + "\t"),
            trailing: Text(
                ((a.pointsEarned / a.pointsPossible) * 100).toString() + "%"),
            subtitle: Text(
                a.pointsEarned.toString() + "/" + a.pointsPossible.toString()),
          ));
        }
      }
    }
    if (rowsOfWidgets.length == 1) {
      rowsOfWidgets.add(ListTile(
        title: Text("No assignments have been added yet"),
      ));
    }
    return rowsOfWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Grade Book",
            style: Theme.of(context).primaryTextTheme.title,
          ),
          backgroundColor: Theme.of(context).primaryColorDark,
        ),
        body: ListView(children: rowsOfWidgets(selected)));
  }
}
