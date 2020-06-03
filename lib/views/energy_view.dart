// Copyright 2019 UniPlan. All rights reserved

import 'dart:async';

import 'package:charts_flutter/flutter.dart' hide Slider;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cognito/models/energy.dart';
import 'package:cognito/views/main_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';

/// Personal energy levels view
///
/// This personal energy page shows a graph of the user's energy levels
/// on a given day. The user inputs [EnergyLevel] data points to this view,
/// which is then added to the Firestore. The charts read from the Firestore
/// to render the graphs.
///
/// [author] Julian Vu

class EnergyView extends StatefulWidget {
  @override
  _EnergyViewState createState() => _EnergyViewState();
}

class _EnergyViewState extends State<EnergyView> {
  final db = Firestore.instance;

  /// The list of [EnergyLevel] objects.
  ///
  /// Content should be set with the readDataPoints() method.
  static List<EnergyLevel> energyLevels = [];

  static List<AverageEnergy> averages = [];

  //  This is required because we apparently call setState() too much and
  //  this will stop setState() from being called unless the State object is
  //  mounted. This should stop memory leaks.
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  /// Gets the list of [Series] for building the charts.
  ///
  /// First, [EnergyLevel] data points are read from Firestore, which should
  /// set the content of the [energyLevels] list. This data is used in creating
  /// the [Series].
  List<Series<EnergyLevel, DateTime>> _getSeries(bool forToday) {
    List<Series<EnergyLevel, DateTime>> series = [
      Series<EnergyLevel, DateTime>(
        id: "Energy Levels for Today",
        domainFn: (EnergyLevel energyData, _) => energyData.day,
        measureFn: (EnergyLevel energyData, _) => energyData.level,
        data: forToday
            ? energyLevels.where((energy) {
                return DateTime.now().day == energy.day.day;
              }).toList()
            : energyLevels,
      ),
    ];
    return series;
  }

  List<Series<AverageEnergy, int>> _getAverageSeries() {
    print("Averages: " + averages.toString());
    List<Series<AverageEnergy, int>> series = [
      Series<AverageEnergy, int>(
        id: "Average Energy Levels",
        domainFn: (AverageEnergy avg, _) => avg.hour,
        measureFn: (AverageEnergy avg, _) => avg.averageEnergyLevel,
        data: averages,
      )
    ];
    return series;
  }

  /// Gets the current user's ID from Firebase.
  Future<String> getCurrentUserID() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user.uid;
  }

  /// Reads [EnergyLevel] data points from Firestore
  ///
  /// Retrieves the data from Firestore and creates [EnergyLevel] objects from
  /// data. Every data entry from Firestore maps to an [EnergyLevel] object and
  /// returns a list of [EnergyLevel] objects. Sets content of [energyLevels]
  /// to the list of [EnergyLevels]
  void readDataPoints() async {
    QuerySnapshot querySnapshot = await db
        .collection("energies")
        .where("userID", isEqualTo: await getCurrentUserID())
        .getDocuments();
    setState(() {
      energyLevels = querySnapshot.documents
          .map((document) => EnergyLevel(
              DateTime.parse(document.data["dateTime"]),
              document.data["energyLevel"]))
          .toList();
    });
  }

  void getAverages() async {
    await readDataPoints();
    List<AverageEnergy> averagesToReturn = [];
    for (int i = 0; i < 24; i++) {
      averagesToReturn.add(AverageEnergy(energyLevels, i));
    }
    averages = averagesToReturn;
  }

  /// Adds [EnergyLevel] data point to Firestore
  ///
  /// Creates a new document with a auto-generated document ID and sets its
  /// content to the data of the given [EnergyLevel] object. readDataPoints()
  /// is called because the content of the [energyLevels] list needs to be
  /// updated.
  void addDataPoint(EnergyLevel data) async {
    db.collection("energies").document().setData({
      "userID": await getCurrentUserID(),
      "dateTime": data.day.toString(),
      "energyLevel": data.level
    });

    readDataPoints();
  }

  /// Shows dialog for adding [EnergyLevel] object to Firestore.
  Future<EnergyLevel> _showDialog() async {
    final energyToReturn = await showDialog(
        context: context, builder: (context) => AddEnergyDialog());
    return energyToReturn;
  }

  /// Checks if a data point already exists for the current hour.
  bool pointExistsForCurrentHour() {
    DateTime now = DateTime.now();
    for (int i = 0; i < energyLevels.length; i++) {
      if (energyLevels[i].day.day == now.day &&
          energyLevels[i].day.month == now.month &&
          energyLevels[i].day.year == now.year) {
        if (energyLevels[i].day.hour == now.hour) {
          return true;
        }
      }
    }
    return false;
  }

  @override
  void initState() {
    energyLevels = [];
    averages = [];
    readDataPoints();
    getAverages();
    super.initState();
  }

  /// Static ticks needed to keep chart's viewport (window) at a scale in which
  /// we only see ticks 1 - 10.
  static final staticMeasureTicks = [
    TickSpec(1),
    TickSpec(2),
    TickSpec(3),
    TickSpec(4),
    TickSpec(5),
    TickSpec(6),
    TickSpec(7),
    TickSpec(8),
    TickSpec(9),
    TickSpec(10)
  ];

  @override
  Widget build(BuildContext context) {
    TimeSeriesChart energyLevelChartForToday = TimeSeriesChart(_getSeries(true),
        dateTimeFactory: LocalDateTimeFactory(),
        domainAxis: DateTimeAxisSpec(
            renderSpec: GridlineRendererSpec(labelOffsetFromAxisPx: 10),
            tickFormatterSpec: AutoDateTimeTickFormatterSpec(
                hour: TimeFormatterSpec(format: 'j', transitionFormat: 'j'))),
        primaryMeasureAxis: NumericAxisSpec(
            renderSpec: GridlineRendererSpec(labelOffsetFromAxisPx: 10),
            showAxisLine: true,
            tickProviderSpec:
                StaticNumericTickProviderSpec(staticMeasureTicks)),
        defaultRenderer: LineRendererConfig(
          includePoints: true,
        ),
        animate: false);

    LineChart energyLevelChartAverage = LineChart(
      _getAverageSeries(),
      primaryMeasureAxis: NumericAxisSpec(
          renderSpec: GridlineRendererSpec(labelOffsetFromAxisPx: 10),
          showAxisLine: true,
          tickProviderSpec: StaticNumericTickProviderSpec(staticMeasureTicks)),
      defaultRenderer: LineRendererConfig(includePoints: true),
    );

    return Scaffold(
        appBar: AppBar(
          title: Text("Personal Energy Levels"),
        ),
        drawer: MainDrawer(),
        body: ListView(
          children: <Widget>[
            Card(
              child: Column(
                children: <Widget>[
                  Container(
                      height: 256,
                      child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: energyLevelChartForToday)),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      "Energy Levels for Today",
                      style: Theme.of(context).accentTextTheme.title,
                    ),
                  )
                ],
              ),
            ),
            Card(
              child: Column(
                children: <Widget>[
                  Container(
                      height: 256,
                      child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: energyLevelChartAverage)),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      "Average Energy Levels",
                      style: Theme.of(context).accentTextTheme.title,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: IconThemeData(size: 22),
          closeManually: false,
          curve: Curves.bounceIn,
          overlayColor: Colors.white,
          overlayOpacity: 0.5,
          shape: CircleBorder(),
          children: <SpeedDialChild>[
            SpeedDialChild(
                child: Icon(Icons.add),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                label: "Add Energy Level for Current Hour",
                labelStyle: Theme.of(context).accentTextTheme.body1,
                onTap: () async {
                  if (!pointExistsForCurrentHour()) {
                    EnergyLevel result = await _showDialog();
                    if (result != null) {
                      addDataPoint(result);
                    }
                    setState(() {});
                  } else {}
                })
          ],
        ));
  }
}

class AverageEnergy {
  int hour;
  double averageEnergyLevel;
  AverageEnergy(List<EnergyLevel> energyLevels, this.hour) {
    double sum = 0.0;
    List<EnergyLevel> energyLevelsThisHour =
        energyLevels.where((e) => e.day.hour == this.hour).toList();
    if (energyLevelsThisHour.length == 0) {
      averageEnergyLevel = 0.0;
      return;
    }
    for (EnergyLevel e in energyLevelsThisHour) {
      sum += e.level.toDouble();
    }
    print("Sum: " + sum.toString());
    print("Length of list: " + energyLevelsThisHour.length.toString());
    averageEnergyLevel = sum / energyLevelsThisHour.length;
  }

  @override
  String toString() {
    return hour.toString() + ": " + averageEnergyLevel.toString();
  }
}

class AddEnergyDialog extends StatefulWidget {
  @override
  _AddEnergyDialogState createState() => _AddEnergyDialogState();
}

class _AddEnergyDialogState extends State<AddEnergyDialog> {
  double _energyLevelSelected = 5.0;
  EnergyLevel result;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text("Rate your energy level"),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 42.0, left: 10, right: 10),
          child: SliderTheme(
            data: SliderThemeData.fromPrimaryColors(
                primaryColor: Theme.of(context).primaryColor,
                primaryColorDark: Theme.of(context).primaryColorDark,
                primaryColorLight: Theme.of(context).primaryColorLight,
                valueIndicatorTextStyle:
                    Theme.of(context).primaryTextTheme.bodyText1),
            child: Slider(
              value: _energyLevelSelected,
              max: 10.0,
              min: 1.0,
              divisions: 9,
              label: '${_energyLevelSelected.round()}',
              onChanged: (double value) {
                setState(() {
                  _energyLevelSelected = value;
                });
              },
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FlatButton(
                onPressed: () {
                  setState(() {
                    Navigator.of(context).pop();
                  });
                },
                child: Text("Cancel")),
            FlatButton(
                onPressed: () {
                  setState(() {
                    result = EnergyLevel(
                        DateTime.now(), _energyLevelSelected.toInt());
                    Navigator.of(context).pop(result);
                  });
                },
                child: Text("Confirm"))
          ],
        )
      ],
    );
  }
}

class AddPastEnergyDialogContent extends StatefulWidget {
  @override
  _AddPastEnergyDialogContentState createState() =>
      _AddPastEnergyDialogContentState();
}

class _AddPastEnergyDialogContentState
    extends State<AddPastEnergyDialogContent> {
  DateTime energyLevelDateTime;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.access_time),
          title: energyLevelDateTime == null
              ? null
              : Text(DateFormat.MMMd().add_j().format(energyLevelDateTime)),
          onTap: () async {
            DateTime pickerResult = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now().subtract(Duration(days: 365)),
                lastDate: DateTime.now().add(Duration(days: 365)));
            TimeOfDay timePickerResult = await showTimePicker(
                context: context, initialTime: TimeOfDay.now());
            setState(() {
              energyLevelDateTime = DateTime(pickerResult.year,
                  pickerResult.month, pickerResult.day, timePickerResult.hour);
            });
          },
        )
      ],
    );
  }
}
