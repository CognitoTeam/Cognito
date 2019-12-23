import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cognito/models/event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cognito/models/club.dart';
import 'package:cognito/models/academic_term.dart';
import 'package:cognito/views/main_drawer.dart';
import 'package:cognito/views/add_club_view.dart';
import 'package:cognito/views/club_details_view.dart';
import 'package:cognito/database/database.dart';
import 'package:provider/provider.dart';

/// Club view
/// Displays list of Club cards
/// @author Praneet Singh

class ClubView extends StatefulWidget {
  AcademicTerm term;

  ClubView(this.term);

  @override
  _ClubViewState createState() => _ClubViewState(term);
}

class _ClubViewState extends State<ClubView> {
  DataBase database = DataBase();
  AcademicTerm term;


  @override
  void initState() {
    super.initState();
  }

  _ClubViewState(AcademicTerm term)
  {
    this.term = term;
  }

  void removeClub(Club clubToRemove) {
    setState(() {
      database.removeClub(clubToRemove, widget.term);
    });
  }


  Widget _getClubCards(FirebaseUser user, AcademicTerm term) {
    return StreamBuilder<List<Club>>(
      stream: database.streamClubs(user),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.connectionState == ConnectionState.done || snapshot.connectionState == ConnectionState.active) {
          List<Club> clubs = snapshot.data;
          if (snapshot.data != null) {
            return new ListView(
              children: clubs.map((clubObj) {
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
                        Club clubCopy = clubObj;
                        database.removeClub(clubObj, widget.term);
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("${clubCopy.title} deleted"),
                        ));
                      },
                      child: Card(
                        color: Theme
                            .of(context)
                            .primaryColor,
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              leading: Icon(
                                Icons.people,
                                color: Colors.white,
                              ),
                              title: Text(
                                clubObj.title,
                                style: Theme
                                    .of(context)
                                    .primaryTextTheme
                                    .body1,
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
          else {
            return new Container(
              child: Center(child: Text("No Clubs Yet"),),
            );
          }
        }else
          {
            return new Container(
            child: Center(child: Text("Loading your clubs..." ),),);
          }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    return FutureBuilder(
      future: database.getCurrentTerm(user),
      builder: (context,snapshot) {
        if(snapshot.connectionState == ConnectionState.done || snapshot.connectionState == ConnectionState.active)
        {
          return Scaffold(
              drawer: MainDrawer(),
              appBar: AppBar(
                title: Text(
                  snapshot.data.termName + " - Clubs",
                  style: Theme.of(context).primaryTextTheme.title,
                ),
                backgroundColor: Theme.of(context).primaryColorDark,
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  final result = await Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => AddClubView(snapshot.data)));
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
              body: _getClubCards(user, term)
          );
        }
        else
        {
          return new Container();
        }
      },
    );
  }
}
