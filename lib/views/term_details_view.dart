import 'package:cognito/models/task.dart';
import 'package:cognito/views/add_task_view.dart';
/// Academic term details view
/// View screen to edit an AcademicTerm object
/// @author Julian Vu
///
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cognito/models/academic_term.dart';
import 'package:cognito/models/class.dart';
import 'package:cognito/views/add_class_view.dart';

class TermDetailsView extends StatefulWidget {
  // Hold academic term object
  final AcademicTerm term;

  // Constructor that takes in an academic term object
  TermDetailsView({Key key, @required this.term}) : super(key: key);

  @override
  _TermDetailsViewState createState() => _TermDetailsViewState();

}

class _TermDetailsViewState extends State<TermDetailsView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: BackButtonIcon(),
          onPressed: () {
            print("Returning a term");
            Navigator.of(context).pop(widget.term);
          },
        ),
        title: Text(
          widget.term.termName,
          style: Theme.of(context).primaryTextTheme.title,
        ),
        backgroundColor: Theme.of(context).primaryColorDark,

        actions: <Widget>[
          // Edit term title
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white,),
            onPressed: () async {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SimpleDialog(
                      title: Text("Change Term Title"),
                      children: <Widget>[
                        TextFormField(
                          style: Theme.of(context).accentTextTheme.body2,
                          decoration: InputDecoration(
                            hintText: "Term Title",
                            hintStyle: TextStyle(color: Colors.black45),
                            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          ),
                          onFieldSubmitted: (val) {
                            print(val);
                            setState(() {
                              widget.term.termName = val;
                              
                            });
                            Navigator.pop(context);
                          },
                          textInputAction: TextInputAction.done,
                        )
                      ],
                    );
                  }
              );
            },
          ),
        ],
      ),

      body: Container(
        child: Column(
          children: <Widget>[
            // Start Date
            DateRow(true, widget.term),
            Divider(),

            // End Date
            DateRow(false, widget.term),
            Divider(),

            // Classes
            ExpandableClassList(widget.term),
            ExpandableTaskList(widget.term),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          print("Tapped on plus button");
          Class result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddClassView()));
          if (result != null) {
            print(result.toString());
            widget.term.addClass(result);
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

// Helper class to modularize date row creation
class DateRow extends StatefulWidget {

  // Flag for whether this date is start date
  final bool _isStart;
  final AcademicTerm term;

  DateRow(this._isStart, this.term);

  @override
  _DateRowState createState() => _DateRowState();
}

class _DateRowState extends State<DateRow> {
  Future<Null> _selectDate(BuildContext context) async {

    // Make sure keyboard is hidden before showing date picker
    FocusScope.of(context).requestFocus(FocusNode());

    await Future.delayed(Duration(milliseconds:  200));

    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime(3000),
    );

    if (picked != null) {
      print("Date selected: ${picked.toString()}");
      setState(() {
        widget._isStart ? widget.term.startTime = picked : widget.term.endTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.calendar_today),
      title: Text(
        widget._isStart ? "Start Date" : "End Date",
        style: Theme.of(context).accentTextTheme.body2,
      ),
      trailing: Text(
          widget._isStart ? widget.term.getStartDateAsString() : widget.term.getEndDateAsString()
      ),
      onTap: () {
        print("Tapped on" + (widget._isStart ? " Start Date" : " End Date"));
        _selectDate(context);
      },
    );
  }
}

class ExpandableClassList extends StatefulWidget {

  final AcademicTerm term;

  ExpandableClassList(this.term);

  @override
  _ExpandableClassListState createState() => _ExpandableClassListState();
}

class _ExpandableClassListState extends State<ExpandableClassList> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: Icon(Icons.collections_bookmark),
      title: Text("Classes", style: Theme.of(context).accentTextTheme.body2,),
      children: widget.term.classes.isNotEmpty ?
        widget.term.classes.map((element) => ListTile(
          title: Text(element.title, style: Theme.of(context).accentTextTheme.body2,),
        )).toList()
          :
          <Widget>[
            ListTile(
              title: Text("No classes so far"),
            )
          ],
    );
  }
}

class ExpandableTaskList extends StatefulWidget {

  final AcademicTerm term;

  ExpandableTaskList(this.term);

  @override
  _ExpandableTaskListState createState() => _ExpandableTaskListState();
}

class _ExpandableTaskListState extends State<ExpandableTaskList> {

  List<Widget> _listOfTasks(){
    List<Widget> listTasks = List();
    if(widget.term.tasks.isNotEmpty){
        for(Task t in widget.term.tasks){
            listTasks.add(ListTile(
          title: Text(t.title, style: Theme.of(context).accentTextTheme.body2,),
        ));
        }
    }else{
        listTasks.add(ListTile(
              title: Text("No tasks so far"),
            ));
    }
    listTasks.add(ListTile(
              title: Text("Add a new Task", style: Theme.of(context).accentTextTheme.body2,),
              leading: Icon(Icons.add),
              onTap: () async{ 
                //TODO
                Task result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddTaskView()));
          if (result != null) {
            print(result.title);
            widget.term.addTask(result);
          }else{

          }
                },
            ),);
      return listTasks;
  }
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: Icon(Icons.check_box),
      title: Text("Tasks", style: Theme.of(context).accentTextTheme.body2,),
      children: _listOfTasks()  
    );
  }
}
