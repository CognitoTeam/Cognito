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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text(
            "You have 0 tasks left for today",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
        ,
        ListView(
          children: tasks(),
        )
      ],
    );
  }

  List<Widget> tasks()
  {
    
  }

}
