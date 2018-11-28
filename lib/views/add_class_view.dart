import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cognito/models/class.dart';

/// Class creation view
/// View screen to create a new Class object
/// @author Julian Vu
enum Day { M, Tu, W, Th, F, Sat, Sun }

class AddClassView extends StatefulWidget {
  @override
  _AddClassViewState createState() => _AddClassViewState();
}

class _AddClassViewState extends State<AddClassView> {
  DataBase database = DataBase();

  @override
  void initState() {
    super.initState();
    setState(() {
      _initializeDatabase();
    });
  }

  Future<bool> _initializeDatabase() async {
    await database.startFireStore();
    setState(() {}); //update the view
  }

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

  /// Helper function for selecting a day
  /// Adds a day to the list of repeated days for this class
  /// The day to add is the index of the day + 1 since enums start from 0
  void selectDay(Day day) {
    setState(() {
      daysOfEvent.add(day.index + 1);
    });
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

  List<Widget> _listOfSubjects() {
    List<Widget> listSubjects = database.allTerms.subjects.map((String subjectItem) {
        return ListTile(
          title: Text(subjectItem),
        );
      }).toList(growable: true);
    listSubjects.add(ListTile(onTap: () => print("Pressed add subjects button"), title: Text("Add subject")));
    return listSubjects;
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
                      end: endTime)
                  : null);
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Padding(padding: EdgeInsets.all(0.0)),
          ListTile(
            title: Text("Subject"),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    title: Text("Choose a subject"),
                    children: _listOfSubjects()
                  );
                }
              );
            },
          ),
          textFieldTile(
              hint: "Course number e.g. 146",
              controller: _courseNumberController),
          textFieldTile(
              hint: "Course title e.g. Data Structures and Algorithms",
              controller: _courseTitleController),
          textFieldTile(
              hint: "Number of units e.g. 4", controller: _unitCountController),
          textFieldTile(
              hint: "Location e.g. MQH 222", controller: _locationController),
          textFieldTile(
              hint: "Instructor e.g. Dr. Potika",
              controller: _instructorController),
          textFieldTile(
              hint: "Office location e.g. MQH 232",
              controller: _officeLocationController),
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
              startTime != null
                  ? startTime.hour.toString() +
                      ":" +
                      startTime.minute.toString()
                  : "",
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
              endTime != null
                  ? endTime.hour.toString() + ":" + endTime.minute.toString()
                  : "",
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
