import 'package:cognito/models/task.dart';
import 'package:flutter/material.dart';

class TaskDetailsView extends StatefulWidget {
  // Hold academic term object
  Task task;

  // Constructor that takes in an academic term object
  TaskDetailsView({Key key, @required this.task}) : super(key: key);
  @override
  _TaskDetailsViewState createState() => _TaskDetailsViewState();
}

class _TaskDetailsViewState extends State<TaskDetailsView> {
  TextEditingController _locationController;
  TextEditingController _descriptionController;
  @override
  void initState() {
    super.initState();
    _descriptionController =
        TextEditingController(text: widget.task.description);
    _locationController = TextEditingController(text: widget.task.location);
  }

  DateTime dueDate;
  List<int> daysOfEvent = List();

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
            print("Returning a task");
            widget.task.location = _locationController.text;
            widget.task.description = _descriptionController.text;
            Navigator.of(context).pop(widget.task);
          },
        ),
        title: Text(
          widget.task.title,
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
                      title: Text("Change Task Title"),
                      children: <Widget>[
                        TextFormField(
                          initialValue: widget.task.title,
                          style: Theme.of(context).accentTextTheme.body2,
                          decoration: InputDecoration(
                            hintText: "Task Title",
                            hintStyle: TextStyle(color: Colors.black45),
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          ),
                          onFieldSubmitted: (val) {
                            print(val);
                            setState(() {
                              widget.task.title = val;
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
          textFieldTile(controller: _locationController),
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
          DateRow(widget.task),
        ],
      )),
    );
  }
}

// Helper class to modularize date row creation
class DateRow extends StatefulWidget {
  // Flag for whether this date is start date
  final Task task;

  DateRow(this.task);

  @override
  _DateRowState createState() => _DateRowState();
}

class _DateRowState extends State<DateRow> {
  String getDueDateAsString() {
    return "${widget.task.dueDate.month}/${widget.task.dueDate.day}/${widget.task.dueDate.year}";
  }

  Future<Null> _selectDate(BuildContext context) async {
    // Make sure keyboard is hidden before showing date picker
    FocusScope.of(context).requestFocus(FocusNode());

    await Future.delayed(Duration(milliseconds: 200));

    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime(3000),
    );

    if (picked != null) {
      print("Date selected: ${picked.toString()}");
      setState(() {
        widget.task.dueDate = picked;
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
