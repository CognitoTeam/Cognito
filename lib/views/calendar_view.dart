// Copyright 2019 UniPlan. All rights reserved.
import 'package:date_utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Calendar view widget screen
/// Displays a date picker for the calendar view
/// @author Praneet Singh

class CalendarView extends StatefulWidget {
  final ValueChanged<DateTime> onDateSelected;
  CalendarView({this.onDateSelected});

  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  // List of day names
  List dayNames = ['Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat', 'Sun'];
  // Currently selected date
  DateTime selectedDate = DateTime.now();
  // Iterable for the next 7 days
  Iterable<DateTime> selectedWeeksDays;
  // Controller for scrolling horizontal list view
  ScrollController _scrollController;

  void initState() {
    super.initState();
    // Initialize the controller to the first day
    _scrollController = new ScrollController(initialScrollOffset: 90);
    updateWeekList();
  }

// get the next 7 days of week and update the list
  void updateWeekList() {
    setState(() {
      selectedWeeksDays =
          Utils.daysInRange(selectedDate, selectedDate.add(Duration(days: 7)))
              .toList()
              .sublist(0, 7);
    });
  }

// Create a list of buttons for the current 7 days
  List<Widget> weeklyRow() {
    // List to return
    List<Widget> calendar = List();
    // Previous week button
    calendar.add(FlatButton(
      onPressed: () {
        setState(() {
          selectedDate = selectedDate.subtract(Duration(days: 7));
          widget.onDateSelected(selectedDate);
          updateWeekList();
          _scrollController.animateTo(90,
              duration: Duration(seconds: 1), curve: Curves.ease);
        });
      },
      child: Text("Previous\nWeek",
          style: Theme.of(context).primaryTextTheme.bodyText2),
    ));
    // Seven buttons for the selected days
    for (DateTime d in selectedWeeksDays) {
      bool selected = d.day == selectedDate.day &&
          d.month == selectedDate.month &&
          d.year == selectedDate.year;
      Container c = Container(
        child: SizedBox(
          child: FlatButton(
            color: selected ? Color(0xFFFFE6A4) : null,
            onPressed: () {
              setState(() {
                // set the state and call onDateSelected
                selectedDate = d;
                widget.onDateSelected(selectedDate);
              });
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                    dayNames[DateTime(selectedDate.year, selectedDate.month, d.day).weekday - 1],
                    style: GoogleFonts.poppins(
                        color: selected ? Color(0xFFFF793F) : Colors.black,
                        fontSize: 15
                    )
                ),
                Text(
                  d.day.toString(),
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: selected ? Color(0xFFFF793F) : Colors.black,
                      fontSize: 15
                  ),
                )
              ],
            ),
          ),
        )
      );
      calendar.add(c);
    }
    // Next week button
    calendar.add(FlatButton(
      onPressed: () {
        setState(() {
          selectedDate = selectedDate.add(Duration(days: 7));
          widget.onDateSelected(selectedDate);
          updateWeekList();
          _scrollController.animateTo(90,
              duration: Duration(seconds: 1), curve: Curves.ease);
        });
      },
      child: Text("Next\nWeek",
          style: Theme.of(context).primaryTextTheme.bodyText2)),
    );
    return calendar;
  }

// Date picker
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate != null
            ? DateTime(selectedDate.year, selectedDate.month, selectedDate.day)
            : DateTime.now(),
        firstDate: DateTime(1990),
        lastDate: DateTime(3000));

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        updateWeekList();
        widget.onDateSelected(selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Theme.of(context).primaryColorDark,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 60.0,
                  child: ListView(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    children: weeklyRow(),
                  ),
                ),
              ),
            ],
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  iconSize: 20,
                  icon: Icon(Icons.calendar_today),
                  color: Colors.black,
                  onPressed: () {
                    _selectDate(context);
                  },
                ),
                FlatButton(
                  child: Text(
                    "Today",
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                  onPressed: () {
                    setState(() {
                      // set the state and call onDateSelected
                      selectedDate = DateTime.now();
                      _scrollController.animateTo(90,
                          duration: Duration(seconds: 1), curve: Curves.ease);
                      widget.onDateSelected(selectedDate);
                      updateWeekList();
                    });
                  },
                )
              ]),
        ],
      ),
    );
  }
}
