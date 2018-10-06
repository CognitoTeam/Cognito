/// Academic term creation view
/// View screen to create a new AcademicTerm
/// @author Julian Vu
///
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cognito/models/academic_term.dart';

class AddTermView extends StatefulWidget {
  static String tag = "add-term-view";

  @override
  _AddTermViewState createState() => _AddTermViewState();
}

class _AddTermViewState extends State<AddTermView> {
  DateTime newStartDate, newEndDate;
  String newTermName;

  final _termNameController = TextEditingController();

  Future<Null> _selectDate(bool isStart, BuildContext context) async {
    // Hide keyboard before showing date picker
    FocusScope.of(context).requestFocus(FocusNode());

    // Add delay to be sure keyboard is no longer visible
    await Future.delayed(Duration(milliseconds: 200));

    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1990),
        lastDate: DateTime(3000));

    if (picked != null) {
      print("Date selected: ${picked.toString()}");
      setState(() {
        isStart ? newStartDate = picked : newEndDate = picked;
        print(isStart ? newStartDate.toString() : newEndDate.toString());
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
              Navigator.of(context).pop(_termNameController != null
                  ? AcademicTerm(
                      _termNameController.text, newStartDate, newEndDate)
                  : null);
            },
          ),
        ],
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(padding: EdgeInsets.all(0.0)),
          ListTile(
            leading: Icon(Icons.label),
            title: TextFormField(
              controller: _termNameController,
              autofocus: false,
              style: Theme.of(context).accentTextTheme.body1,
              decoration: InputDecoration(
                hintText: "Term title (e.g. \"Spring 2019\")",
                hintStyle: TextStyle(color: Colors.black45),
              ),
              onFieldSubmitted: (newTermName) {
                setState(() {
                  newTermName = _termNameController.text;
                });
              },
            ),
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text(
            "Select Start Date",
            style: Theme.of(context).accentTextTheme.body2,
            ),
            trailing: Text(
            newStartDate != null
            ? "${newStartDate.month.toString()}/${newStartDate.day.toString()}/${newStartDate.year.toString()}"
                : "",
            ),
            onTap: () => _selectDate(true, context),
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text(
              "Select End Date",
              style: Theme.of(context).accentTextTheme.body2,
            ),
            trailing: Text(
              newEndDate != null
                  ? "${newEndDate.month.toString()}/${newEndDate.day.toString()}/${newEndDate.year.toString()}"
                  : "",
            ),
            onTap: () => _selectDate(false, context),
          ),
          Divider()
        ],
      ),
    );
  }
}

