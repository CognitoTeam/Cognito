/// Class details view
/// View screen to edit a Class object
/// @author Julian Vu
///
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cognito/models/class.dart';

enum Day {M, Tu, W, Th, F, Sat, Sun}

class ClassDetailsView extends StatefulWidget {
  // Underlying class object
  Class classObj;

  // Ctor
  ClassDetailsView({Key key, @required this.classObj}) : super(key: key);

  @override
  _ClassDetailsViewState createState() => _ClassDetailsViewState();
}

class _ClassDetailsViewState extends State<ClassDetailsView> {
  DateTime startTime, endTime;
  List<int> daysOfEvent = List();

  TextEditingController _subjectController, _courseNumberController,
      _courseTitleController, _unitCountController, _locationController,
      _instructorController, _officeLocationController, _descriptionController;

  @override
  void initState() {
    super.initState();
    _subjectController = TextEditingController(text: widget.classObj.subjectArea);
    _courseNumberController = TextEditingController(text: widget.classObj.courseNumber);
    _courseTitleController = TextEditingController(text: widget.classObj.title);
    _unitCountController = TextEditingController(text: widget.classObj.units.toString());
    _locationController = TextEditingController(text: widget.classObj.location);
    _instructorController = TextEditingController(text: widget.classObj.instructor);
    _officeLocationController = TextEditingController(text: widget.classObj.officeLocation);
    _descriptionController = TextEditingController(text: widget.classObj.description);
    setState(() {
      startTime = widget.classObj.startTime;
      endTime = widget.classObj.endTime;
      daysOfEvent = widget.classObj.daysOfEvent;
    });
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
        backgroundColor: Theme.of(context).primaryColorDark,
        title: Text(_subjectController.text + _courseNumberController.text),
        leading: IconButton(
          icon: BackButtonIcon(),
          onPressed: () {
            widget.classObj.subjectArea = _subjectController.text;
            widget.classObj.courseNumber = _courseNumberController.text;
            widget.classObj.title = _courseTitleController.text;
            widget.classObj.units = int.parse(_unitCountController.text);
            widget.classObj.location = _locationController.text;
            widget.classObj.instructor = _instructorController.text;
            widget.classObj.officeLocation = _officeLocationController.text;
            widget.classObj.description = _descriptionController.text;
            widget.classObj.startTime = startTime;
            widget.classObj.endTime = endTime;
            widget.classObj.daysOfEvent = daysOfEvent;
            Navigator.of(context).pop(widget.classObj);
          },
        ),
      ),
      body: ListView(
        children: <Widget>[
          Padding(padding: EdgeInsets.all(0.0)),
          textFieldTile(hint: "Subject e.g. CS", controller: _subjectController),
          textFieldTile(
              hint: "Course number e.g. 146", controller: _courseNumberController),
          textFieldTile(
              hint: "Course title e.g. Data Structures and Algorithms", controller: _courseTitleController),
          textFieldTile(
              hint: "Number of units e.g. 4", controller: _unitCountController),
          textFieldTile(hint: "Location e.g. MQH 222", controller: _locationController),
          textFieldTile(hint: "Instructor e.g. Dr. Potika", controller: _instructorController),
          textFieldTile(
              hint: "Office location e.g. MQH 232", controller: _officeLocationController),
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
              startTime != null ? startTime.hour.toString() + ":" + startTime.minute.toString() : "",
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
              endTime != null ? endTime.hour.toString() + ":" + endTime.minute.toString() : "",
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
