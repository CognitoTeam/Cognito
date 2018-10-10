/// Models an event on a schedule
/// @author Julian Vu
import 'package:flutter/material.dart';

class Event {
  /// Instance variables
  String title, description, location;
  TimeOfDay startTime, endTime;
  bool isRepeated;

  // Elements in list represent day(s) on which this event occurs
  // 1 => Monday, 2 => Tuesday ... 7 => Sunday
  List<int> _daysOfEvent;

  /// Default constructor that creates an Event from all information
  Event({String title, String description = "", String location = "", TimeOfDay start, TimeOfDay end, bool isRepeated}) {
    this.title = title;
    this.description = description;
    this.location = location;
    this.startTime = start;
    this.endTime = end;
    this.isRepeated = isRepeated;
    this._daysOfEvent = List();
  }

  List<int> get daysOfEvent => _daysOfEvent;

  void addDayOfEvent(int dayOfWeek) {
    if (dayOfWeek < 1 || dayOfWeek > 7) {
      print("Day of Week must be integer from 1 to 7"); 
    }
    else if (_daysOfEvent.contains(dayOfWeek)) {
      print("List already contains that day");
    }
    else {
      _daysOfEvent.add(dayOfWeek);
    }
  }

}