// Copyright 2019 UniPlan. All rights reserved

import 'dart:async';

import 'package:charts_flutter/flutter.dart' hide Slider;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cognito/models/energy.dart';
import 'package:cognito/views/main_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// Personal energy levels view
/// [author] Julian Vu

class EnergyView extends StatefulWidget {
  @override
  _EnergyViewState createState() => _EnergyViewState();
}

class _EnergyViewState extends State<EnergyView> {
  final db = Firestore.instance;

  static List<EnergyLevel> energyLevels = [];

  List<Series<EnergyLevel, DateTime>> _getSeries() {
    List<Series<EnergyLevel, DateTime>> series = [
      Series<EnergyLevel, DateTime>(
        id: "Energy Levels",
        domainFn: (EnergyLevel energyData, _) => energyData.day,
        measureFn: (EnergyLevel energyData, _) => energyData.level,
        data: energyLevels,
      ),
    ];
    return series;
  }

  Future<String> getCurrentUserID() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user.uid;
  }

  void readDataPoints() async {
//    List<DocumentSnapshot> snapshots = await db
//        .collection("energies")
//        .where("userID", isEqualTo: await getCurrentUserID())
//        .getDocuments()
//        .then((snapshot) {
//      return snapshot.documents;
//    });
//
//    energyLevels = snapshots.map((snapshot) => EnergyLevel(
//        DateTime.parse(snapshot.data["dateTIme"]),
//        snapshot.data["energyLevel"]));
    db
        .collection("energies")
        .where("userID", isEqualTo: await getCurrentUserID())
        .snapshots()
        .listen((data) {
      energyLevels = data.documents
          .map((datum) => EnergyLevel(DateTime.parse(datum.data["dateTime"]),
              datum.data["energyLevel"]))
          .toList();
    });
  }

  void addDataPoint(EnergyLevel data) async {
    db.collection("energies").document().setData({
      "userID": await getCurrentUserID(),
      "dateTime": data.day.toString(),
      "energyLevel": data.level
    });

    readDataPoints();
  }

  Future<EnergyLevel> _showDialog() async {
    final energyToReturn = await showDialog(
        context: context, builder: (context) => AddEnergyDialog());
    return energyToReturn;
  }

  @override
  void initState() {
    super.initState();
    readDataPoints();
  }

  @override
  Widget build(BuildContext context) {
    final staticTicks = [
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

    return Scaffold(
      appBar: AppBar(
        title: Text("Personal Energy Levels"),
      ),
      drawer: MainDrawer(),
      body: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10, left: 10, right: 10),
            height: 256,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: TimeSeriesChart(_getSeries(),
                    dateTimeFactory: LocalDateTimeFactory(),
                    domainAxis: DateTimeAxisSpec(
                        renderSpec:
                            GridlineRendererSpec(labelOffsetFromAxisPx: 10),
                        tickFormatterSpec: AutoDateTimeTickFormatterSpec(
                            hour: TimeFormatterSpec(
                                format: 'j', transitionFormat: 'j'))),
                    primaryMeasureAxis: NumericAxisSpec(
                        renderSpec:
                            GridlineRendererSpec(labelOffsetFromAxisPx: 10),
                        showAxisLine: true,
                        tickProviderSpec:
                            StaticNumericTickProviderSpec(staticTicks)),
                    defaultRenderer: LineRendererConfig(
                      includePoints: true,
                    ),
                    animate: false),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () async {
        EnergyLevel result = await _showDialog();
        if (result != null) {
          addDataPoint(result);
        }
        Future.delayed(Duration(seconds: 2));
        setState(() {});
      }),
    );
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
                    Theme.of(context).primaryTextTheme.body1),
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
