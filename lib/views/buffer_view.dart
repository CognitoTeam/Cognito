import 'package:cognito/database/database.dart';
import 'package:cognito/models/academic_term.dart';
import 'package:cognito/models/class.dart';
import 'package:cognito/models/event.dart';
import 'package:cognito/models/task.dart';
import 'package:cognito/views/academic_term_view.dart';
import 'package:cognito/views/agenda_view.dart';
import 'package:flutter/material.dart';
import 'package:cognito/database/notifications.dart';

class BufferView extends StatefulWidget {
  @override
  _BufferViewState createState() => _BufferViewState();
}

class _BufferViewState extends State<BufferView> {
  DataBase database = DataBase();
  Notifications noti = Notifications();

/**
 * Initialize the database and if no data is stored 
 * then go to Academic term view else go to Agenda view
 */
  Future<bool> _initializeDatabase() async {
    String p = await database.initializeFireStore();
    if (p == '[]' ||
        p == '{}' ||
        p == null ||
        p == '{"terms":[],"subjects":[]}' ||
        database.getCurrentTerm() == null) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => AcademicTermView()),
          ModalRoute.withName("/Home"));
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => AgendaView()),
          ModalRoute.withName("/Home"));
    }
    // Initialize notifications after database is initialized
    _initializeNotifications();
  }
/**
 * Initialize the notifications and create 
 * all notifications for current term.
 */
  Future<bool> _initializeNotifications() async {
    noti.initialize(context);
    noti.cancelAllNotifications();
    AcademicTerm term = await database.getCurrentTerm();
    if (term != null) {
      for (Class c in term.classes) {
        for (int day in c.getDaysOfEvent) {
          noti.showWeeklyAtDayAndTime(
              title: c.title,
              body: c.title + " is starting in 15 mins",
              id: c.id,
              dayToRepeat: day,
              timeToRepeat: c.startTime.subtract(Duration(minutes: 15)));
        }
      }
      for (Task task in term.tasks) {
        noti.scheduleNotification(
            title: task.title,
            body: task.title + " is starting in 15 mins",
            id: task.id,
            dateTime: task.dueDate.subtract(Duration(minutes: 15)));
      }

      for (Event e in term.events) {
        if (e.daysOfEvent.isNotEmpty) {
          for (int day in e.daysOfEvent) {
            noti.showWeeklyAtDayAndTime(
                title: e.title,
                body: e.title + " is starting in 15 mins",
                id: e.id,
                dayToRepeat: day,
                timeToRepeat: e.startTime.subtract(Duration(minutes: 15)));
          }
        } else {
          noti.scheduleNotification(
              title: e.title,
              body: e.title + " is starting in 15 mins",
              id: e.id,
              dateTime: e.startTime.subtract(Duration(minutes: 15)));
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Padding(padding: EdgeInsets.all(5.0)),
        Text(
          "Loading your hard work...",
          style: TextStyle(color: Theme.of(context).primaryColor),
        )
      ],
    )));
  }
}
