/// Class creation view
/// View screen to create a new Class object
/// @author Julian Vu
///
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cognito/models/class.dart';

class AddClassView extends StatefulWidget {

  @override
  _AddClassViewState createState() => _AddClassViewState();
}

class _AddClassViewState extends State<AddClassView> {
  TimeOfDay startTime, endTime;
  String className;

  final _subjectController = TextEditingController();
  final _courseNumberController = TextEditingController();
  final _courseTitleController = TextEditingController();
  final _unitCountController = TextEditingController();
  final _locationController = TextEditingController();
  final _instructorController = TextEditingController();
  final _officeLocationController = TextEditingController();
  final _descriptionController = TextEditingController();

  ListTile textFieldTile({Widget leading, Widget trailing, TextInputType keyboardType, String hint, Widget subtitle, TextEditingController controller}) {
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
        isStart ? startTime = picked : endTime = picked;
        print(isStart ? startTime.toString() : endTime.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Academic Term"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              Navigator.of(context).pop(_subjectController != null
                  ? Class(subjectArea: _subjectController.text)
                  : null);
            },
          ),
        ],
      ),

      body: ListView(
        children: <Widget>[
          Padding(padding: EdgeInsets.all(0.0)),

          textFieldTile(
            hint: "Subject",
            controller: _subjectController
          ),

          textFieldTile(
            hint: "Course number",
            controller: _courseNumberController
          ),

          textFieldTile(
            hint: "Course title",
            controller: _courseTitleController
          ),

          textFieldTile(
            hint: "Number of units",
            controller: _unitCountController
          ),

          textFieldTile(
            hint: "Location",
            controller: _locationController
          ),

          textFieldTile(
            hint: "Instructor",
            controller: _instructorController
          ),

          textFieldTile(
            hint: "Office location",
            controller: _officeLocationController
          ),

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
                hintStyle: TextStyle(color: Colors.black45)
              ),
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
                  ? startTime.toString()
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
                  ? endTime.toString()
                  : "",
            ),
            onTap: () => _selectTime(false, context),
          ),
          Divider(),

          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Sun"),
                    Checkbox(
                      value: false,
                      onChanged: (bool e) {},
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("M"),
                    Checkbox(
                      value: false,
                      onChanged: (bool e) {},
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Tu"),
                    Checkbox(
                      value: false,
                      onChanged: (bool e) {},
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("W"),
                    Checkbox(
                      value: false,
                      onChanged: (bool e) {},
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Th"),
                    Checkbox(
                      value: false,
                      onChanged: (bool e) {},
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("F"),
                    Checkbox(
                      value: false,
                      onChanged: (bool e) {},
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Sat"),
                    Checkbox(
                      value: false,
                      onChanged: (bool e) {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



