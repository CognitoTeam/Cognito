import 'package:flutter/material.dart';
import 'package:cognito/models/club.dart';
import 'package:cognito/models/academic_term.dart';
import 'package:cognito/views/main_drawer.dart';
import 'package:cognito/views/add_club_view.dart';
import 'package:cognito/views/club_details_view.dart';
import 'package:cognito/database/database.dart';

/// Club view
/// Displays list of Club cards
/// @author Praneet Singh

class ClubView extends StatefulWidget {
  @override
  _ClubViewState createState() => _ClubViewState();
}

class _ClubViewState extends State<ClubView> {
  AcademicTerm term;
  DataBase database = DataBase();

  void removeClub(Club clubToRemove) {
    setState(() {
      term.removeClub(clubToRemove);
    });
  }

  AcademicTerm getCurrentTerm() {
    for (AcademicTerm term in database.allTerms.terms) {
      if (DateTime.now().isAfter(term.startTime) &&
          DateTime.now().isBefore(term.endTime)) {
        this.term = term;
        return term;
      }
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      getCurrentTerm();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text(
          term.termName + " - Clubs",
          style: Theme.of(context).primaryTextTheme.title,
        ),
        backgroundColor: Theme.of(context).primaryColorDark,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddClubView()));
          if (result != null) {
            term.addClub(result);
            database.allTerms.updateTerm(term);
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
      body: term.clubs.isNotEmpty
          ? ListView.builder(
              itemCount: term.clubs.length,
              itemBuilder: (BuildContext context, int index) {
                Club clubObj = term.clubs[index];

                return Container(
                  margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                  child: InkWell(
                    onTap: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ClubDetailsView(club: clubObj)));
                      database.allTerms.updateTerm(term);
                      database.updateDatabase();
                    },
                    child: Dismissible(
                      key: Key(term.clubs[index].toString()),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        removeClub(clubObj);
                        database.allTerms.updateTerm(term);
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
                              leading: Icon(
                                Icons.people,
                                color: Colors.white,
                              ),
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
