/// Class view
/// Displays list of Class cards
/// @author Julian Vu
import 'package:flutter/material.dart';
import 'package:cognito/models/class.dart';
import 'package:cognito/models/academic_term.dart';
import 'package:cognito/views/main_drawer.dart';
import 'package:cognito/views/add_class_view.dart';
import 'package:cognito/views/class_details_view.dart';

class ClassView extends StatefulWidget {
  // Academic term object
  AcademicTerm term;

  // Constructor that takes in an academic term object
  ClassView({Key key, @required this.term}) : super(key: key);

  @override
  _ClassViewState createState() => _ClassViewState();
}

class _ClassViewState extends State<ClassView> {
  void removeClass(Class classToRemove) {
    setState(() {
      widget.term.classes.remove(classToRemove);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(term: widget.term),
      appBar: AppBar(
        title: Text(
          widget.term.termName + " - Classes",
          style: Theme.of(context).primaryTextTheme.title,
        ),
        backgroundColor: Theme.of(context).primaryColorDark,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddClassView()));
          if (result != null) {
            widget.term.classes.add(result);
            
          }
        },
        child: Icon(
          Icons.add,
          size: 42.0,
        ),
        backgroundColor: Theme.of(context).accentColor,
        foregroundColor: Colors.black,
      ),

      body: widget.term.classes.isNotEmpty
        ? ListView.builder(
        itemCount: widget.term.classes.length,
        itemBuilder: (BuildContext context, int index) {
          Class classObj = widget.term.classes[index];

          return Container(
            margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
            child: InkWell(
              onTap: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (context) => ClassDetailsView(classObj: classObj)));
              },

              child: Dismissible(
                key: Key(widget.term.classes[index].toString()),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  removeClass(classObj);
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text("${classObj.title} deleted"),
                  ));
                },

                child: Card(
                  color: Theme.of(context).primaryColor,
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.label),
                        title: Text(
                            classObj.subjectArea + " " + classObj.courseNumber + " - " + classObj.title,
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
      ) : null,
    );
  }
}
