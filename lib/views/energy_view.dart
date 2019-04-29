// Copyright 2019 UniPlan. All rights reserved

import 'package:charts_flutter/flutter.dart';
import 'package:cognito/models/energy.dart';
import 'package:cognito/views/main_drawer.dart';
import 'package:flutter/material.dart';

/// Personal energy levels view
/// [author] Julian Vu

class EnergyView extends StatefulWidget {
  @override
  _EnergyViewState createState() => _EnergyViewState();
}

List<EnergyLevel> data = [
  EnergyLevel(DateTime(2019, 4, 29, 7), 5),
  EnergyLevel(DateTime(2019, 4, 29, 8), 6),
  EnergyLevel(DateTime(2019, 4, 29, 9), 8),
  EnergyLevel(DateTime(2019, 4, 29, 10), 1),
];

List<Series<EnergyLevel, DateTime>> series = [
  Series<EnergyLevel, DateTime>(
    id: "Energy Levels",
    domainFn: (EnergyLevel energyData, _) => energyData.day,
    measureFn: (EnergyLevel energyData, _) => energyData.level,
    data: data,
  ),
];

class _EnergyViewState extends State<EnergyView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Personal Energy Levels"),
      ),
      drawer: MainDrawer(),
      body: ListView(
        children: <Widget>[
          Container(
            height: 256,
            child: Card(
              child: TimeSeriesChart(series,
                  dateTimeFactory: LocalDateTimeFactory(),
                  domainAxis: DateTimeAxisSpec(
                      tickFormatterSpec: AutoDateTimeTickFormatterSpec(
                          hour: TimeFormatterSpec(
                              format: 'j', transitionFormat: 'j'))),
                  defaultRenderer: LineRendererConfig(
                    includePoints: true,
                  ),
                  animate: false),
            ),
          )
        ],
      ),
    );
  }
}
