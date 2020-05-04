import 'package:flutter/material.dart';

import '../main_drawer.dart';

class PriorityAgendaView extends StatefulWidget {
  @override
  _PriorityAgendaViewState createState() => _PriorityAgendaViewState();
}

class _PriorityAgendaViewState extends State<PriorityAgendaView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        centerTitle: true,
        title: Text(
          "Priority Agenda",
          style: TextStyle(
              color: Colors.black,
              fontSize: 20.0
          ),),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),)
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }
}
