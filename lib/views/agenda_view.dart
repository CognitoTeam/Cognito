import 'package:cognito/views/class_details_view.dart';
/// Agenda view screen
/// Displays daily agenda
/// @author Julian Vu

import 'package:flutter/material.dart';
import 'package:flutter_calendar/flutter_calendar.dart';
import 'package:cognito/models/all_terms.dart';
import 'package:cognito/models/academic_term.dart';
import 'package:cognito/models/class.dart';
import 'package:cognito/database/database.dart';
import 'package:cognito/views/main_drawer.dart';

class AgendaView extends StatefulWidget {
  AcademicTerm term;
  DateTime selectedDate = DateTime.now();

  AgendaView({Key key, @required this.term}) : super(key: key);

  @override
  _AgendaViewState createState() => _AgendaViewState();
}

class _AgendaViewState extends State<AgendaView> {
  DataBase database = DataBase();

  AcademicTerm getCurrentTerm() {
    for (AcademicTerm term in database.allTerms.terms) {
      if (DateTime.now().isAfter(term.startTime) &&
          DateTime.now().isBefore(term.endTime)) {
        widget.term = term;
        return term;
      }
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _initializeDatabase();
      getCurrentTerm();
    });
  }

  Future<bool> _initializeDatabase() async {
    await database.startFireStore();
    setState(() {}); //update the view
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(
        term: getCurrentTerm(),
      ),
      appBar: AppBar(
        title: Text(
          "Agenda",
          style: Theme.of(context).primaryTextTheme.title,
        ),
        backgroundColor: Theme.of(context).primaryColorDark,
      ),
      body: ListView(
        children: <Widget>[
          Calendar(
            onDateSelected: (DateTime date) {
              setState(() {
                widget.selectedDate = date;
              });
            },
          ),
          FilteredClassExpansion(widget.term, widget.selectedDate),
        ],
      )
    );
  }
}

class FilteredClassExpansion extends StatefulWidget {
  final AcademicTerm term;
  final DateTime date;
  
  FilteredClassExpansion(this.term, this.date);
  
  @override
  _FilteredClassExpansionState createState() => _FilteredClassExpansionState();
}

class _FilteredClassExpansionState extends State<FilteredClassExpansion> {
  List<Widget> _classes() {
    List<Widget> classesList = List();
    if (widget.term.classes.isNotEmpty) {
      for (Class c in widget.term.classes) {
        if (c.daysOfEvent.contains(widget.date.weekday)) {
          classesList.add(
            ListTile(
              title: Text(
                c.title,
                style: Theme.of(context).accentTextTheme.body2,
              ),
              onTap: () async {
                Class result = await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ClassDetailsView(classObj: c,))
                );
                if (result != null) {
                  print("Class updated: " + result.title);
                }
              },
            )
          );
        }
      }
    }
    else {
      classesList.add(
        ListTile(
          title: Text(
            "No classes today",
            style: Theme.of(context).accentTextTheme.body2,
          ),
        )
      );
    }
    return classesList;
  }
  
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: Icon(Icons.class_),
      title: Text(
        "Classes",
        style: Theme.of(context).accentTextTheme.body2,
      ),
      children: _classes(),
    );
  }
}

