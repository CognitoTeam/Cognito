import 'package:cognito/models/academic_term.dart';
import 'package:flutter/material.dart';
import 'package:cognito/views/class_view.dart';
import 'package:cognito/views/academic_term_view.dart';

class MainDrawer extends StatefulWidget {
  AcademicTerm term;

  MainDrawer({Key key, @required this.term});

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(

        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text( "Test", style: Theme.of(context).accentTextTheme.title,),
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
            ),
          ),
          ListTile(
            title: Text('Classes'),
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ClassView(term: widget.term)));
            },
          ),
          ListTile(
            title: Text('Academic Terms'),
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => AcademicTermView()));
            },
          ),
        ],
      ),
    );
  }
}

