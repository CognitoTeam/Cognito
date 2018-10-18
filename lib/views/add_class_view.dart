/// Class creation view
/// View screen to create a new Class object
/// @author Julian Vu
///
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cognito/models/class.dart';

enum Day {M, Tu, W, Th, F, Sat, Sun}

class AddClassView extends StatefulWidget {
  @override
  _AddClassViewState createState() => _AddClassViewState();
}

class _AddClassViewState extends State<AddClassView> {
  DateTime startTime, endTime;
  List<int> daysOfEvent = List();

  final _subjectController = TextEditingController();
  final _courseNumberController = TextEditingController();
  final _courseTitleController = TextEditingController();
  final _unitCountController = TextEditingController();
  final _locationController = TextEditingController();
  final _instructorController = TextEditingController();
  final _officeLocationController = TextEditingController();
  final _descriptionController = TextEditingController();

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
            daysOfEvent.contains(day.index + 1) ? deselectDay(day) : selectDay(day);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Class"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
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
                      daysOfEvent: daysOfEvent)
                  : null);
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Padding(padding: EdgeInsets.all(0.0)),
          textFieldTile(hint: "Subject", controller: _subjectController),
          textFieldTile(
              hint: "Course number", controller: _courseNumberController),
          textFieldTile(
              hint: "Course title", controller: _courseTitleController),
          textFieldTile(
              hint: "Number of units", controller: _unitCountController),
          textFieldTile(hint: "Location", controller: _locationController),
          textFieldTile(hint: "Instructor", controller: _instructorController),
          textFieldTile(
              hint: "Office location", controller: _officeLocationController),
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
