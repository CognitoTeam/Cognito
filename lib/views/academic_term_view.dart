import 'dart:convert';
import 'package:cognito/models/all_terms.dart';
import 'package:cognito/database/database.dart';
import 'package:cognito/database/firebase_login.dart';
import 'package:cognito/views/login_selection_view.dart';

/// Academic term view screen
/// Displays AcademicTerm objects in the form of cards
/// @author Julian Vu
import 'package:flutter/material.dart';
import 'package:cognito/models/academic_term.dart';
import 'package:cognito/views/add_term_view.dart';
import 'package:cognito/views/term_details_view.dart';
import 'package:cognito/views/main_drawer.dart';

class AcademicTermView extends StatefulWidget {
  static String tag = "academic-term-view";
  @override
  _AcademicTermViewState createState() => _AcademicTermViewState();
}

class _AcademicTermViewState extends State<AcademicTermView> {
  final FireBaseLogin _fireBaseLogin = FireBaseLogin();
  // List of academic terms
  DataBase database = DataBase();
  @override
  void initState() {
    super.initState();
    setState(() {
      _initializeDatabase();
    });
  }
 Future<bool> _initializeDatabase() async{
      await database.startFireStore();
      setState(() {}); //update the view
      
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
      database.allTerms.terms.remove(termToRemove);
    });
  }

  AcademicTerm getCurrentTerm() {
    for (AcademicTerm term in database.allTerms.terms) {
      if (DateTime.now().isAfter(term.startTime) &&
          DateTime.now().isBefore(term.endTime)) {
        return term;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(
        term: getCurrentTerm(),
      ),
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
                    height: 256.0,

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
                          String jsonString = json.encode(database.allTerms);
                          database.writeJSON(jsonString);
                          database.update();
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
            database.allTerms.terms.add(result);
            String jsonString = json.encode(database.allTerms);
            database.writeJSON(jsonString);
            database.update();
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
