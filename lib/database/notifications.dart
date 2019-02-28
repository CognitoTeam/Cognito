import 'package:cognito/views/login_selection_view.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as notifications;
import 'package:flutter/material.dart';

class Notifications {
  static Notifications _instance;
  factory Notifications() => _instance ??= new Notifications._();
  Notifications._();
  notifications.FlutterLocalNotificationsPlugin
      flutterLocalNotificationsPlugin =
      new notifications.FlutterLocalNotificationsPlugin();
BuildContext context;
initialize(BuildContext context){
  var initializationSettingsAndroid =
        new notifications.AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS =
        new notifications.IOSInitializationSettings();
    var initializationSettings = new notifications.InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
}
  Future _scheduleNotification(
      {@required String title,
      @required String body,
      @required DateTime dateTime,
      @required int id}) async {
    var scheduledNotificationDateTime = dateTime;

    var androidPlatformChannelSpecifics =
        new notifications.AndroidNotificationDetails('your other channel id',
            'your other channel name', 'your other channel description',
            sound: 'slow_spring_board', color: Colors.black);

    var iOSPlatformChannelSpecifics =
        new notifications.IOSNotificationDetails();

    var platformChannelSpecifics = new notifications.NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.schedule(id, title, body,
        scheduledNotificationDateTime, platformChannelSpecifics);
    print("Notification created for: " +
        dateTime.hour.toString() +
        ":" +
        dateTime.minute.toString());
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    await Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new LoginSelectionView()),
    );
  }

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
  Future cancelAllNotifications() async{
    print("Notification deleted all called");
    await flutterLocalNotificationsPlugin.cancelAll();
    print("Notification deleted");
  }
  Future _cancelNotification(int id) async {
    print("Notification deleted called");

    await flutterLocalNotificationsPlugin.cancel(id);
    print("Notification deleted");
  }

}
