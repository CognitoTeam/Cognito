import 'package:cognito/models/assignment.dart';
import 'package:flutter/material.dart';

/// Assignment details view
/// @author Praneet Singh

class AssignmentDetailsView extends StatefulWidget {
  // Hold academic term object
  Assignment assignment;

  // Constructor that takes in an academic term object
  AssignmentDetailsView({Key key, @required this.assignment}) : super(key: key);
  @override
  _AssignmentDetailsViewState createState() => _AssignmentDetailsViewState();
}

class _AssignmentDetailsViewState extends State<AssignmentDetailsView> {
  TextEditingController _descriptionController;
  TextEditingController _earnedController;
  TextEditingController _possibleController;
  @override
  void initState() {
    super.initState();
    _descriptionController =
        TextEditingController(text: widget.assignment.description);
    _earnedController =
        TextEditingController(text: widget.assignment.pointsEarned.toString());
    _possibleController = TextEditingController(
        text: widget.assignment.pointsPossible.toString());
  }

  DateTime dueDate;

  ListTile textFieldTile(
      {String intiialText,
      Widget leading,
      Widget trailing,
      TextInputType keyboardType,
      String hint,
      Widget subtitle,
      TextEditingController controller}) {
    return ListTile(
      leading: leading,
      trailing: trailing,
      title: TextFormField(
        initialValue: intiialText,
        controller: controller,
        autofocus: false,
        keyboardType: keyboardType,
        style: Theme.of(context).accentTextTheme.body1,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.black45),
        ),
      ),
      subtitle: subtitle,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: BackButtonIcon(),
          onPressed: () {
            print("Returning a assignment");
            widget.assignment.description = _descriptionController.text;
            widget.assignment.pointsEarned =
                double.parse(_earnedController.text);
            widget.assignment.pointsPossible =
                double.parse(_possibleController.text);

            Navigator.of(context).pop(widget.assignment);
          },
        ),
        title: Text(
          widget.assignment.title,
          style: Theme.of(context).primaryTextTheme.title,
        ),
        backgroundColor: Theme.of(context).primaryColorDark,
        actions: <Widget>[
          // Edit term title
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.white,
            ),
            onPressed: () async {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SimpleDialog(
                      title: Text("Change Assignment Title"),
                      children: <Widget>[
                        TextFormField(
                          initialValue: widget.assignment.title,
                          style: Theme.of(context).accentTextTheme.body2,
                          decoration: InputDecoration(
                            hintText: "Assignment Title",
                            hintStyle: TextStyle(color: Colors.black45),
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          ),
                          onFieldSubmitted: (val) {
                            print(val);
                            setState(() {
                              widget.assignment.title = val;
                            });
                            Navigator.pop(context);
                          },
                          textInputAction: TextInputAction.done,
                        )
                      ],
                    );
                  });
            },
          ),
        ],
      ),
      body: Container(
          child: Column(
        children: <Widget>[
          ListTile(
            title: TextFormField(
              controller: _descriptionController,
              autofocus: false,
              style: Theme.of(context).accentTextTheme.body1,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.done,
              maxLines: 5,
            ),
          ),
          ListTile(
            title: TextFormField(
              controller: _earnedController,
              autofocus: false,
              style: Theme.of(context).accentTextTheme.body1,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                  hintText: "Points earned",
                  hintStyle: TextStyle(color: Colors.black45)),
            ),
          ),
          ListTile(
            title: TextFormField(
              controller: _possibleController,
              autofocus: false,
              style: Theme.of(context).accentTextTheme.body1,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                  hintText: "Possible points",
                  hintStyle: TextStyle(color: Colors.black45)),
            ),
          ),
          DateRow(widget.assignment),
        ],
      )),
    );
  }
}

// Helper class to modularize date row creation
class DateRow extends StatefulWidget {
  // Flag for whether this date is start date
  final Assignment assignment;

  DateRow(this.assignment);

  @override
  _DateRowState createState() => _DateRowState();
}

class _DateRowState extends State<DateRow> {
  String getDueDateAsString() {
    return "${widget.assignment.dueDate.month}/${widget.assignment.dueDate.day}/${widget.assignment.dueDate.year}";
  }

  Future<Null> _selectDate(BuildContext context) async {
    // Make sure keyboard is hidden before showing date picker
    FocusScope.of(context).requestFocus(FocusNode());

    await Future.delayed(Duration(milliseconds: 200));

    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: widget.assignment.dueDate,
      firstDate: DateTime(1990),
      lastDate: DateTime(3000),
    );

    if (picked != null) {
      print("Date selected: ${picked.toString()}");
      setState(() {
        widget.assignment.dueDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.calendar_today),
      title: Text(
        "Due Date",
        style: Theme.of(context).accentTextTheme.body2,
      ),
      trailing: Text(getDueDateAsString()),
      onTap: () {
        print("Tapped on Due date");
        _selectDate(context);
      },
    );
  }
}
