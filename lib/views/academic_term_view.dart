// Copyright 2019 UniPlan. All rights reserved.

import 'dart:convert';
import 'package:cognito/database/database.dart';
import 'package:flutter/material.dart';
import 'package:cognito/models/academic_term.dart';
import 'package:cognito/views/add_term_view.dart';
import 'package:cognito/views/term_details_view.dart';
import 'package:cognito/views/main_drawer.dart';

/// Academic term view screen
/// Displays AcademicTerm objects in the form of cards
/// [author] Julian Vu

class AcademicTermView extends StatefulWidget {
  static String tag = "academic-term-view";

  @override
  _AcademicTermViewState createState() => _AcademicTermViewState();
}

class _AcademicTermViewState extends State<AcademicTermView> {
  AcademicTerm deletedTerm;

  // List of academic terms
  DataBase database = DataBase();

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  /// Undoes the deletion of an academic term
  void undo(AcademicTerm undo) {
    setState(() {
      database.allTerms.terms.add(undo);
    });
  }

  /// Removes terms from database and re-renders page to show deletion
  void removeTerm(AcademicTerm termToRemove) {
    setState(() {
      database.allTerms.terms.remove(termToRemove);
    });
  }

  /// Shows a bottom modal sheet for creating an academic term
  Future<AcademicTerm> _showModalSheet() async {
    final term = await showModalBottomSheet(
        context: context,
        builder: (builder) {
          return AddTermView();
        });
    return term;
  }

  /// Builds a [Scaffold] page that shows [AcademicTerm] information.
  ///
  /// This information includes the name of the term (e.g. Spring 2019), the
  /// start date and end date for the [AcademicTerm].
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text(
          "Academic Terms",
          style: Theme.of(context).primaryTextTheme.title,
        ),
        backgroundColor: Theme.of(context).primaryColorDark,
      ),

      body: database.allTerms.terms.isNotEmpty
          ? ListView.builder(
              itemCount: database.allTerms.terms.length,
              itemBuilder: (BuildContext context, int index) {
                // Grab academic term from list
                AcademicTerm term = database.allTerms.terms[index];

                // Academic Term Card
                return Container(
                  margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                  child: SizedBox(
                    // Inkwell makes card "tappable"
                    child: InkWell(
                      onTap: () async {
                        // Reference changed to object modified in details
                        // The term should be updated upoen returning from
                        // this navigation
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    TermDetailsView(term: term))).then((term) {
                          if (term != null) {
                            print("Term returned");
                            database.updateDatabase();
                          } else {
                            print("Term was null");
                          }
                        });
                      },

                      // Dismissible allows for swiping to delete
                      child: Dismissible(
                        // Key needs to be unique for card dismissal to work
                        // Use start date's string representation as key
                        key: Key(database.allTerms.terms[index].toString()),
                        direction: DismissDirection.endToStart,
                        onResize: () {
                          print("Swipped");
                        },
                        onDismissed: (direction) {
                          removeTerm(term);
                          deletedTerm = term;
                          String jsonString = json.encode(database.allTerms);
                          database.writeJSON(jsonString);
                          database.update();
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text("${term.termName} deleted"),
                            action: SnackBarAction(
                              label: "Undo",
                              onPressed: () {
                                undo(deletedTerm);
                                database.updateDatabase();
                              },
                            ),
                            duration: Duration(seconds: 7),
                          ));
                        },
                        child: Card(
                          color: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          child: Column(
                            children: <Widget>[
                              // Term name
                              ListTile(
                                leading: Icon(
                                  Icons.label,
                                  color: Colors.white,
                                ),
                                title: Text(
                                  term.termName,
                                  style: TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  term.getStartDateAsString() +
                                      " - " +
                                      term.getEndDateAsString(),
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              })
          : Center(
              child: Text("Lets start by adding a term!"),
            ),

      /// Floating action button is for displaying modal sheet for creating
      /// an [AcademicTerm]
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Retrieve Academic Term object from AddTermView
          final result = await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AddTermView()));
          if (result != null) {
            database.allTerms.terms.add(result);
            String jsonString = json.encode(database.allTerms);
            database.writeJSON(jsonString);
            database.update();
            setState((){});
          }
        },
        child: Icon(
          Icons.add,
          size: 42.0,
        ),
        backgroundColor: Theme.of(context).accentColor,
        foregroundColor: Colors.black,
      ),
    );
  }
}
