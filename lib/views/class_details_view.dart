/// Class details view
/// View screen to edit/delete a Class object
/// @author Julian Vu
///
import 'package:flutter/material.dart';
import 'package:cognito/models/class.dart';
import 'package:cognito/views/add_class_view.dart';

class ClassDetailsView extends StatefulWidget {
  // Underlying class object
  final Class classObj;

  ClassDetailsView({Key key, @required this.classObj}) : super(key: key);

  @override
  _ClassDetailsViewState createState() => _ClassDetailsViewState();
}

class _ClassDetailsViewState extends State<ClassDetailsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: BackButtonIcon(),
          onPressed: () {
            print("Returning a class");
            Navigator.of(context).pop(widget.classObj);
          },
        ),

        title: Text(
          widget.classObj.title,
          style: Theme.of(context).primaryTextTheme.title,
        ),

        backgroundColor: Theme.of(context).primaryColorDark,
      ),
    );
  }
}
