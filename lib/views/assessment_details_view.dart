import 'package:cognito/models/assignment.dart';
import 'package:cognito/models/category.dart';
import 'package:cognito/models/class.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

/// Assessment details view
/// @author Praneet Singh

class AssessmentDetailsView extends StatefulWidget {
  // Hold academic term object
  final Assignment assignment;
  final Class aClass;
  // Constructor that takes in an academic term object
  AssessmentDetailsView(
      {Key key, @required this.assignment, @required this.aClass})
      : super(key: key);
  @override
  _AssessmentDetailsViewState createState() => _AssessmentDetailsViewState();
}

class _AssessmentDetailsViewState extends State<AssessmentDetailsView> {
  TextEditingController _descriptionController;
  TextEditingController _earnedController;
  TextEditingController _possibleController;

  TextEditingController _categoryTitle = TextEditingController();
  TextEditingController _categoryWeight = TextEditingController();
  TextEditingController _categoryTitleEdit = TextEditingController();
  TextEditingController _categoryWeightEdit = TextEditingController();
  @override
  void initState() {
    super.initState();
    _descriptionController =
        TextEditingController(text: widget.assignment.description);
    _earnedController =
        TextEditingController(text: widget.assignment.pointsEarned.toString());
    _possibleController = TextEditingController(
        text: widget.assignment.pointsPossible.toString());

    _categoryListTitle = widget.assignment.category.title +
        ": " +
        widget.assignment.category.weightInPercentage.toString() +
        "%";
  }

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

  String _categoryListTitle = "Select a category";
  List<Widget> _listOfCategories() {
    List<Widget> listCategories = List();
    if (widget.aClass.categories.isNotEmpty) {
      for (Category c in widget.aClass.categories) {
        listCategories.add(
          ListTile(
            title: Text(
              c.title + ": " + c.weightInPercentage.toString() + "%",
              style: Theme.of(context).accentTextTheme.body2,
            ),
            onTap: () async {
              setState(
                () {
                  _categoryListTitle =
                      c.title + ": " + c.weightInPercentage.toString() + "%";
                  widget.assignment.category = c;
                },
              );
            },
            onLongPress: () {
              setState(() {
                _categoryTitleEdit.text = c.title;
                _categoryWeightEdit.text = c.weightInPercentage.toString();
              });
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SimpleDialog(
                      title: Text("Edit category"),
                      children: <Widget>[
                        TextFormField(
                          controller: _categoryTitleEdit,
                          style: Theme.of(context).accentTextTheme.body2,
                          decoration: InputDecoration(
                            hintText: "Category title",
                            hintStyle: TextStyle(color: Colors.black45),
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          ),

                          //Navigator.pop(context);
                          textInputAction: TextInputAction.done,
                        ),
                        TextFormField(
                          controller: _categoryWeightEdit,
                          style: Theme.of(context).accentTextTheme.body2,
                          decoration: InputDecoration(
                            hintText: "Category Weight",
                            hintStyle: TextStyle(color: Colors.black45),
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          ),
                          textInputAction: TextInputAction.done,
                        ),
                        RaisedButton(
                          child: Text("Done"),
                          onPressed: () {
                            setState(() {
                              c.title = _categoryTitleEdit.text;
                              c.weightInPercentage =
                                  double.parse(_categoryWeightEdit.text);
                            });
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  });
            },
          ),
        );
      }
    } else {
      listCategories.add(ListTile(
        title: Text(
          "No Categories so far",
          style: Theme.of(context).accentTextTheme.body2,
        ),
      ));
    }
    listCategories.add(
      ListTile(
        title: Text(
          "Add a new Category",
          style: Theme.of(context).accentTextTheme.body2,
        ),
        leading: Icon(Icons.add),
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                Category cat = Category();
                return SimpleDialog(
                  title: Text("Create a new category"),
                  children: <Widget>[
                    TextFormField(
                      controller: _categoryTitle,
                      style: Theme.of(context).accentTextTheme.body2,
                      decoration: InputDecoration(
                        hintText: "Category title",
                        hintStyle: TextStyle(color: Colors.black45),
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      ),

                      //Navigator.pop(context);
                      textInputAction: TextInputAction.done,
                    ),
                    TextFormField(
                      controller: _categoryWeight,
                      style: Theme.of(context).accentTextTheme.body2,
                      decoration: InputDecoration(
                        hintText: "Category Weight",
                        hintStyle: TextStyle(color: Colors.black45),
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      ),
                      textInputAction: TextInputAction.done,
                    ),
                    RaisedButton(
                      child: Text("Done"),
                      onPressed: () {
                        setState(() {
                          cat.title = _categoryTitle.text;
                          cat.weightInPercentage =
                              double.parse(_categoryWeight.text);
                          try {
                            widget.aClass.addCategory(cat);
                          } catch (e) {
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text(e),
                              duration: Duration(seconds: 7),
                            ));
                          }
                        });
                        _categoryTitle.text = "";
                        _categoryWeight.text = "";
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              });
        },
      ),
    );
    return listCategories;
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

  Future<Null> _selectTime(BuildContext context) async {
    // Hide keyboard before showing time picker
    FocusScope.of(context).requestFocus(FocusNode());

    // Add delay to be sure keyboard is no longer visible
    await Future.delayed(Duration(milliseconds: 200));

    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (picked != null) {
      setState(() {
        widget.assignment.dueDate = DateTime(
            widget.assignment.dueDate.year,
            widget.assignment.dueDate.month,
            widget.assignment.dueDate.day,
            picked.hour,
            picked.minute);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: BackButtonIcon(),
          onPressed: () {
            print("Returning a assessment");
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
                      title: Text("Change Assessment Title"),
                      children: <Widget>[
                        TextFormField(
                          initialValue: widget.assignment.title,
                          style: Theme.of(context).accentTextTheme.body2,
                          decoration: InputDecoration(
                            hintText: "Assessment Title",
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
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text(
              "Exam/Quiz Date",
              style: Theme.of(context).accentTextTheme.body1,
            ),
            trailing: Text(
              widget.assignment.dueDate != null
                  ? DateFormat.yMd().format(widget.assignment.dueDate)
                  : "",
            ),
            onTap: () => _selectDate(context),
          ),
          ListTile(
            leading: Icon(Icons.access_time),
            title: Text(
              "Exam/Quiz Time",
              style: Theme.of(context).accentTextTheme.body1,
            ),
            trailing: Text(
              widget.assignment.dueDate != null
                  ? DateFormat.jm().format(widget.assignment.dueDate)
                  : "",
            ),
            onTap: () => _selectTime(context),
          ),
          ExpansionTile(
              leading: Icon(Icons.category),
              title: Text(
                _categoryListTitle,
                style: Theme.of(context).accentTextTheme.body2,
              ),
              children: _listOfCategories()),
        ],
      )),
    );
  }
}
