// Copyright 2019 UniPlan. All rights reserved

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cognito/database/database.dart';
import 'package:cognito/models/academic_term.dart';
import 'package:cognito/models/all_terms.dart';
import 'package:cognito/models/class.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Class creation view
/// [author] Julian Vu
enum Day { M, Tu, W, Th, F, Sat, Sun }

class AddClassView extends StatefulWidget {
  @override
  _AddClassViewState createState() => _AddClassViewState();
}

class _AddClassViewState extends State<AddClassView> {
  DataBase database = DataBase();
  AcademicTerm currentTerm;

  DateTime startTime, endTime;
  List<int> daysOfEvent = List();
  final firestore = Firestore.instance;


  final _subjectController = TextEditingController();
  final _courseNumberController = TextEditingController();
  final _courseTitleController = TextEditingController();
  final _unitCountController = TextEditingController();
  final _locationController = TextEditingController();
  final _instructorController = TextEditingController();
  final _officeLocationController = TextEditingController();
  final _descriptionController = TextEditingController();

  //  Stepper
  //  init step to 0th position
  int currentStep = 0;

  /// Return list of [Step] objects representing the different kinds of inputs
  /// Needed to create a [Class]
  List<Step> getSteps() {
    return [
      Step(
          title: Text(
            "Subject",
            style: Theme.of(context).accentTextTheme.body1,
          ),
          content: selectSubjectTile(),
          state: StepState.indexed,
          isActive: true),
      Step(
          title: Text(
            "Course number",
            style: Theme.of(context).accentTextTheme.body1,
          ),
          content: textFieldTile(
              hint: "Course number e.g. 146",
              controller: _courseNumberController),
          state: StepState.indexed,
          isActive: true),
      Step(
          title: Text(
            "Course title",
            style: Theme.of(context).accentTextTheme.body1,
          ),
          content: textFieldTile(
              hint: "Course title e.g. Data Structures and Algorithms",
              controller: _courseTitleController),
          state: StepState.indexed,
          isActive: true),
      Step(
          title: Text(
            "Number of units",
            style: Theme.of(context).accentTextTheme.body1,
          ),
          content: textFieldTile(
              hint: "Number of units e.g. 4", controller: _unitCountController),
          state: StepState.indexed,
          isActive: true),
      Step(
          title: Text(
            "Location",
            style: Theme.of(context).accentTextTheme.body1,
          ),
          content: textFieldTile(
              hint: "Location e.g. MQH 222", controller: _locationController),
          state: StepState.indexed,
          isActive: true),
      Step(
          title: Text(
            "Instructor",
            style: Theme.of(context).accentTextTheme.body1,
          ),
          content: textFieldTile(
              hint: "Instructor e.g. Dr. Potika",
              controller: _instructorController),
          state: StepState.indexed,
          isActive: true),
      Step(
          title: Text(
            "Office Location",
            style: Theme.of(context).accentTextTheme.body1,
          ),
          content: textFieldTile(
              hint: "Office location e.g. MQH 232",
              controller: _officeLocationController),
          state: StepState.indexed,
          isActive: true),
      Step(
          title: Text(
            "Desciption",
            style: Theme.of(context).accentTextTheme.body1,
          ),
          content: TextFormField(
            controller: _descriptionController,
            autofocus: false,
            style: Theme.of(context).accentTextTheme.body1,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.done,
            maxLines: 5,
            decoration: InputDecoration(
                hintText: "Description",
                hintStyle: TextStyle(color: Colors.black45)),
          ),
          state: StepState.indexed,
          isActive: true),
      Step(
          title: Text(
            "Start and End times",
            style: Theme.of(context).accentTextTheme.body1,
          ),
          content: _timeSelectionColumn(),
          isActive: true,
          state: StepState.indexed),
      Step(
        title: Text(
          "Days repeated",
          style: Theme.of(context).accentTextTheme.body1,
        ),
        content: _repeatingDaySelectionTile(),
        state: StepState.indexed,
        isActive: true,
      )
    ];
  }

  /// Returns [ListTile] widget containing checkboxes that represent the
  /// days in the week that this [Class] repeats
  ListTile _repeatingDaySelectionTile() {
    return ListTile(
      title: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              daySelectionColumn(Day.M),
              daySelectionColumn(Day.Tu),
              daySelectionColumn(Day.W),
              daySelectionColumn(Day.Th),
              daySelectionColumn(Day.F),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              daySelectionColumn(Day.Sat),
              daySelectionColumn(Day.Sun),
            ],
          )
        ],
      ),
    );
  }

  /// Returns a [Column] containing the start and end time selection tiles
  Column _timeSelectionColumn() {
    return Column(
      children: <Widget>[
        _timeSelectionTile(true),
        Divider(),
        _timeSelectionTile(false),
      ],
    );
  }

  /// Returns a [ListTile] for selecting the start or end time depending on
  /// the boolean input.
  ListTile _timeSelectionTile(bool isStart) {
    return ListTile(
      leading: Icon(Icons.access_time),
      title: Text(
        isStart ? "Select Start Time" : "Select End Time",
        style: Theme.of(context).accentTextTheme.body2,
      ),
      trailing: isStart
          ? Text(
              startTime != null ? DateFormat.jm().format(startTime) : "",
            )
          : Text(endTime != null ? DateFormat.jm().format(endTime) : ""),
      onTap: () => _selectTime(isStart, context),
    );
  }

  /// Returns a [ListTile] containing a [TextFormField] for user input.
  ListTile textFieldTile(
      {Widget leading,
      Widget trailing,
      TextInputType keyboardType,
      String hint,
      Widget subtitle,
      TextEditingController controller}) {
    return ListTile(
      leading: leading,
      trailing: trailing,
      title: TextField(
        controller: controller,
        autofocus: false,
        keyboardType: keyboardType,
        style: Theme.of(context).accentTextTheme.body1,
        decoration: InputDecoration(
          labelText: hint,
          labelStyle: TextStyle(color: Colors.black45),
        ),
      ),
      subtitle: subtitle,
    );
  }

  /// Helper function for selecting a day
  /// Adds a day to the list of repeated days for this class
  /// The day to add is the index of the day + 1 since enums start from 0
  void selectDay(Day day) {
    setState(() {
      daysOfEvent.add(day.index + 1);
    });
  }

  void getCurrentTerm() async {
    AllTerms terms = await database.getTerms();
    for (AcademicTerm term in terms.terms) {
      if (DateTime.now().isAfter(term.startTime) &&
          DateTime.now().isBefore(term.endTime)) {
        this.currentTerm = term;
      }
    }
  }

  /// Helper function for deselcting a day
  /// Removes a day from list of repeated days for this class
  /// The day to remove is the index of the day + 1 since enums start from 0
  void deselectDay(Day day) {
    setState(() {
      daysOfEvent.remove(day.index + 1);
    });
  }

  /// Creates a Column object that contains a label for the day to be selected
  /// and a check box for that day
  Column daySelectionColumn(Day day) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(day.toString().substring(4)),
        Checkbox(
          value: daysOfEvent.contains(day.index + 1),
          onChanged: (bool e) {
            daysOfEvent.contains(day.index + 1)
                ? deselectDay(day)
                : selectDay(day);
          },
        ),
      ],
    );
  }

  /// Shows time picker dialog and returns the time chosen
  Future<Null> _selectTime(bool isStart, BuildContext context) async {
    // Hide keyboard before showing time picker
    FocusScope.of(context).requestFocus(FocusNode());

    // Add delay to be sure keyboard is no longer visible
    await Future.delayed(Duration(milliseconds: 200));

    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: isStart
          ? startTime != null
              ? TimeOfDay(hour: startTime.hour, minute: startTime.minute)
              : TimeOfDay.now()
          : endTime != null
              ? TimeOfDay(hour: endTime.hour, minute: endTime.minute)
              : TimeOfDay.now(),
    );

    if (picked != null) {
      print("Date selected: ${picked.toString()}");
      setState(() {
        isStart
            ? startTime = DateTime(2018, 1, 1, picked.hour, picked.minute)
            : endTime = DateTime(2018, 1, 1, picked.hour, picked.minute);
        print(isStart ? startTime.toString() : endTime.toString());
      });
    }
  }

  /// Returns the list of subjects from the academic term
  List<Widget> _listOfSubjects() {
    List<Widget> listSubjects =
        database.allTerms.subjects.map((String subjectItem) {
      return ListTile(
        title: Text(subjectItem),
        onLongPress: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return SimpleDialog(
                    title:
                        Text("Are you sure you want to delete " + subjectItem),
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RaisedButton(
                            color: Colors.white,
                            child: Text("Yes"),
                            onPressed: () {
                              setState(() {
                                database.allTerms.subjects.remove(subjectItem);
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();

                                database.updateDatabase();
                              });
                            },
                          ),
                          RaisedButton(
                            color: Colors.white,
                            child: Text("Cancel"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      )
                    ]);
              });
        },
        onTap: () {
          setState(() {
            _subjectController.text = subjectItem;
          });
          Navigator.pop(context);
        },
      );
    }).toList(growable: true);
    listSubjects.add(ListTile(
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return SimpleDialog(
                  title: Text("Enter New Subject Name"),
                  children: <Widget>[
                    TextFormField(
                      style: Theme.of(context).accentTextTheme.body1,
                      decoration: InputDecoration(
                        hintText: "Subject e.g. CS",
                        hintStyle: TextStyle(color: Colors.black45),
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      ),
                      onFieldSubmitted: (val) {
                        print(val);
                        setState(() {
                          database.allTerms.addSubject(val);
                          database.updateDatabase();
                          print(database.allTerms.subjects);
                        });
                        Navigator.pop(context);
                      },
                      textInputAction: TextInputAction.done,
                    ),
                  ],
                );
              });
        },
        title: Text("Add subject")));
    return listSubjects;
  }

  /// Shows dialog window to select a subject
  void _showSubjectSelectionDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
              title: Text("Choose a subject"), children: _listOfSubjects());
        });
  }

  /// Returns [ListTile] containing a subject
  ListTile selectSubjectTile() {
    return ListTile(
      leading: Icon(Icons.chevron_right),
      title: _subjectController.text.isNotEmpty
          ? Text(
              "Subject: " + _subjectController.text,
              style: Theme.of(context).accentTextTheme.body1,
            )
          : Text(
              "Choose a subject",
              style: Theme.of(context).accentTextTheme.body1,
            ),
      onTap: () {
        _showSubjectSelectionDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Class"),
        backgroundColor: Theme.of(context).primaryColorDark,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              getCurrentTerm();
              Navigator.of(context).pop(_subjectController != null
                  ? Class(
                      subjectArea: _subjectController.text,
                      courseNumber: _courseNumberController.text,
                      title: _courseTitleController.text,
                      units: int.parse(_unitCountController.text),
                      location: _locationController.text,
                      instructor: _instructorController.text,
                      officeLocation: _officeLocationController.text,
                      description: _descriptionController.text,
                      daysOfEvent: daysOfEvent,
                      start: startTime,
                      end: endTime,
                      id: currentTerm.getID())
                  : null);
            },
          ),
        ],
      ),
      body: Stepper(
        currentStep: this.currentStep,
        steps: getSteps(),
        type: StepperType.vertical,
        onStepTapped: (step) {
          setState(() {
            currentStep = step;
          });
        },
        onStepCancel: () {
          setState(() {
            if (currentStep > 0) {
              currentStep--;
            } else {
              currentStep = 0;
            }
          });
        },
        onStepContinue: () {
          setState(() {
            if (currentStep < getSteps().length - 1) {
              currentStep++;
            } else {
              Navigator.of(context).pop(_subjectController != null
                  ?
              database.addClass(_subjectController.text,
                  _courseNumberController.text, _courseTitleController.text,
                  int.parse(_unitCountController.text),  _locationController.text,
                  _instructorController.text, _officeLocationController.text,
                  _descriptionController.text, daysOfEvent, startTime, endTime)
                  : null);
            }
          });
        },
      ),
    );
  }


}
