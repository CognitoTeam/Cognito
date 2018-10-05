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
        title: Text(
          widget.term.termName,
          style: Theme.of(context).primaryTextTheme.title,
        ),
        backgroundColor: Theme.of(context).primaryColorDark,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            DateRow(true, widget.term),
            Divider(),
            DateRow(false, widget.term)
          ],
        ),
      )
    );
  }
}

class DateRow extends StatefulWidget {
  final bool _isStart;
  final AcademicTerm term;

  DateRow(this._isStart, this.term);

  @override
  _DateRowState createState() => _DateRowState();
}

class _DateRowState extends State<DateRow> {
  Future<Null> _selectDate(BuildContext context) async {
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


