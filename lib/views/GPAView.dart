import 'package:cognito/database/database.dart';
import 'package:cognito/models/academic_term.dart';
import 'package:cognito/models/gpa_calculator.dart';
import 'package:cognito/views/main_drawer.dart';
import 'package:flutter/material.dart';

/// GPA view
/// @author Praneet Singh
///
class GPAView extends StatefulWidget {
  @override
  _GPAViewState createState() => _GPAViewState();
}

class _GPAViewState extends State<GPAView> {
  DataBase database = DataBase();

  List<Widget> allTermGPA() {
    List<Widget> all = List();
    GPACalculator gpa = GPACalculator();
    for (AcademicTerm t in database.allTerms.terms) {
      gpa.addTerm(t);
    }
    for (AcademicTerm t in gpa.termsMap.keys) {
      all.add(ListTile(
        title: Text(t.termName),
        trailing: Text(gpa.termsMap[t].toStringAsFixed(2)),
      ));
    }
    return all;
  }

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  double calculateGPA() {
    GPACalculator gpa = GPACalculator();
    for (AcademicTerm t in database.allTerms.terms) {
      gpa.addTerm(t);
    }
    return gpa.gpa;
  }

  AcademicTerm getCurrentTerm() {
    for (AcademicTerm term in database.allTerms.terms) {
      if (DateTime.now().isAfter(term.startTime) &&
          DateTime.now().isBefore(term.endTime)) {
        return term;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text(
          "GPA",
          style: Theme.of(context).primaryTextTheme.title,
        ),
        backgroundColor: Theme.of(context).primaryColorDark,
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text("Overall GPA:"),
            trailing: Text(calculateGPA().toStringAsFixed(2)),
          ),
          Column(children: allTermGPA())
        ],
      ),
    );
  }
}
