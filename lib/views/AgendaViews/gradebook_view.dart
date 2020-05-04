import 'package:flutter/material.dart';

import '../main_drawer.dart';

class GradebookView extends StatefulWidget {
  @override
  _GradebookViewState createState() => _GradebookViewState();
}

class _GradebookViewState extends State<GradebookView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        centerTitle: true,
        title: Text(
          "Gradebook",
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
