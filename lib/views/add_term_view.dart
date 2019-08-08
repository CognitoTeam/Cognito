// Copyright 2019 UniPlan and individual contributors. All rights reserved.

import 'package:cognito/database/database.dart';
import 'package:cognito/models/all_terms.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cognito/models/academic_term.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


/// Academic term creation view
/// View screen to create a new AcademicTerm
/// [author] Julian Vu
///
class AddTermView extends StatefulWidget {
  @override
  _AddTermViewState createState() => _AddTermViewState();
}

class _AddTermViewState extends State<AddTermView> {
  DataBase database = DataBase();
  //Fire store instance
  final firestore = Firestore.instance;

  //To check time conflict
  AllTerms allTerms = new AllTerms();

  @override
  void initState() {
    super.initState();
    setState(() {

    });
  }

  DateTime newStartDate, newEndDate;
  String newTermName;

  final _termNameController = TextEditingController();

  Future<Null> _selectDate(bool isStart, BuildContext context) async {
    // Hide keyboard before showing date picker
    FocusScope.of(context).requestFocus(FocusNode());

    // Add delay to be sure keyboard is no longer visible
    await Future.delayed(Duration(milliseconds: 200));

    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: isStart
            ? newStartDate != null
                ? DateTime(
                    newStartDate.year, newStartDate.month, newStartDate.day)
                : DateTime.now()
            : newEndDate != null
                ? DateTime(newEndDate.year, newEndDate.month, newEndDate.day)
                : DateTime.now(),
        firstDate: DateTime(1990),
        lastDate: DateTime(3000));

    if (picked != null) {
      print("Date selected: ${picked.toString()}");
      setState(() {
        isStart ? newStartDate = picked : newEndDate = picked;
        //print(isStart ? newStartDate.toString() : newEndDate.toString());
      });
    }
  }

  String conflictTerm = "";
  bool timeConflict(DateTime startTime, DateTime endTime) {
    bool cond = false;
    for (AcademicTerm t in allTerms.getTerms()) {
      if ((startTime.isAfter(t.startTime) && startTime.isBefore(t.endTime)) ||
          (endTime.isAfter(t.startTime) && endTime.isBefore(t.endTime)) ||
          (startTime.compareTo(t.startTime) == 0) &&
              endTime.compareTo(t.endTime) == 0) {
        conflictTerm = t.termName;
        cond = true;
      }
    }
    return cond;
  }

  @override
  Widget build(BuildContext context) {
    updateAllTerms();
    print("**************" + allTerms.getTerms().length.toString() + "************");
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Academic Term"),
        backgroundColor: Theme.of(context).primaryColorDark,
        actions: <Widget>[
          Builder(builder: (BuildContext context) {
            return IconButton(
                icon: Icon(Icons.check),
                onPressed: () {
                  if (!timeConflict(newStartDate, newEndDate)) {
                    Navigator.of(context).pop(_termNameController != null
                    //Add the term to fire store
                        ? addAcademicTerm()
                        : null);
                  } else {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text("There is a time conflict with term: " +
                          conflictTerm),
                      duration: Duration(seconds: 7),
                    ));
                  }
                });
          }),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Padding(padding: EdgeInsets.all(0.0)),
          ListTile(
            leading: Icon(Icons.label),
            title: TextFormField(
              controller: _termNameController,
              autofocus: false,
              style: Theme.of(context).accentTextTheme.body1,
              decoration: InputDecoration(
                hintText: "Term title (e.g. \"Spring 2019\")",
                hintStyle: TextStyle(color: Colors.black45),
              ),
              onFieldSubmitted: (newTermName) {
                setState(() {
                  newTermName = _termNameController.text;
                });
              },
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text(
              "Select Start Date",
              style: Theme.of(context).accentTextTheme.body2,
            ),
            trailing: Text(
              newStartDate != null
                  ? "${newStartDate.month.toString()}/${newStartDate.day.toString()}/${newStartDate.year.toString()}"
                  : "",
            ),
            onTap: () => _selectDate(true, context),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text(
              "Select End Date",
              style: Theme.of(context).accentTextTheme.body2,
            ),
            trailing: Text(
              newEndDate != null
                  ? "${newEndDate.month.toString()}/${newEndDate.day.toString()}/${newEndDate.year.toString()}"
                  : "",
            ),
            onTap: () => _selectDate(false, context),
          ),
          Divider()
        ],
      ),
    );
  }

  Future updateAllTerms()
  async {
    String getUserID = await getCurrentUserID();
    firestore.collection("terms")
        .where("user_id", isEqualTo: getUserID)
        .snapshots().listen((data) =>
        data.documents.forEach((doc) => allTerms.addTerm(
            new AcademicTerm(doc['user_id'], doc['start_date'].toDate(), doc['end_date'].toDate()))
        )
    );
  }

  /// Gets the current user's ID from Firebase.
  Future<String> getCurrentUserID() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user.uid;
  }

  void getFireStoreTerms() async {
    allTerms.terms.clear();
    firestore.collection("terms")
        .where("user_id", isEqualTo: getCurrentUserID())
        .snapshots().listen((data)=>
        data.documents.forEach((doc) => allTerms.addTerm(
            new AcademicTerm(doc['user_id'], doc['start_date'], doc['end_date'])))
    );
  }

  Future<AcademicTerm> addAcademicTerm() async
  {
    AcademicTerm term = new AcademicTerm(_termNameController.text, newStartDate, newEndDate);
    DocumentReference newTermReference = firestore.collection("terms").document();

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    newTermReference.setData({
    "user_id" : user.uid,
    "term_name" : term.termName,
    "start_date" : term.startTime,
    "end_date" : term.endTime,
    });

    newTermReference.collection("classes_collection").document();
    newTermReference.collection("assignments_collection").document();
    newTermReference.collection("events_collection").document();
    return term;
  }
}
