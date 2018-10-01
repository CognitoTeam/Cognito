/// Academic term view screen
/// View, create, edit academic terms
/// @author Julian Vu
import 'package:flutter/material.dart';

class AcademicTermView extends StatefulWidget {
  static String tag = "academic-term-view";
  @override
  _AcademicTermViewState createState() => _AcademicTermViewState();
}

class _AcademicTermViewState extends State<AcademicTermView> {
  _addTerm() {
    print("Adding new term...");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Academic Terms", style: Theme.of(context).primaryTextTheme.title,),
          backgroundColor: Theme.of(context).primaryColorDark,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add_circle, color: Theme.of(context).accentColor,),
              onPressed: () {
                print("Pressed plug button.");
              },
            ),
          ],
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print("Pressed floating button.");
            showBottomSheet(context: context, builder: (context) {
              return Scaffold(
                appBar: AppBar(
                  title: Text("Hello from bottom sheet."),
                ),
              );
            });
          },
          child: Icon(Icons.add, size: 42.0,),
          backgroundColor: Theme.of(context).accentColor,
          foregroundColor: Colors.black,
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
