import 'package:cognito/database/database.dart';
import 'package:cognito/views/academic_term_view.dart';
import 'package:flutter/material.dart';

class BufferView extends StatefulWidget {
  @override
  _BufferViewState createState() => _BufferViewState();
}

class _BufferViewState extends State<BufferView> {
  DataBase database = DataBase();

  Future<bool> _initializeDatabase() async {
    String p = await database.initializeFireStore();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => AcademicTermView()),
        ModalRoute.withName("/Home"));
  }

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(
          "Loading your hard work...",
          style: TextStyle(color: Theme.of(context).accentColor),
        )
      ],
    )));
  }
}
