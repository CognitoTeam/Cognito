/// Agenda view screen
/// Displays daily agenda
/// @author Julian Vu

import 'package:flutter/material.dart';
import 'package:flutter_calendar/flutter_calendar.dart';

class AgendaView extends StatefulWidget {
  DateTime selectedDate = DateTime.now();

  @override
  _AgendaViewState createState() => _AgendaViewState();
}

class _AgendaViewState extends State<AgendaView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Agenda",
          style: Theme.of(context).primaryTextTheme.title,
        ),
      ),
      body: ListView(
        children: <Widget>[
          Calendar(
            onDateSelected: (DateTime date) {
              widget.selectedDate = date;
            },
          ),
          ExpansionTile(

          ),
        ],
      )
    );
  }
}
