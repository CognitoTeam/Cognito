import 'dart:async';

import 'package:cognito/database/database.dart';
import 'package:cognito/models/academic_term.dart';
import 'package:cognito/models/event.dart';
import 'package:cognito/views/add_priority_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

/// Event creation view
/// @author Praneet Singh

enum Day { M, Tu, W, Th, F, Sat, Sun }

class AddEventView extends StatefulWidget {

  AcademicTerm enteredTerm;

  AddEventView(this.enteredTerm);

  @override
  _AddEventViewState createState() => _AddEventViewState();
}

class _AddEventViewState extends State<AddEventView> {
  DataBase database = DataBase();
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _durationController = TextEditingController();

  bool _isRepeated = false;
  DateTime startTime, endTime;
  List<int> daysOfEvent = List();
  int _selectedPriority = 1;

  //  Stepper
  //  init step to 0th position
  int currentStep = 0;

  /// Return list of [Step] objects representing the different kinds of inputs
  /// Needed to create an [Event]
  List<Step> getSteps() {
    return [
      Step(
          title: Text(
            "Event title",
            style: Theme.of(context).accentTextTheme.body1,
          ),
          content:
              textFieldTile(hint: "Event title", controller: _titleController),
          state: StepState.indexed,
          isActive: true),
      Step(
          title: Text(
            "Location",
            style: Theme.of(context).accentTextTheme.body1,
          ),
          content:
              textFieldTile(hint: "Location", controller: _locationController),
          state: StepState.indexed,
          isActive: true),
      Step(
          title: Text(
            "Description",
            style: Theme.of(context).accentTextTheme.body1,
          ),
          content: ListTile(
            title: TextFormField(
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
          ),
          state: StepState.indexed,
          isActive: true),
      Step(
          title: Text(
            "Start and End times",
            style: Theme.of(context).accentTextTheme.body1,
          ),
          content: _timeSelectionColumn(),
          state: StepState.indexed,
          isActive: true),
      Step(
          title: Text(
            "Estimated duration",
            style: Theme.of(context).accentTextTheme.body1,
          ),
          content: textFieldTile(
              hint: "In minutes", controller: _durationController),
          state: StepState.indexed,
          isActive: true),
      Step(
          title: Text(
            "Days repeated",
            style: Theme.of(context).accentTextTheme.body1,
          ),
          content: _repeatingDaySelectionTile(),
          state: StepState.indexed,
          isActive: true),
      Step(
          title: Text(
            "Select priority",
            style: Theme.of(context).accentTextTheme.body1,
          ),
          state: StepState.indexed,
          isActive: true,
          content: ListTile(
            title: Text(
              "Priority selected:",
              style: Theme.of(context).accentTextTheme.body1,
            ),
            trailing: Text(_selectedPriority.toString()),
            onTap: () async {
              int result = await showDialog(
                  context: context,
                  builder: (context) => AddPriorityDialog(_selectedPriority));
              if (result != null) {
                setState(() {
                  _selectedPriority = result;
                });
              }
            },
          ))
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
      title: TextFormField(
        controller: controller,
        autofocus: false,
        keyboardType: keyboardType,
        style: Theme.of(context).accentTextTheme.body1,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.black45),
        ),
      ),
      subtitle: subtitle,
    );
  }

  void selectDay(Day day) {
    setState(() {
      daysOfEvent.add(day.index + 1);
    });
  }

  void deselectDay(Day day) {
    setState(() {
      daysOfEvent.remove(day.index + 1);
    });
  }

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
            if (daysOfEvent.isEmpty) {
              _isRepeated = false;
              print(_isRepeated);
            } else {
              _isRepeated = true;
              print(_isRepeated);
            }
          },
        ),
      ],
    );
  }

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
  //TODO: Should add to term that is currently logged into
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
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Event"),
        backgroundColor: Theme.of(context).primaryColorDark,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () async {
              if(_titleController != null) {
                database.addEvent(
                  user.uid,
                    _titleController.text,
                    _locationController.text,
                    _descriptionController.text,
                    daysOfEvent,
                    _isRepeated,
                    startTime,
                    endTime,
                    _selectedPriority,
                    Duration(
                        minutes: int.parse(_durationController.text)
                    ),
                widget.enteredTerm, null);
              }
              Navigator.of(context).pop(_titleController != null
                  ? Event(
                  title: _titleController.text,
                  location: _locationController.text,
                  description: _descriptionController.text,
                  daysOfEvent: daysOfEvent,
                  isRepeated: _isRepeated,
                  start: startTime,
                  end: endTime,
                  priority: _selectedPriority,
                  duration: Duration(
                      minutes: int.parse(_durationController.text)))
                  : null);
            },
          )
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
              if(_titleController != null) {
                database.addEvent(
                    user.uid,
                    _titleController.text,
                    _locationController.text,
                    _descriptionController.text,
                    daysOfEvent,
                    _isRepeated,
                    startTime,
                    endTime,
                    _selectedPriority,
                    Duration(
                        minutes: int.parse(_durationController.text)
                    ),
                widget.enteredTerm, null);
              }
              Navigator.of(context).pop(_titleController != null
                  ? Event(
                  title: _titleController.text,
                  location: _locationController.text,
                  description: _descriptionController.text,
                  daysOfEvent: daysOfEvent,
                  isRepeated: _isRepeated,
                  start: startTime,
                  end: endTime,
                  priority: _selectedPriority,
                  duration: Duration(
                      minutes: int.parse(_durationController.text)))
                  : null);
            }
          });
        },
      ),
    );
  }
}
