/// Club view
/// Displays list of Club cards
/// @author Praneet Singh
import 'package:flutter/material.dart';
import 'package:cognito/models/club.dart';
import 'package:cognito/models/academic_term.dart';
import 'package:cognito/views/main_drawer.dart';
import 'package:cognito/views/add_club_view.dart';
import 'package:cognito/views/club_details_view.dart';
import 'package:cognito/database/database.dart';

class ClubView extends StatefulWidget {
  // Academic term object
  AcademicTerm term;
  // Constructor that takes in an academic term object
  ClubView({Key key, @required this.term}) : super(key: key);

  @override
  _ClubViewState createState() => _ClubViewState();
}

class _ClubViewState extends State<ClubView> {
  DataBase database = DataBase();
  void removeClub(Club clubToRemove) {
    setState(() {
      widget.term.removeClub(clubToRemove);
    });
  }

  AcademicTerm getCurrentTerm() {
    for (AcademicTerm term in database.allTerms.terms) {
      if (DateTime.now().isAfter(term.startTime) &&
          DateTime.now().isBefore(term.endTime)) {
        widget.term = term;
        return term;
      }
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _initializeDatabase();
      getCurrentTerm();
    });
  }

  Future<bool> _initializeDatabase() async {
    await database.startFireStore();
    setState(() {}); //update the view
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(term: widget.term),
      appBar: AppBar(
        title: Text(
          widget.term.termName + " - Clubs",
          style: Theme.of(context).primaryTextTheme.title,
        ),
        backgroundColor: Theme.of(context).primaryColorDark,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddClubView()));
          if (result != null) {
            widget.term.addClub(result);
            database.allTerms.updateTerm(widget.term);
            database.updateDatabase();
          }
        },
        child: Icon(
          Icons.add,
          size: 42.0,
        ),
        backgroundColor: Theme.of(context).accentColor,
        foregroundColor: Colors.black,
      ),
      body: widget.term.clubs.isNotEmpty
          ? ListView.builder(
              itemCount: widget.term.clubs.length,
              itemBuilder: (BuildContext context, int index) {
                Club clubObj = widget.term.clubs[index];

                return Container(
                  margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                  child: InkWell(
                    onTap: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ClubDetailsView(club: clubObj)));
                      database.allTerms.updateTerm(widget.term);
                      database.updateDatabase();
                    },
                    child: Dismissible(
                      key: Key(widget.term.clubs[index].toString()),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        removeClub(clubObj);
                        database.allTerms.updateTerm(widget.term);
                        database.updateDatabase();
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("${clubObj.title} deleted"),
                        ));
                      },
                      child: Card(
                        color: Theme.of(context).primaryColor,
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.people, color: Colors.white,),
                              title: Text(
                                clubObj.title,
                                style: Theme.of(context).primaryTextTheme.body1,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
          : null,
    );
  }
}
