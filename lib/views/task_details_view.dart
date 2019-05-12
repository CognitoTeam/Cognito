import 'package:cognito/models/task.dart';
import 'package:cognito/views/add_priority_view.dart';
import 'package:flutter/material.dart';

/**
 * Task details view
 * @author Praneet Singh
 */

class TaskDetailsView extends StatefulWidget {
  // Hold academic term object
  final Task task;

  // Constructor that takes in an academic term object
  TaskDetailsView({Key key, @required this.task}) : super(key: key);
  @override
  _TaskDetailsViewState createState() => _TaskDetailsViewState();
}

class _TaskDetailsViewState extends State<TaskDetailsView> {
  TextEditingController _titleController;
  TextEditingController _locationController;
  TextEditingController _descriptionController;
  int _selectedPriority;
  //  Stepper
  //  init step to 0th position
  int currentStep = 0;
  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController =
        TextEditingController(text: widget.task.description);
    _locationController = TextEditingController(text: widget.task.location);
    dueDate = widget.task.dueDate;
    _selectedPriority = widget.task.priority == null ? 1 :  widget.task.priority;
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

  Future<Null> _selectDate(BuildContext context) async {
    // Hide keyboard before showing date picker
    FocusScope.of(context).requestFocus(FocusNode());

    // Add delay to be sure keyboard is no longer visible
    await Future.delayed(Duration(milliseconds: 200));

    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: dueDate != null
            ? DateTime(dueDate.year, dueDate.month, dueDate.day)
            : DateTime.now(),
        firstDate: DateTime(1990),
        lastDate: DateTime(3000));

    if (picked != null) {
      print("Date selected: ${picked.toString()}");
      setState(() {
        dueDate = picked;
      });
    }
  }

  List<Step> getSteps() {
    return [
      Step(
          title: Text(
            "Task title",
            style: Theme.of(context).accentTextTheme.body1,
          ),
          content:
              textFieldTile(hint: "Task title", controller: _titleController),
          state: StepState.indexed,
          isActive: true),
      Step(
          title: Text(
            "Location",
            style: Theme.of(context).accentTextTheme.body1,
          ),
          content:
              textFieldTile(hint: "Location", controller: _locationController),
          state: StepState.indexed,
          isActive: true),
      Step(
          title: Text(
            "Description",
            style: Theme.of(context).accentTextTheme.body1,
          ),
          content: ListTile(
            title: TextFormField(
              controller: _descriptionController,
              autofocus: false,
              style: Theme.of(context).accentTextTheme.body1,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.done,
              maxLines: 5,
              decoration: InputDecoration(
                  hintText: "Description",
                  hintStyle: TextStyle(color: Colors.black45)),
            ),
          ),
          state: StepState.indexed,
          isActive: true),
      Step(
          title: Text("Due date"),
          state: StepState.indexed,
          isActive: true,
          content: ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text(
              "Select Due Date",
              style: Theme.of(context).accentTextTheme.body2,
            ),
            trailing: Text(
              dueDate != null
                  ? "${dueDate.month.toString()}/${dueDate.day.toString()}/${dueDate.year.toString()}"
                  : "",
            ),
            onTap: () => _selectDate(context),
          )),
      Step(
          title: Text(
            "Select priority",
            style: Theme.of(context).accentTextTheme.body1,
          ),
          state: StepState.indexed,
          isActive: true,
          content: ListTile(
            title: Text(
              "Priority selected:",
              style: Theme.of(context).accentTextTheme.body1,
            ),
            trailing: Text(_selectedPriority.toString()),
            onTap: () async {
              int result = await showDialog(
                  context: context,
                  builder: (context) => AddPriorityDialog(_selectedPriority));
              if (result != null) {
                setState(() {
                  _selectedPriority = result;
                });
              }
            },
          ))
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: BackButtonIcon(),
          onPressed: () {
            print("Returning a task");
            widget.task.title = _titleController.text;
            widget.task.location = _locationController.text;
            widget.task.description = _descriptionController.text;
            widget.task.daysOfEvent = daysOfEvent;
            widget.task.priority = _selectedPriority;
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
      body: Stepper(
        currentStep: this.currentStep,
        steps: getSteps(),
        type: StepperType.vertical,
        onStepTapped: (step) {
          setState(() {
            currentStep = step;
          });
        },
        onStepCancel: () {
          setState(() {
            if (currentStep > 0) {
              currentStep--;
            } else {
              currentStep = 0;
            }
          });
        },
        onStepContinue: () {
          setState(() {
            if (currentStep < getSteps().length - 1) {
              currentStep++;
            } else {
              widget.task.title = _titleController.text;
              widget.task.location = _locationController.text;
              widget.task.description = _descriptionController.text;
              widget.task.daysOfEvent = daysOfEvent;
              widget.task.priority = _selectedPriority;
              Navigator.of(context).pop(widget.task);
            }
          });
        },
      ),
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
      initialDate: widget.task.dueDate != null
          ? DateTime(widget.task.dueDate.year, widget.task.dueDate.month,
              widget.task.dueDate.day)
          : DateTime.now(),
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
