import 'package:cognito/database/database.dart';
import 'package:cognito/models/assignment.dart';
import 'package:cognito/models/category.dart';
import 'package:cognito/models/class.dart';
import 'package:cognito/views/components/category_dropdown.dart';
import 'package:cognito/views/components/select_time.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/select_date.dart';
import 'components/task_agenda_item.dart';

class AddAssignmentView extends StatefulWidget {
  AddAssignmentView(this.c);
  final Class c;

  @override
  _AddAssignmentViewState createState() => _AddAssignmentViewState();
}

class _AddAssignmentViewState extends State<AddAssignmentView> with SingleTickerProviderStateMixin{

  AnimationController _controller;
  Animation _animation;
  FocusNode _focusNodeDescription = FocusNode();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  CategoryDropdown categoryDropdownWidget;
  Category selectedCategory;

  final db = DataBase();

  final double begin = 425;
  final double end = 70;
  double _value = 0;
  SelectTime selectedTimeWidget = SelectTime(title: "",);
  SelectDate selectedDateWidget;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animation = Tween(begin: begin, end: end).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _focusNodeDescription.addListener(() {
      if (_focusNodeDescription.hasFocus) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });

    selectedDateWidget = SelectDate(
        onDateSelected: (DateTime date) {
          setState(() {
            selectedDate = date;
          });
        });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNodeDescription.dispose();
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          backgroundColor: Color(0xFFFFB8B8),
          elevation: 0,
        ),
        body: new InkWell(
          splashColor: Colors.transparent,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Stack(
            children: [
              body(),
              head(),
            ],
          ),
        )
    );
  }

  Widget head() {
    return Container(
        height: _animation.value,
        padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
        width: double.infinity,
        decoration: new BoxDecoration(
            color: Color(0xFFFFB8B8),
            borderRadius: new BorderRadius.only(
              bottomLeft: const Radius.circular(40.0),
              bottomRight: const Radius.circular(40.0),
            )
        ),
        child: FittedBox(
            alignment: Alignment.topLeft,
            fit: BoxFit.none,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Create an assignment",
                    style: Theme.of(context).primaryTextTheme.headline2,
                    textAlign: TextAlign.left,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                ),
                Opacity(
                  opacity: (_animation.value - end)/(begin - end),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Title",
                        style: Theme.of(context).primaryTextTheme.subtitle1,
                        textAlign: TextAlign.right,
                      ),
                      titleInput()
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                Text(
                  "Select category",
                  style: Theme.of(context).primaryTextTheme.subtitle1,
                ),
                categoryDropdownWidget = CategoryDropdown(widget.c.categories)
                ,
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                PriorityPicker(),
                SelectDueDateAndTime(),
              ],
            )
        )
    );
  }//        SizedBox(height: _animation.value,),

  Widget titleInput() {
    return Container(
      width: 250,
      child: TextField(
        controller: titleController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(5),
          isDense: true,
          hintText: "ie Homework #4",
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.secondaryVariant,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.secondaryVariant,
              )
          ),
        ),
      ),
    );
  }

  Widget body() {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    double slope = end/(begin - end) * -1;
    return Container(
        padding: EdgeInsets.fromLTRB(0, slope * (_animation.value - begin), 0, 0),
        child:
        ListView(
          padding: EdgeInsets.fromLTRB(25, 25, 25, 25),
          children: [
            SizedBox(height: begin/(begin - end)*(_animation.value - end)),
            descriptionInput(),
            Padding(
              padding: EdgeInsets.all(8),
            ),
            RaisedButton(
              onPressed: (){
                Assignment assignment = new Assignment(
                  title: titleController.text,
                  description: descriptionController.text,
                  category: getCategoryByName()
                );
                db.addAssignment(assignment, widget.c, null, user.uid);
              },
              child: Text(
                "Add Assignment",
                style: Theme.of(context).primaryTextTheme.button,
              ),
              color: Theme.of(context).colorScheme.onBackground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
            )
          ],
        )
    );
  }

  Widget descriptionInput() {
    return Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Description",
              style: Theme.of(context).primaryTextTheme.subtitle1,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 360,
              child: TextField(
                controller: descriptionController,
                focusNode: _focusNodeDescription,
                expands: false,
                maxLines: 20,
                minLines: 1,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(5),
                  isDense: true,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: Theme.of(context).colorScheme.secondaryVariant,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: Theme.of(context).colorScheme.secondaryVariant,
                      )
                  ),
                ),
              ),
            ),
          )
        ]
    );
  }

  Widget PriorityPicker() {
    final double sliderHeight = 40;
    final int min = 1;
    final int max = 3;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Priority Level",
          style: Theme.of(context).primaryTextTheme.subtitle1,
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.transparent,
            inactiveTrackColor: Colors.transparent,
            trackShape: RoundedRectSliderTrackShape(),
            trackHeight: 4.0,
            thumbShape: CustomSliderThumbCircleWithNumber(thumbRadius: sliderHeight * .4,
                min: min,
                max: max
            ),
            thumbColor: Colors.redAccent,
            overlayColor: Colors.red.withAlpha(32),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
            tickMarkShape: RoundSliderTickMarkShape(),
            activeTickMarkColor: Theme.of(context).backgroundColor,
            inactiveTickMarkColor: Theme.of(context).backgroundColor.withAlpha(100),
          ),
          child: Container(
            padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
            child: Slider(
              divisions: 2,
              value: _value,
              label: '$_value',
              onChanged: (value) {
              setState(() {
              _value = value;
              });
              }),
          )
        )
      ],
    );
  }

  Widget SelectDueDateAndTime() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Due",
          style: Theme.of(context).primaryTextTheme.subtitle1,
        ),
        Row(
          children: [
            selectedDateWidget,
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Text(
                "at",
                style: Theme.of(context).primaryTextTheme.subtitle2,
              ),
            ),
            selectedTimeWidget,
          ],
        ),
      ],
    );
  }

  Category getCategoryByName() {
    for(Category category in widget.c.categories)
      {
        if(categoryDropdownWidget.dropdownValue == category.title)
          {
            return category;
          }
      }
  }
}

class CustomSliderThumbCircleWithNumber extends CustomSliderThumbCircle {
  final double thumbRadius;
  final thumbHeight;
  final int min;
  final int max;

  const CustomSliderThumbCircleWithNumber({
    this.thumbRadius,
    this.thumbHeight,
    this.min,
    this.max,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(PaintingContext context, Offset center, {Animation<double> activationAnimation, Animation<double> enableAnimation, bool isDiscrete, TextPainter labelPainter, RenderBox parentBox, SliderThemeData sliderTheme, TextDirection textDirection, double value, double textScaleFactor, Size sizeWithOverflow}) {
    final Canvas canvas = context.canvas;

    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    TextSpan span = new TextSpan(
      style: new TextStyle(
        fontSize: thumbRadius * .8,
        fontWeight: FontWeight.w700,
        color: sliderTheme.thumbColor,
      ),
      text: getValue(value),
    );

    TextPainter tp = new TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);
    tp.layout();
    Offset textCenter =
    Offset(center.dx - (tp.width / 2), center.dy - (tp.height / 2));

    canvas.drawCircle(center, thumbRadius * .9, paint);
    tp.paint(canvas, textCenter);
  }

  String getValue(double value) {
    if(value == 0) {
      return '1';
    }
    return ((max * value).round()).toString();
  }
}


//import 'package:cognito/database/database.dart';
//import 'package:cognito/models/academic_term.dart';
//import 'package:cognito/models/assignment.dart';
//import 'package:cognito/models/category.dart';
//import 'package:cognito/models/class.dart';
//import 'package:cognito/views/add_priority_view.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/material.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'dart:async';
//
//import 'package:provider/provider.dart';
//
///// Assignment creation view
///// @author Praneet Singh
//
//enum Day { M, Tu, W, Th, F, Sat, Sun }
//
//class AddAssignmentView extends StatefulWidget {
//  final Class aClass;
//  final AcademicTerm term;
//  AddAssignmentView({Key key, @required this.aClass, @required this.term}) : super(key: key);
//
//  @override
//  _AddAssignmentViewState createState() => _AddAssignmentViewState();
//}
//
//class _AddAssignmentViewState extends State<AddAssignmentView> {
//  DataBase database = DataBase();
//  Category category;
//  final _titleController = TextEditingController();
//  final _locationController = TextEditingController();
//  final _descriptionController = TextEditingController();
//  final _earnedController = TextEditingController();
//  final _possibleController = TextEditingController();
//  final _durationController = TextEditingController();
//  final TextEditingController _categoryTitle = TextEditingController();
//  final TextEditingController _categoryWeight = TextEditingController();
//  final TextEditingController _categoryTitleEdit = TextEditingController();
//  final TextEditingController _categoryWeightEdit = TextEditingController();
//  bool _isRepeated = false;
//  int _selectedPriority = 1;
//  int termID = 0;
//
//  //  Stepper
//  //  init step to 0th position
//  int currentStep = 0;
//
//  @override
//  Widget build(BuildContext context) {
//    FirebaseUser user = Provider.of<FirebaseUser>(context);
//    return Scaffold(
//        appBar: AppBar(
//          title: Text("Add New Assignment"),
//          backgroundColor: Theme.of(context).primaryColorDark,
//          actions: <Widget>[
//            IconButton(
//              icon: Icon(Icons.check),
//              onPressed: () {
//                Assignment result = Assignment(title: _titleController.text, description: _descriptionController.text, location: _locationController.text,
//                    start: null, end: null, dueDate: dueDate, pointsEarned: double.parse(_earnedController.text), category: category, pointsPossible: double.parse(_possibleController.text),
//                    isAssessment: false, duration: Duration(minutes: int.parse(_durationController.text)), priority: _selectedPriority);
//                database.addAssignment(result, widget.aClass, widget.term, user.uid);
//                Navigator.of(context).pop(_titleController != null
//                    ? result
//                    : null);
//              },
//            )
//          ],
//        ),
//        body: Stepper(
//          currentStep: this.currentStep,
//          type: StepperType.vertical,
//          steps: getSteps(user.uid),
//          onStepTapped: (step) {
//            setState(() {
//              currentStep = step;
//            });
//          },
//          onStepCancel: () {
//            setState(() {
//              if (currentStep > 0) {
//                currentStep--;
//              } else {
//                currentStep = 0;
//              }
//            });
//          },
//          onStepContinue: () {
//            setState(() {
//              if (currentStep < getSteps(user.uid).length - 1) {
//                currentStep++;
//              } else {
//                //Needs term id
//                Assignment result = Assignment(title: _titleController.text, description: _descriptionController.text, location: _locationController.text,
//                    start: null, end: null, dueDate: dueDate, pointsEarned: double.parse(_earnedController.text), category: category, pointsPossible: double.parse(_possibleController.text),
//                    isAssessment: false, priority: _selectedPriority, duration: Duration(minutes: int.parse(_durationController.text)));
//                database.addAssignment(result, widget.aClass, widget.term, user.uid);
//                Navigator.of(context).pop(result);
//              }
//            });
//          },
//        ));
//  }
//
//  List<Step> getSteps(String userID) {
//    return [
//      Step(
//          title: Text(
//            "Assignment title",
//            style: Theme.of(context).accentTextTheme.body1,
//          ),
//          content: textFieldTile(
//              hint: "Assignment title", controller: _titleController),
//          state: StepState.indexed,
//          isActive: true),
//      Step(
//          title: Text(
//            "Description",
//            style: Theme.of(context).accentTextTheme.body1,
//          ),
//          content: ListTile(
//            title: TextFormField(
//              controller: _descriptionController,
//              autofocus: false,
//              style: Theme.of(context).accentTextTheme.body1,
//              keyboardType: TextInputType.multiline,
//              textInputAction: TextInputAction.done,
//              maxLines: 5,
//              decoration: InputDecoration(
//                  hintText: "Description",
//                  hintStyle: Theme.of(context).inputDecorationTheme.hintStyle),
//            ),
//          ),
//          state: StepState.indexed,
//          isActive: true),
//      Step(
//          title: Text(
//            "Points earned",
//            style: Theme.of(context).accentTextTheme.body1,
//          ),
//          content: textFieldTile(
//              hint: "Points earned", controller: _earnedController),
//          state: StepState.indexed,
//          isActive: true),
//      Step(
//          title: Text(
//            "Points possible",
//            style: Theme.of(context).accentTextTheme.body1,
//          ),
//          content: textFieldTile(
//              hint: "Points possible", controller: _possibleController),
//          state: StepState.indexed,
//          isActive: true),
//          Step(
//          title: Text(
//            "Estimated duration",
//            style: Theme.of(context).accentTextTheme.body1,
//          ),
//          content: textFieldTile(
//              hint: "In minutes", controller: _durationController),
//          state: StepState.indexed,
//          isActive: true),
//      Step(
//          title: Text("Select due date"),
//          content: ListTile(
//            title: Text(
//              "Due Date",
//              style: Theme.of(context).accentTextTheme.body2,
//            ),
//            trailing: Text(
//              dueDate != null
//                  ? "${dueDate.month.toString()}/${dueDate.day.toString()}/${dueDate.year.toString()}"
//                  : "",
//            ),
//            onTap: () => _selectDate(context),
//          ),
//          state: StepState.indexed,
//          isActive: true),
//      Step(
//        title: Text("Select a category"),
//        state: StepState.indexed,
//        isActive: true,
//        content: StreamBuilder<List<Category>>(
//          stream: database.streamCategory(widget.aClass),
//          builder: (BuildContext context, snapshot) {
//            print("ID: " + widget.aClass.id.toString());
//            return ExpansionTile(
//                title: Text(
//                  _categoryListTitle,
//                  style: Theme.of(context).accentTextTheme.body2,
//                ),
//                children: _listOfCategories(snapshot.data, userID));
//          },
//        )
//      ),
//      Step(
//          title: Text(
//            "Select priority",
//            style: Theme.of(context).accentTextTheme.body1,
//          ),
//          state: StepState.indexed,
//          isActive: true,
//          content: ListTile(
//            title: Text(
//              "Priority selected:",
//              style: Theme.of(context).accentTextTheme.body1,
//            ),
//            trailing: Text(_selectedPriority.toString()),
//            onTap: () async {
//              int result = await showDialog(
//                  context: context,
//                  builder: (context) => AddPriorityDialog(_selectedPriority));
//              if (result != null) {
//                setState(() {
//                  _selectedPriority = result;
//                });
//              }
//            },
//          ))
//    ];
//  }
//
//  DateTime dueDate;
//  List<int> daysOfEvent = List();
//  ListTile textFieldTile(
//      {Widget leading,
//      Widget trailing,
//      TextInputType keyboardType,
//      String hint,
//      Widget subtitle,
//      TextEditingController controller}) {
//    return ListTile(
//      leading: leading,
//      trailing: trailing,
//      title: TextFormField(
//        controller: controller,
//        autofocus: false,
//        keyboardType: keyboardType,
//        style: Theme.of(context).accentTextTheme.body1,
//        decoration: InputDecoration(
//          hintText: hint,
//          hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
//        ),
//      ),
//      subtitle: subtitle,
//    );
//  }
//
//
//  void selectDay(Day day) {
//    setState(() {
//      daysOfEvent.add(day.index + 1);
//    });
//  }
//
//  void deselectDay(Day day) {
//    setState(() {
//      daysOfEvent.remove(day.index + 1);
//    });
//  }
//
//  String _categoryListTitle = "Category";
//  List<Widget> _listOfCategories(List<Category> categories, userID) {
//    //Need to get category from Firestore
//    List<Widget> listCategories = List();
//    if (categories != null && categories.length > 0) {
//       categories.forEach((c) {
//        listCategories.add(
//          ListTile(
//            title: Text(
//              c.title + ": " + c.weightInPercentage.toString() + "%",
//              style: Theme.of(context).accentTextTheme.body2,
//            ),
//            onLongPress: () {
//              showDialog(
//                  context: context,
//                  builder: (BuildContext context) {
//                    return SimpleDialog(
//                        title:
//                            Text("Are you sure you want to delete " + c.title),
//                        children: <Widget>[
//                          Row(
//                            crossAxisAlignment: CrossAxisAlignment.center,
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            children: <Widget>[
//                              RaisedButton(
//                                color: Colors.white,
//                                child: Text("Yes"),
//                                onPressed: () {
//                                  setState(() {
//                                    widget.aClass.deleteCategory(c);
//                                    database.deleteCategory(c, widget.aClass);
//                                    Navigator.of(context).pop();
//                                  });
//                                },
//                              ),
//                              RaisedButton(
//                                color: Colors.white,
//                                child: Text("Cancel"),
//                                onPressed: () {
//                                  Navigator.of(context).pop();
//                                },
//                              ),
//                              RaisedButton(
//                                color: Colors.white,
//                                child: Text("Edit"),
//                                onPressed: () {
//                                  setState(() {
//                                    _categoryTitleEdit.text = c.title;
//                                    _categoryWeightEdit.text =
//                                        c.weightInPercentage.toString();
//                                  });
//                                  showDialog(
//                                      context: context,
//                                      builder: (BuildContext context) {
//                                        return SimpleDialog(
//                                          title: Text("Edit category"),
//                                          children: <Widget>[
//                                            TextFormField(
//                                              controller: _categoryTitleEdit,
//                                              style: Theme.of(context)
//                                                  .accentTextTheme
//                                                  .body2,
//                                              decoration: InputDecoration(
//                                                hintText: "Category title",
//                                                hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
//                                                contentPadding:
//                                                    EdgeInsets.fromLTRB(
//                                                        20.0, 10.0, 20.0, 10.0),
//                                              ),
//
//                                              //Navigator.pop(context);
//                                              textInputAction:
//                                                  TextInputAction.done,
//                                            ),
//                                            TextFormField(
//                                              controller: _categoryWeightEdit,
//                                              style: Theme.of(context)
//                                                  .accentTextTheme
//                                                  .body2,
//                                              decoration: InputDecoration(
//                                                hintText: "Category Weight",
//                                                hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
//                                                contentPadding:
//                                                    EdgeInsets.fromLTRB(
//                                                        20.0, 10.0, 20.0, 10.0),
//                                              ),
//                                              textInputAction:
//                                                  TextInputAction.done,
//                                            ),
//                                            RaisedButton(
//                                              color: Colors.white,
//                                              child: Text("Done"),
//                                              onPressed: () {
//                                                setState(() {
//                                                  c.title =
//                                                      _categoryTitleEdit.text;
//                                                  c.weightInPercentage =
//                                                      double.parse(
//                                                          _categoryWeightEdit
//                                                              .text);
//                                                });
//                                                Navigator.pop(context);
//                                                Navigator.pop(context);
//                                              },
//                                            ),
//                                          ],
//                                        );
//                                      });
//                                },
//                              )
//                            ],
//                          )
//                        ]);
//                  });
//            },
//            onTap: () async {
//              setState(
//                () {
//                  _categoryListTitle =
//                      c.title + ": " + c.weightInPercentage.toString() + "%";
//                  category = c;
//                },
//              );
//            },
//          ),
//        );
//      });
//    }
//    else {
//      listCategories.add(ListTile(
//        title: Text(
//          "No Categories so far",
//          style: Theme.of(context).accentTextTheme.body2,
//        ),
//      ));
//    }
//
//    listCategories.add(
//      ListTile(
//        title: Text(
//          "Add a new Category",
//          style: Theme.of(context).accentTextTheme.body2,
//        ),
//        leading: Icon(Icons.add),
//        onTap: () {
//          showDialog(
//              context: context,
//              builder: (BuildContext context) {
//                Category cat = Category();
//                return SimpleDialog(
//                  title: Text("Create a new category"),
//                  children: <Widget>[
//                    TextFormField(
//                      controller: _categoryTitle,
//                      style: Theme.of(context).accentTextTheme.body2,
//                      decoration: InputDecoration(
//                        hintText: "Category title",
//                        hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
//                        contentPadding:
//                            EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
//                      ),
//
//                      //Navigator.pop(context);
//                      textInputAction: TextInputAction.done,
//                    ),
//                    TextFormField(
//                      controller: _categoryWeight,
//                      style: Theme.of(context).accentTextTheme.body2,
//                      decoration: InputDecoration(
//                        hintText: "Category Weight",
//                        hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
//                        contentPadding:
//                            EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
//                      ),
//                      textInputAction: TextInputAction.done,
//                    ),
//                    RaisedButton(
//                      child: Text("Done"),
//                      onPressed: () {
//                        if(_categoryTitle.text != "" || _categoryWeight.text != "") {
//                          setState(() {
//                            cat.title = _categoryTitle.text;
//                            cat.weightInPercentage =
//                                double.parse(_categoryWeight.text);
//                            try {
//                              if(isCategoryOver(cat.weightInPercentage, categories))
//                              {
//                                //TODO: ADD some kind of alert
//                              }
//                              else
//                              {
//                                database.addCategoryToClass(cat, widget.aClass, widget.term, userID);
//                              }
//                            } catch (e) {
//                              Scaffold.of(context).showSnackBar(SnackBar(
//                                content: Text(e),
//                                duration: Duration(seconds: 7),
//                              ));
//                            }
//                          });
//                        }
//                        _categoryTitle.text = "";
//                        _categoryWeight.text = "";
//                        Navigator.pop(context);
//                      },
//                    ),
//                  ],
//                );
//              });
//        },
//      ),
//    );
//    return listCategories;
//  }
//
//
//  bool isCategoryOver(double categoryWeight, List<Category> categories) {
//    int sum = 0;
//    for(Category c in categories) {
//      c.weightInPercentage += sum;
//    }
//    return sum + categoryWeight > 100;
//  }
//
//  Column daySelectionColumn(Day day) {
//    return Column(
//      mainAxisAlignment: MainAxisAlignment.center,
//      children: <Widget>[
//        Text(day.toString().substring(4)),
//        Checkbox(
//          value: daysOfEvent.contains(day.index + 1),
//          onChanged: (bool e) {
//            daysOfEvent.contains(day.index + 1)
//                ? deselectDay(day)
//                : selectDay(day);
//            if (daysOfEvent.isEmpty) {
//              _isRepeated = false;
//            } else {
//              _isRepeated = true;
//            }
//          },
//        ),
//      ],
//    );
//  }
//
//  Future<Null> _selectDate(BuildContext context) async {
//    // Hide keyboard before showing date picker
//    FocusScope.of(context).requestFocus(FocusNode());
//
//    // Add delay to be sure keyboard is no longer visible
//    await Future.delayed(Duration(milliseconds: 200));
//
//    final DateTime picked = await showDatePicker(
//        context: context,
//        initialDate: dueDate != null
//            ? DateTime(dueDate.year, dueDate.month, dueDate.day)
//            : DateTime.now(),
//        firstDate: DateTime(1990),
//        lastDate: DateTime(3000));
//
//    if (picked != null) {
//      print("Date selected: ${picked.toString()}");
//      setState(() {
//        dueDate = picked;
//      });
//    }
//  }
//
//  AcademicTerm getCurrentTerm() {
//    for (AcademicTerm term in database.allTerms.terms) {
//      if (DateTime.now().isAfter(term.startTime) &&
//          DateTime.now().isBefore(term.endTime)) {
//        return term;
//      }
//    }
//    return null;
//  }
//
//  Future updateTermID()
//  async {
//    termID = await database.generateTermID(widget.term);
//  }
//}
