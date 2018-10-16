import 'dart:convert';
import 'package:cognito/models/all_terms.dart';
import 'package:cognito/views/database.dart';
import 'package:cognito/views/firebase_login.dart';
import 'package:cognito/views/login_selection_view.dart';
import 'package:cognito/views/term_storage.dart';

/// Academic term view screen
/// Displays AcademicTerm objects in the form of cards
/// @author Julian Vu
import 'package:flutter/material.dart';
import 'package:cognito/models/academic_term.dart';
import 'package:cognito/views/add_term_view.dart';
import 'package:cognito/views/term_details_view.dart';

class AcademicTermView extends StatefulWidget {
  final TermStorage storage = TermStorage();
  static String tag = "academic-term-view";
  @override
  _AcademicTermViewState createState() => _AcademicTermViewState();
}

class _AcademicTermViewState extends State<AcademicTermView> {
  final FireBaseLogin _fireBaseLogin = FireBaseLogin();
  AllTerms _allTerms = AllTerms();
  // List of academic terms
  DataBase dataBase = DataBase();

  Future<bool> startFireStore() async {
    String jsonString = await dataBase.initializeFireStore();
    setState(() {
      print("Read from the disk and populate UI");
      final jsonTerms = json.decode(jsonString);
      AllTerms allTerms = AllTerms.fromJson(jsonTerms);
      _allTerms.terms = allTerms.terms;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      startFireStore();
    });
  }

  Future<bool> _signOutUser() async {
    final api = await _fireBaseLogin.signOutUser();
    if (api != null) {
      return false;
    } else {
      return true;
    }
  }

  // Remove terms of list
  void removeTerm(AcademicTerm termToRemove) {
    setState(() {
      _allTerms.terms.remove(termToRemove);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Academic Terms",
          style: Theme.of(context).primaryTextTheme.title,
        ),
        backgroundColor: Theme.of(context).primaryColorDark,
        actions: <Widget>[
          FlatButton(
            child: Text(
              "Sign out",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () async {
              bool b = await _signOutUser();

              b
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginSelectionView()))
                  : print("Error SignOut!");
            },
          ),
        ],
      ),

      body: _allTerms.terms.isNotEmpty
          ? ListView.builder(
              itemCount: _allTerms.terms.length,
              itemBuilder: (BuildContext context, int index) {
                // Grab academic term from list
                AcademicTerm term = _allTerms.terms[index];

                // Academic Term Card
                return Container(
                  margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                  child: SizedBox(
                    height: 256.0,

                    // Inkwell makes card "tappable"
                    child: InkWell(
                      onTap: () async {
                        // Reference changed to object modified in details
                        // The term should be updated upoen returning from
                        // this navigation
                        term = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TermDetailsView(term: term)
                            )
                        );
                      },

                      // Dismissible allows for swiping to delete
                      child: Dismissible(
                        // Key needs to be unique for card dismissal to work
                        // Use start date's string representation as key
                        key: Key(_allTerms.terms[index].toString()),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          removeTerm(term);
                          String jsonString = json.encode(_allTerms);
                          widget.storage.writeJSON(jsonString);
                          dataBase.update();
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text("${term.termName} deleted"),
                          ));
                        },
                        child: Card(
                          child: Column(
                            children: <Widget>[
                              // Term name
                              ListTile(
                                leading: Icon(Icons.label),
                                title: Text(term.termName),
                              ),
                              Divider(),

                              // Start date
                              ListTile(
                                leading: Icon(Icons.calendar_today),
                                title: Text(term.getStartDateAsString()),
                                subtitle: Text("Start Date"),
                              ),
                              Divider(),

                              // End date
                              ListTile(
                                leading: Icon(Icons.calendar_today),
                                title: Text(term.getEndDateAsString()),
                                subtitle: Text("End Date"),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              })
          : null,

      // Floating action button is for transitioning to creating a new term
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Retrieve Academic Term object from AddTermView
          final result = await Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddTermView()));
          if (result != null) {
            _allTerms.terms.add(result);
            String jsonString = json.encode(_allTerms);
            widget.storage.writeJSON(jsonString);
            dataBase.update();
          }
        },
        child: Icon(
          Icons.add,
          size: 42.0,
        ),
        backgroundColor: Theme.of(context).accentColor,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
