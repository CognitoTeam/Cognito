/// Academic term details view
/// View screen to edit an AcademicTerm object
/// @author Julian Vu
///
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cognito/models/academic_term.dart';

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

            // Change Term Title
            ListTile(
              leading: Icon(Icons.label),
              title: Text(
                "Change Term Title",
                style: Theme.of(context).accentTextTheme.body2,
              ),
              onTap: () async {
                print("Tapped on change term title");
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
            )
          ],
        ),
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


