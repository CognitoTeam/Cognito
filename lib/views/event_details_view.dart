/// Event Details view
/// @author Praneet Singh

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cognito/models/event.dart';

enum Day { M, Tu, W, Th, F, Sat, Sun }

class EventDetailsView extends StatefulWidget {
  Event event;
  EventDetailsView({Key key, @required this.event}) : super(key: key);
  @override
  _EventDetailsViewState createState() => _EventDetailsViewState();
}

class _EventDetailsViewState extends State<EventDetailsView> {
  TextEditingController _locationController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
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
  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: widget.event.description);
    _locationController = TextEditingController(text: widget.event.location);
    setState(() {
          daysOfEvent = widget.event.daysOfEvent;
        });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: BackButtonIcon(),
          onPressed: () {
            print("Returning a task");
            widget.event.location = _locationController.text;
            widget.event.description = _descriptionController.text;
            Navigator.of(context).pop(widget.event);
          },
        ),
        title: Text(widget.event.title),
        backgroundColor: Theme.of(context).primaryColorDark,
        actions: <Widget>[
          // Edit term title
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.white,
            ),
            onPressed: () async {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SimpleDialog(
                      title: Text("Change Event Title"),
                      children: <Widget>[
                        TextFormField(
                          initialValue: widget.event.title,
                          style: Theme.of(context).accentTextTheme.body2,
                          decoration: InputDecoration(
                            hintText: "Event Title",
                            hintStyle: TextStyle(color: Colors.black45),
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          ),
                          onFieldSubmitted: (val) {
                            print(val);
                            setState(() {
                              widget.event.title = val;
                            });
                            Navigator.pop(context);
                          },
                          textInputAction: TextInputAction.done,
                        )
                      ],
                    );
                  });
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Padding(padding: EdgeInsets.all(0.0)),
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
