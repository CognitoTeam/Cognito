// Copyright 2019 UniPlan. All rights reserved

import 'package:cognito/models/academic_term.dart';
import 'package:cognito/models/class.dart';
import 'package:cognito/views/gradebook_view.dart';
import 'package:flutter/material.dart';

/// Class details view
/// [author] Julian Vu
enum Day { M, Tu, W, Th, F, Sat, Sun }

class ClassDetailsView extends StatefulWidget {
  // Underlying class object
  final Class classObj;
  final AcademicTerm term;

  // Ctor
  ClassDetailsView({Key key, @required this.classObj, @required this.term}) : super(key: key);

  @override
  _ClassDetailsViewState createState() => _ClassDetailsViewState(classObj);
}

class _ClassDetailsViewState extends State<ClassDetailsView> {
  Class _classObjToReturn;

  _ClassDetailsViewState(this._classObjToReturn);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        title: Text("Grades for " +
            _classObjToReturn.subjectArea +
            _classObjToReturn.courseNumber),
        leading: IconButton(
          icon: BackButtonIcon(),
          onPressed: () {
            Navigator.of(context).pop(_classObjToReturn);
          },
        ),
      ),
      body: ListView(
        children: <Widget>[GradeBookView(selectedClass: _classObjToReturn, term: widget.term,)],
      ),
    );
  }
}
