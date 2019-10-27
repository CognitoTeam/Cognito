import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cognito/database/database.dart';
import 'package:cognito/database/notifications.dart';
import 'package:cognito/models/academic_term.dart';
import 'package:cognito/models/assignment.dart';
import 'package:cognito/models/category.dart';
import 'package:cognito/models/class.dart';
import 'package:cognito/views/add_priority_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import 'package:provider/provider.dart';

/// Assessment creation view
/// @author Praneet Singh
///
enum Day { M, Tu, W, Th, F, Sat, Sun }

class AddAssessmentView extends StatefulWidget {
  final Class aClass;
  final AcademicTerm term;
  AddAssessmentView({Key key, @required this.aClass, @required this.term}) : super(key: key);
  @override
  _AddAssessmentViewState createState() => _AddAssessmentViewState();
}

class _AddAssessmentViewState extends State<AddAssessmentView> {
  DataBase database = DataBase();
  Category category;
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _earnedController = TextEditingController();
  final _possibleController = TextEditingController();
  final _durationController = TextEditingController();
  final TextEditingController _categoryTitle = TextEditingController();
  final TextEditingController _categoryWeight = TextEditingController();
  final TextEditingController _categoryTitleEdit = TextEditingController();
  final TextEditingController _categoryWeightEdit = TextEditingController();
  bool _isRepeated = false;
  int _selectedPriority = 1;
  int termID = 0;
  Notifications noti = Notifications();
  String classDocID = "";

  //  Stepper
  //  init step to 0th position
  int currentStep = 0;
  DateTime dueDate;
  List<int> daysOfEvent = List();
  ListTile textFieldTile(
      {Widget leading,
      Widget trailing,
      TextInputType keyboardType,
      String hint,
      Widget subtitle,
      TextEditingController controller}) {
    return ListTile(
      leading: leading,
      trailing: trailing,
      title: TextFormField(
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
    //Class document id stream
    var user = Provider.of<FirebaseUser>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Add New Assessment"),
          backgroundColor: Theme.of(context).primaryColorDark,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                Assignment result = Assignment(title: _titleController.text, description: _descriptionController.text, location: _locationController.text,
                    start: null, end: null, dueDate: dueDate, pointsEarned: double.parse(_earnedController.text), category: category, pointsPossible: double.parse(_possibleController.text),
                    isAssessment: true, duration: Duration(minutes: int.parse(_durationController.text)));
                database.addAssignment(result, widget.aClass, widget.term, user.uid);
                Navigator.of(context).pop(_titleController != null
                    ? result
                    : null);
              },
            )
          ],
        ),
        body: Stepper(
          currentStep: this.currentStep,
          type: StepperType.vertical,
          steps: getSteps(),
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
                //Needs term id
                Assignment result = Assignment(title: _titleController.text, description: _descriptionController.text, location: _locationController.text,
                    start: null, end: null, dueDate: dueDate, pointsEarned: double.parse(_earnedController.text), category: category, pointsPossible: double.parse(_possibleController.text),
                    isAssessment: true, duration: Duration(minutes: int.parse(_durationController.text)));
                database.addAssignment(result, widget.aClass, widget.term, user.uid);
                Navigator.of(context).pop(result);
              }
            });
          },
        ));
  }

  List<Step> getSteps() {
    return [
      Step(
          title: Text(
            "Assessment title",
            style: Theme.of(context).accentTextTheme.body1,
          ),
          content: textFieldTile(
              hint: "Assessment title", controller: _titleController),
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
          title: Text(
            "Points earned",
            style: Theme.of(context).accentTextTheme.body1,
          ),
          content: textFieldTile(
              hint: "Points earned", controller: _earnedController),
          state: StepState.indexed,
          isActive: true),
      Step(
          title: Text(
            "Points possible",
            style: Theme.of(context).accentTextTheme.body1,
          ),
          content: textFieldTile(
              hint: "Points possible", controller: _possibleController),
          state: StepState.indexed,
          isActive: true),
      Step(
          title: Text(
            "Estimated duration",
            style: Theme.of(context).accentTextTheme.body1,
          ),
          content: textFieldTile(
              hint: "In minutes", controller: _durationController),
          state: StepState.indexed,
          isActive: true),
      Step(
          title: Text(
            "Exam/Quiz Date",
            style: Theme.of(context).accentTextTheme.body1,
          ),
          content: ListTile(
            title: Text(
              "Date",
              style: Theme.of(context).accentTextTheme.body1,
            ),
            trailing: Text(
              dueDate != null ? DateFormat.yMd().format(dueDate) : "",
            ),
            onTap: () => _selectDate(context),
          ),
          state: StepState.indexed,
          isActive: true),
      Step(
          title: Text(
            "Exam/Quiz Time",
            style: Theme.of(context).accentTextTheme.body1,
          ),
          content: ListTile(
            title: Text(
              "Time",
              style: Theme.of(context).accentTextTheme.body1,
            ),
            trailing: Text(
              dueDate != null ? DateFormat.jm().format(dueDate) : "",
            ),
            onTap: () => _selectTime(context),
          ),
          state: StepState.indexed,
          isActive: true),
      Step(
        title: Text(
          "Select a category",
          style: Theme.of(context).accentTextTheme.body1,
        ),
        state: StepState.indexed,
        isActive: true,
        content: StreamBuilder<List<Category>>(
          stream: database.streamCategory(widget.aClass),
          builder: (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
            return ExpansionTile(
                title: Text(
                  _categoryListTitle,
                  style: Theme.of(context).accentTextTheme.body2,
                ),
                children: _listOfCategories(snapshot.data));
          },
        )
      ),
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
  void initState() {
    super.initState();
    setState(() {
      dueDate = DateTime.now();
    });
  }

// get current academic term
  AcademicTerm getCurrentTerm() {
    for (AcademicTerm term in database.allTerms.terms) {
      if (DateTime.now().isAfter(term.startTime) &&
          DateTime.now().isBefore(term.endTime)) {
        return term;
      }
    }
    return null;
  }

  void selectDay(Day day) {
    setState(() {
      daysOfEvent.add(day.index + 1);
    });
  }

  void deselectDay(Day day) {
    setState(() {
      daysOfEvent.remove(day.index + 1);
    });
  }

  String _categoryListTitle = "Select a category";
  // Returns a LitsTile widget categories as a list of widgets
  List<Widget> _listOfCategories(List<Category> categories) {
    List<Widget> listCategories = List();
    //Need to get category from Firestore
    if (categories != null && categories.length > 0) {
      categories.forEach((c) {
          listCategories.add(
            ListTile(
              title: Text(
                c.title.toString() + ": " + c.weightInPercentage.toString() +
                    "%",
                style: Theme
                    .of(context)
                    .accentTextTheme
                    .body2,
              ),
              onTap: () async {
                setState(
                      () {
                    _categoryListTitle =
                        c.title + ": " + c.weightInPercentage.toString() + "%";
                    category = c;
                  },
                );
              },
              onLongPress: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return SimpleDialog(
                          title:
                          Text("Are you sure you want to delete " + c.title),
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                RaisedButton(
                                  color: Colors.white,
                                  child: Text("Yes"),
                                  onPressed: () {
                                    setState(() {
                                      widget.aClass.deleteCategory(c);
                                      database.updateDatabase();
                                      Navigator.of(context).pop();
                                    });
                                  },
                                ),
                                RaisedButton(
                                  color: Colors.white,
                                  child: Text("Cancel"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                RaisedButton(
                                  child: Text("Edit"),
                                  color: Colors.white,
                                  onPressed: () {
                                    setState(() {
                                      _categoryTitleEdit.text = c.title;
                                      _categoryWeightEdit.text =
                                          c.weightInPercentage.toString();
                                    });
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return SimpleDialog(
                                            title: Text("Edit category"),
                                            children: <Widget>[
                                              TextFormField(
                                                controller: _categoryTitleEdit,
                                                style: Theme
                                                    .of(context)
                                                    .accentTextTheme
                                                    .body2,
                                                decoration: InputDecoration(
                                                  hintText: "Category title",
                                                  hintStyle: TextStyle(
                                                      color: Colors.black45),
                                                  contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      20.0, 10.0, 20.0, 10.0),
                                                ),

                                                //Navigator.pop(context);
                                                textInputAction:
                                                TextInputAction.done,
                                              ),
                                              TextFormField(
                                                controller: _categoryWeightEdit,
                                                style: Theme
                                                    .of(context)
                                                    .accentTextTheme
                                                    .body2,
                                                decoration: InputDecoration(
                                                  hintText: "Category Weight",
                                                  hintStyle: TextStyle(
                                                      color: Colors.black45),
                                                  contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      20.0, 10.0, 20.0, 10.0),
                                                ),
                                                textInputAction:
                                                TextInputAction.done,
                                              ),
                                              RaisedButton(
                                                color: Colors.white,
                                                child: Text("Done"),
                                                onPressed: () {
                                                  setState(() {
                                                    c.title =
                                                        _categoryTitleEdit.text;
                                                    c.weightInPercentage =
                                                        double.parse(
                                                            _categoryWeightEdit
                                                                .text);
                                                  });
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                )
                              ],
                            )
                          ]);
                    });
              },
            ),);
      });
    }
    else {
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
                      //Every time add category
                      child: Text("Done"),
                      onPressed: () {
                        setState(() {
                          cat.title = _categoryTitle.text;
                          cat.weightInPercentage =
                              double.parse(_categoryWeight.text);
                          try {
                            //Adding category here will be a permanent measure and stored without compliance with the assignment
                            //Therefore it will be stored in the classes collection and this will access classes to retrieve all the categories
                            database.addCategoryToClass(cat, widget.aClass, widget.term);
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

// Returns a column widget containg 7 checkboxes for day selection
  Column daySelectionColumn(Day day) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(day.toString().substring(4)),
        Checkbox(
          value: daysOfEvent.contains(day.index + 1),
          onChanged: (bool e) {
            daysOfEvent.contains(day.index + 1)
                ? deselectDay(day)
                : selectDay(day);
            if (daysOfEvent.isEmpty) {
              _isRepeated = false;
            } else {
              _isRepeated = true;
            }
            print(_isRepeated);
          },
        ),
      ],
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
        dueDate = DateTime(picked.year, picked.month, picked.day, dueDate.hour,
            dueDate.minute);
      });
    }
  }

  Future<Null> _selectTime(BuildContext context) async {
    // Hide keyboard before showing time picker
    FocusScope.of(context).requestFocus(FocusNode());

    // Add delay to be sure keyboard is no longer visible
    await Future.delayed(Duration(milliseconds: 200));

    final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: dueDate != null
            ? TimeOfDay(hour: dueDate.hour, minute: dueDate.minute)
            : TimeOfDay.now());

    if (picked != null) {
      setState(() {
        dueDate = DateTime(dueDate.year, dueDate.month, dueDate.day,
            picked.hour, picked.minute);
      });
    }
  }
}
