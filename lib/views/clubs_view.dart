import 'package:cloud_firestore/cloud_firestore.dart';
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
  AcademicTerm term;

  ClubView(this.term);

  @override
  _ClubViewState createState() => _ClubViewState();
}

class _ClubViewState extends State<ClubView> {
  DataBase database = DataBase();

  @override
  void initState() {
    super.initState();
  }

  void removeClub(Club clubToRemove) {
    setState(() {
      database.removeClub(clubToRemove, widget.term);
    });
  }

  Widget _getClubCards()
  {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('clubs')
        .where('user_id', isEqualTo: database.userID)
        .where('term_name', isEqualTo: widget.term.termName).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if(snapshot.hasData)
          {
            return new ListView(
              children: snapshot.data.documents.map((document) {
                Club clubObj = database.documentToClub(document);
                return Container(
                  margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                  child: InkWell(
                    onTap: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ClubDetailsView(club: clubObj)));
                    },
                    child: Dismissible(
                      key: Key(clubObj.toString()),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        database.removeClub(clubObj, widget.term);
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
              }).toList(),
            );
          }
        else
          {
            return new Container();
          }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
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
              .push(MaterialPageRoute(builder: (context) => AddClubView(widget.term)));
          if (result != null) {
          }
        },
        child: Icon(
          Icons.add,
          size: 42.0,
        ),
        backgroundColor: Theme.of(context).accentColor,
        foregroundColor: Colors.black,
      ),
      body: _getClubCards()
    );
  }
}
