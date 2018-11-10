/// club creation view
/// View screen to create a new club object
/// @author Praneet Singh
///
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cognito/models/club.dart';

enum Day {M, Tu, W, Th, F, Sat, Sun}

class AddClubView extends StatefulWidget {
  @override
  _AddClubViewState createState() => _AddClubViewState();
}

class _AddClubViewState extends State<AddClubView> {
  DateTime startTime, endTime;
  List<int> daysOfEvent = List();

  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
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
  /// Adds a day to the list of repeated days for this Club
  /// The day to add is the index of the day + 1 since enums start from 0
  void selectDay(Day day) {
    setState(() {
      daysOfEvent.add(day.index + 1);
    });
  }

  /// Helper function for deselcting a day
  /// Removes a day from list of repeated days for this club
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
        title: Text("Add New club"),
        backgroundColor: Theme.of(context).primaryColorDark,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              Navigator.of(context).pop(_titleController.text != null
                  ? Club(
                      title: _titleController.text,
                      location: _locationController.text,
                      description: _descriptionController.text,
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
          textFieldTile(
              hint: "Club title", controller: _titleController),
          textFieldTile(hint: "Location (Optional)", controller: _locationController),
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
        ],
      ),
    );
  }
}
