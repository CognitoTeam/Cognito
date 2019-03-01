import 'package:cognito/database/database.dart';
import 'package:cognito/models/academic_term.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cognito/models/event.dart';

/// Event creation view
/// @author Praneet Singh

enum Day { M, Tu, W, Th, F, Sat, Sun }

class AddEventView extends StatefulWidget {
  @override
  _AddEventViewState createState() => _AddEventViewState();
}

class _AddEventViewState extends State<AddEventView> {
  DataBase database = DataBase();
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isRepeated = false;
  DateTime startTime, endTime;
  List<int> daysOfEvent = List();
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
      initialTime: TimeOfDay.now(),
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
      appBar: AppBar(
        title: Text("Add New Event"),
        backgroundColor: Theme.of(context).primaryColorDark,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              Navigator.of(context).pop(_titleController != null
                  ? Event(
                      title: _titleController.text,
                      location: _locationController.text,
                      description: _descriptionController.text,
                      daysOfEvent: daysOfEvent,
                      isRepeated: _isRepeated,
                      start: startTime,
                      end: endTime,
                      id: getCurrentTerm().getID()
                    )
                  : null);
            },
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          Padding(padding: EdgeInsets.all(0.0)),
          textFieldTile(hint: "Title", controller: _titleController),
          textFieldTile(hint: "Location", controller: _locationController),
          ListTile(
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
          ListTile(
            leading: Icon(Icons.access_time),
            title: Text(
              "Select Start Time",
              style: Theme.of(context).accentTextTheme.body2,
            ),
            trailing: Text(
              startTime != null ? startTime.toString() : "",
            ),
            onTap: () => _selectTime(true, context),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.access_time),
            title: Text(
              "Select End Time",
              style: Theme.of(context).accentTextTheme.body2,
            ),
            trailing: Text(
              endTime != null ? endTime.toString() : "",
            ),
            onTap: () => _selectTime(false, context),
          ),
          Divider(),
          Text(
            "Repeat",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          Divider(),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                daySelectionColumn(Day.Sun),
                daySelectionColumn(Day.M),
                daySelectionColumn(Day.Tu),
                daySelectionColumn(Day.W),
                daySelectionColumn(Day.Th),
                daySelectionColumn(Day.F),
                daySelectionColumn(Day.Sat),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
