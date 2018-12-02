import 'package:cognito/database/database.dart';
import 'package:cognito/views/gradebook_view.dart';
import 'package:flutter/material.dart';
import 'package:cognito/models/class.dart';
import 'package:cognito/models/academic_term.dart';
import 'package:cognito/views/main_drawer.dart';
import 'package:cognito/views/add_class_view.dart';
import 'package:cognito/views/class_details_view.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as notifications;

/// Class view
/// Displays list of Class cards
/// @author Julian Vu

class ClassView extends StatefulWidget {
  @override
  _ClassViewState createState() => _ClassViewState();
}

class _ClassViewState extends State<ClassView> {
  notifications.FlutterLocalNotificationsPlugin
      flutterLocalNotificationsPlugin =
      new notifications.FlutterLocalNotificationsPlugin();
  AcademicTerm term;
  Class undoClass;
  DataBase database = DataBase();
  void removeClass(Class classToRemove) {
    setState(() {
      term.removeClass(classToRemove);
    });
  }

  AcademicTerm getCurrentTerm() {
    for (AcademicTerm term in database.allTerms.terms) {
      if (DateTime.now().isAfter(term.startTime) &&
          DateTime.now().isBefore(term.endTime)) {
        this.term = term;
        return term;
      }
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      getCurrentTerm();
      var initializationSettingsAndroid =
          new notifications.AndroidInitializationSettings('app_icon');
      var initializationSettingsIOS =
          new notifications.IOSInitializationSettings();
      var initializationSettings = new notifications.InitializationSettings(
          initializationSettingsAndroid, initializationSettingsIOS);
      flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onSelectNotification: onSelectNotification);
    });
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  }

//id = class.hashcode+index
  Future _showWeeklyAtDayAndTime(
      {@required int dayToRepeat,
      @required DateTime timeToRepeat,
      @required String title,
      @required String body,
      @required int id}) async {
    notifications.Time time = notifications.Time(
        timeToRepeat.hour, timeToRepeat.minute, timeToRepeat.second);
    notifications.Day day =
        notifications.Day(dayToRepeat + 1 == 8 ? 0 : dayToRepeat + 1);
    var androidPlatformChannelSpecifics =
        new notifications.AndroidNotificationDetails('show weekly channel id',
            'show weekly channel name', 'show weekly description');
    var iOSPlatformChannelSpecifics =
        new notifications.IOSNotificationDetails();
    var platformChannelSpecifics = new notifications.NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
        id, title, body, day, time, platformChannelSpecifics);
    print("Notification created for: " +
        time.hour.toString() +
        ":" +
        time.minute.toString() +
        " Day:" +
        day.value.toString());
  }

  Future _cancelNotification(int id) async {
    print("Notification deleted called");

    await flutterLocalNotificationsPlugin.cancel(id);
    print("Notification deleted");
  }

  void undo(Class undo) {
    setState(() {
      term.addClass(undo);
    });
  }

  String calculateGrade(Class c) {
    return "Grade: " + c.getGrade();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text(
          term.termName + " - Classes",
          style: Theme.of(context).primaryTextTheme.title,
        ),
        backgroundColor: Theme.of(context).primaryColorDark,
        actions: <Widget>[
          IconButton(
            tooltip: "Grades",
            icon: Icon(
              Icons.poll,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => GradeBookView()));
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Class result = await Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddClassView()));
          if (result != null) {
            term.addClass(result);
            database.allTerms.updateTerm(term);
            database.updateDatabase();
            for (int i in result.daysOfEvent) {
              _showWeeklyAtDayAndTime(
                  title: result.title,
                  body: result.title + " is starting in 15 mins",
                  id: term.classes.indexOf(result) + i,
                  dayToRepeat: i,
                  timeToRepeat:
                      result.startTime.subtract(Duration(minutes: 15)));
            }
          }
        },
        child: Icon(
          Icons.add,
          size: 42.0,
        ),
        backgroundColor: Theme.of(context).accentColor,
        foregroundColor: Colors.black,
      ),
      body: term.classes.isNotEmpty
          ? ListView.builder(
              itemCount: term.classes.length,
              itemBuilder: (BuildContext context, int index) {
                Class classObj = term.classes[index];

                return Container(
                  margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                  child: InkWell(
                    onTap: () async {
                      for (int i in classObj.daysOfEvent) {
                          _cancelNotification(
                              term.classes.indexOf(classObj) + i);
                        }
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ClassDetailsView(classObj: classObj)));
                      database.allTerms.updateTerm(term);
                      database.updateDatabase();

                      for (int i in classObj.daysOfEvent) {
                        _showWeeklyAtDayAndTime(
                            title: classObj.title,
                            body: classObj.title + " is starting in 15 mins",
                            id: term.classes.indexOf(classObj) + i,
                            dayToRepeat: i,
                            timeToRepeat: classObj.startTime
                                .subtract(Duration(minutes: 15)));
                      }
                    },
                    child: Dismissible(
                      key: Key(term.classes[index].toString()),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        for (int i in classObj.daysOfEvent) {
                          _cancelNotification(
                              term.classes.indexOf(classObj) + i);
                        }

                        undoClass = classObj;
                        removeClass(classObj);
                        database.allTerms.updateTerm(term);
                        database.updateDatabase();
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("${classObj.title} deleted"),
                          action: SnackBarAction(
                            label: "Undo",
                            onPressed: () {
                              undo(undoClass);
                              database.updateDatabase();
                            },
                          ),
                          duration: Duration(seconds: 7),
                        ));
                      },
                      child: Card(
                        color: Theme.of(context).primaryColor,
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              leading: Icon(
                                Icons.label,
                                color: Colors.white,
                              ),
                              subtitle: Text(
                                calculateGrade(classObj),
                                style: Theme.of(context).primaryTextTheme.body1,
                              ),
                              title: Text(
                                classObj.subjectArea +
                                    " " +
                                    classObj.courseNumber +
                                    " - " +
                                    classObj.title,
                                style: Theme.of(context).primaryTextTheme.body1,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
          : null,
    );
  }
}
