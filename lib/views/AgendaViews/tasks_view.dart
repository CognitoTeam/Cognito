import 'package:cognito/views/components/task_agenda_item.dart';
import 'package:flutter/material.dart';

import '../main_drawer.dart';

class TasksView extends StatefulWidget {
  @override
  _TasksViewState createState() => _TasksViewState();
}

class _TasksViewState extends State<TasksView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        centerTitle: true,
        title: Text(
          "Tasks",
          style: TextStyle(
              color: Colors.black,
              fontSize: 20.0
          ),),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),)
        ),
      ),
      body: TasksViewBody(),
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }

  Widget TasksViewBody()
  {
    return ListView(
      padding: const EdgeInsets.all(15),
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(10),
        ),
        SliderWidget(),
        Padding(
          padding: EdgeInsets.all(10),
        ),
        SliderWidget(),
        Padding(
          padding: EdgeInsets.all(10),
        ),
        SliderWidget(),
        Padding(
          padding: EdgeInsets.all(10),
        ),
      ],
    );
  }
}
