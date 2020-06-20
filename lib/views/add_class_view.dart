import 'package:cognito/database/database.dart';
import 'package:cognito/models/academic_term.dart';
import 'package:cognito/models/category.dart';
import 'package:cognito/views/components/add_categories.dart';
import 'package:cognito/views/components/days_checkbox.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cognito/views/components/block_picker.dart';
import 'package:provider/provider.dart';
import 'components/select_date.dart';

class AddClassView extends StatefulWidget {
  AddClassView(this.term);
  final AcademicTerm term;

  @override
  _AddClassViewState createState() => _AddClassViewState();
}

class _AddClassViewState extends State<AddClassView> with SingleTickerProviderStateMixin{

  AnimationController _controller;
  Animation _animation;
  FocusNode _focusNodeInstructor = FocusNode();
  FocusNode _focusNodeDescription = FocusNode();
  FocusNode _focusNodeClassLocation = FocusNode();
  FocusNode _focusNodeOfficeLocation = FocusNode();
  FocusNode _focusNodeUnits = FocusNode();
  FocusNode _focusNodeCategoryName = FocusNode();
  FocusNode _focusNodeCategoryPercent = FocusNode();

  TextEditingController titleController = TextEditingController();
  SelectDate classStart = SelectDate(title: "Start Time",);
  SelectDate classEnd = SelectDate(title: "End Time",);
  List<int> daysRepeated = List();
  TextEditingController instructorController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController classLocationController = TextEditingController();
  TextEditingController officeLocationController = TextEditingController();
  SelectDate officeStart = SelectDate(title: "",);
  SelectDate officeEnd = SelectDate(title: "",);
  List<int> officeDaysRepeated = List();
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a4);
  TextEditingController unitsController = TextEditingController();
  List<Category> categories = List();


  final db = DataBase();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animation = Tween(begin: 450.0, end: 150.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _focusNodeInstructor.addListener(() {
      if (_focusNodeInstructor.hasFocus) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
    _focusNodeDescription.addListener(() {
      if (_focusNodeDescription.hasFocus) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
    _focusNodeClassLocation.addListener(() {
      if (_focusNodeClassLocation.hasFocus) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
    _focusNodeOfficeLocation.addListener(() {
      if (_focusNodeOfficeLocation.hasFocus) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
    _focusNodeUnits.addListener(() {
      if (_focusNodeOfficeLocation.hasFocus) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
    _focusNodeCategoryName.addListener(() {
      if (_focusNodeCategoryName.hasFocus) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
    _focusNodeCategoryPercent.addListener(() {
      if (_focusNodeCategoryPercent.hasFocus) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNodeInstructor.dispose();
    _focusNodeDescription.dispose();
    _focusNodeUnits.dispose();
    _focusNodeOfficeLocation.dispose();
    _focusNodeClassLocation.dispose();
    _focusNodeCategoryName.dispose();
    _focusNodeCategoryPercent.dispose();
    titleController.dispose();
    instructorController.dispose();
    descriptionController.dispose();
    classLocationController.dispose();
    officeLocationController.dispose();
    unitsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          backgroundColor: Color(0xFF64BC88),
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
          color: Color(0xFF64BC88),
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
                "Add a new class",
                style: Theme.of(context).primaryTextTheme.headline2,
                textAlign: TextAlign.left,
              ),
            ),
            Opacity(
              opacity: (_animation.value - 75)/275,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Title",
                    style: Theme.of(context).primaryTextTheme.subtitle1,
                    textAlign: TextAlign.right,
                  ),
                  titleInput(),
                  classStart,
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "to",
                        style: Theme.of(context).primaryTextTheme.subtitle2,
                      ),
                    ),
                  ),
                  classEnd,
                  SizedBox(height: 10,),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Days Repeated",
                      style: Theme.of(context).primaryTextTheme.subtitle1,
                    ),
                  ),
                  SizedBox(height: 5,),
                  DaysCheckbox()
                ],
              ),
            ),
          ],
        )
        )
    );
  }

  Widget titleInput() {
    return Container(
            width: 250,
            child: TextField(
              controller: titleController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(5),
                isDense: true,
                hintText: "ie CS-154 Formal Lanuages",
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
    return ListView(
      padding: EdgeInsets.all(25),
      children: [
        SizedBox(height: _animation.value,),
        instructorInput(),
        Padding(
          padding: EdgeInsets.all(8),
        ),
        descriptionInput(),
        Padding(
          padding: EdgeInsets.all(8),
        ),
        locationInput(),
        Padding(
          padding: EdgeInsets.all(8),
        ),
        officeHours(),
        Padding(
          padding: EdgeInsets.all(8),
        ),
        Container(
          alignment: Alignment.center,
          child: Text(
            "Office Days",
            style: Theme.of(context).primaryTextTheme.subtitle2,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(4),
        ),
        DaysCheckbox(),
        Padding(
          padding: EdgeInsets.all(8),
        ),
        unitsInput(),
        Padding(
          padding: EdgeInsets.all(8),
        ),
        AddCategories(_focusNodeCategoryName, _focusNodeCategoryPercent),
        Padding(
          padding: EdgeInsets.all(8),
        ),
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            "Select a Color Theme",
            style: Theme.of(context).primaryTextTheme.subtitle2,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8),
        ),
        BlockPicker(
          pickerColor: currentColor,
          onColorChanged: changeColor,
        ),
        Padding(
          padding: EdgeInsets.all(8),
        ),
        RaisedButton(
          onPressed: (){ db.addClass(user, titleController.text, unitsController.text == "" ? -1 : int.parse(unitsController.text), classLocationController.text, instructorController.text,
              officeLocationController.text, descriptionController.text, daysRepeated, classStart.selectedDate, classEnd.selectedDate, officeStart.selectedDate, officeEnd.selectedDate, currentColor.toString(), widget.term);},
          child: Text(
            "Add Class",
            style: Theme.of(context).primaryTextTheme.button,
          ),
          color: Theme.of(context).colorScheme.onBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        )
      ],
    );
  }

  static String decToHexa(int n)
  {
    // char array to store hexadecimal number
    List hexaDeciNum = new List();

    // counter for hexadecimal number array
    int i = 0;
    while(n!=0)
    {
      // temporary variable to store remainder
      int temp  = 0;

      // storing remainder in temp variable.
      temp = n % 16;

      // check if temp < 10
      if(temp < 10)
      {
        hexaDeciNum.add(String.fromCharCode(temp + 48));
        i++;
      }
      else
      {
        hexaDeciNum.add(String.fromCharCode(temp + 55));
        i++;
      }

      n = n~/16;
    }

    // printing hexadecimal number array in reverse order
    String val = "";
    for(int j=hexaDeciNum.length - 1; j>=0; j--) {
      val += hexaDeciNum[j].toLowerCase();
    }
    return val;
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
    print(pickerColor.toString() + "++++" + pickerColor.value.toString() + "++++" + decToHexa(pickerColor.value));
  }

  Widget instructorInput() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Professor/Instructor",
            style: Theme.of(context).primaryTextTheme.subtitle1,
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: 250,
            child: TextField(
              controller: instructorController,
              focusNode: _focusNodeInstructor,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(5),
                isDense: true,
                hintText: "ie Dr Potika",
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
                maxLines: 10,
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

  Widget locationInput() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Class Location",
                style: Theme.of(context).primaryTextTheme.subtitle1,
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 150,
                child: TextField(
                  controller: classLocationController,
                  focusNode: _focusNodeClassLocation,
                  expands: false,
                  maxLines: 10,
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
          ],
        ),
        SizedBox(
          width: 50,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Office Location",
                style: Theme.of(context).primaryTextTheme.subtitle1,
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 150,
                child: TextField(
                  controller: officeLocationController,
                  focusNode: _focusNodeOfficeLocation,
                  expands: false,
                  maxLines: 10,
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
          ],
        )
      ],
    );
  }

  Widget officeHours()
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Office Hours",
          style: Theme.of(context).primaryTextTheme.subtitle2,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            officeStart,
            SizedBox(width: 20,),
            Container(
              padding: EdgeInsets.fromLTRB(0, 13, 0, 0),
              child: Text(
                "to",
                style: Theme.of(context).primaryTextTheme.subtitle2,
              ),
            ),
            SizedBox(width: 20,),
            officeEnd
      ],
      )
      ],
    );
  }

  Widget unitsInput()
  {
    return Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Units",
              style: Theme.of(context).primaryTextTheme.subtitle1,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 70,
              child: TextField(
                controller: unitsController,
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly
                ], // Only numbers can be entered
                keyboardType: TextInputType.number,
                focusNode: _focusNodeUnits,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(5),
                  isDense: true,
                  hintText: "ie 3",
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
}


//// Copyright 2019 UniPlan. All rights reserved
//
//import 'dart:async';
//
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:cognito/database/database.dart';
//import 'package:cognito/models/academic_term.dart';
//import 'package:cognito/models/all_terms.dart';
//import 'package:cognito/models/class.dart';
//import 'package:cognito/views/block_picker.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
//import 'package:provider/provider.dart';
//
///// Class creation view
///// [author] Julian Vu
//enum Day { M, Tu, W, Th, F, Sat, Sun }
//
//class AddClassView extends StatefulWidget {
//
//  final AcademicTerm term;
//
//  AddClassView(this.term);
//
//  @override
//  _AddClassViewState createState() => _AddClassViewState();
//}
//
//class _AddClassViewState extends State<AddClassView> {
//  DataBase database = DataBase();
//  AcademicTerm currentTerm;
//  AllTerms allTerms;
//
//  DateTime startTime, endTime;
//  List<int> daysOfEvent = List();
//  List<String> subjectsString = List();
//  final firestore = Firestore.instance;
//
//
//  final _subjectController = TextEditingController();
//  final _courseNumberController = TextEditingController();
//  final _courseTitleController = TextEditingController();
//  final _unitCountController = TextEditingController();
//  final _locationController = TextEditingController();
//  final _instructorController = TextEditingController();
//  final _officeLocationController = TextEditingController();
//  final _descriptionController = TextEditingController();
//
//  //  Stepper
//  //  init step to 0th position
//  int currentStep = 0;
//  Color pickerColor = Color(0xff443a49);
//  Color currentColor = Color(0xff443a4);
//
//  @override
//  void initState() {
//    super.initState();
//    setState(() {
//      updateCurrentTerm();
//    });
//  }
//
//  /// Return list of [Step] objects representing the different kinds of inputs
//  /// Needed to create a [Class]
//  List<Step> getSteps() {
//    return [
//      Step(
//          title: Text(
//            "Subject",
//            style: Theme.of(context).accentTextTheme.body1,
//          ),
//          content: selectSubjectTile(),
//          state: StepState.indexed,
//          isActive: true),
//      Step(
//          title: Text(
//            "Course number",
//            style: Theme.of(context).accentTextTheme.body1,
//          ),
//          content: textFieldTile(
//              hint: "Course number e.g. 146",
//              controller: _courseNumberController),
//          state: StepState.indexed,
//          isActive: true),
//      Step(
//          title: Text(
//            "Course title",
//            style: Theme.of(context).accentTextTheme.body1,
//          ),
//          content: textFieldTile(
//              hint: "Course title e.g. Data Structures and Algorithms",
//              controller: _courseTitleController),
//          state: StepState.indexed,
//          isActive: true),
//      Step(
//          title: Text(
//            "Number of units",
//            style: Theme.of(context).accentTextTheme.body1,
//          ),
//          content: textFieldTile(
//              hint: "Number of units e.g. 4", controller: _unitCountController),
//          state: StepState.indexed,
//          isActive: true),
//      Step(
//          title: Text(
//            "Location",
//            style: Theme.of(context).accentTextTheme.body1,
//          ),
//          content: textFieldTile(
//              hint: "Location e.g. MQH 222", controller: _locationController),
//          state: StepState.indexed,
//          isActive: true),
//      Step(
//          title: Text(
//            "Instructor",
//            style: Theme.of(context).accentTextTheme.body1,
//          ),
//          content: textFieldTile(
//              hint: "Instructor e.g. Dr. Potika",
//              controller: _instructorController),
//          state: StepState.indexed,
//          isActive: true),
//      Step(
//          title: Text(
//            "Office Location",
//            style: Theme.of(context).accentTextTheme.body1,
//          ),
//          content: textFieldTile(
//              hint: "Office location e.g. MQH 232",
//              controller: _officeLocationController),
//          state: StepState.indexed,
//          isActive: true),
//      Step(
//          title: Text(
//            "Desciption",
//            style: Theme.of(context).accentTextTheme.body1,
//          ),
//          content: TextFormField(
//            controller: _descriptionController,
//            autofocus: false,
//            style: Theme.of(context).accentTextTheme.body1,
//            keyboardType: TextInputType.multiline,
//            textInputAction: TextInputAction.done,
//            maxLines: 5,
//            decoration: InputDecoration(
//                hintText: "Description",
//                hintStyle: Theme.of(context).inputDecorationTheme.hintStyle),
//          ),
//          state: StepState.indexed,
//          isActive: true),
//      Step(
//          title: Text(
//            "Start and End times",
//            style: Theme.of(context).accentTextTheme.body1,
//          ),
//          content: _timeSelectionColumn(),
//          isActive: true,
//          state: StepState.indexed),
//      Step(
//        title: Text(
//          "Days repeated",
//          style: Theme.of(context).accentTextTheme.body1,
//        ),
//        content: _repeatingDaySelectionTile(),
//        state: StepState.indexed,
//        isActive: true,
//      ),
//      Step(
//        title: Text(
//          "Choose a Color Theme",
//          style: Theme.of(context).accentTextTheme.body1,
//        ),
//        content: BlockPicker(
//          pickerColor: currentColor,
//          onColorChanged: changeColor,
//        ),
//        state: StepState.indexed,
//        isActive: true,
//      )
//    ];
//  }
//
//  void changeColor(Color color) {
//    setState(() => pickerColor = color);
//    print(pickerColor.toString() + "++++" + pickerColor.value.toString() + "++++" + decToHexa(pickerColor.value));
//  }
//
//  /// Returns [ListTile] widget containing checkboxes that represent the
//  /// days in the week that this [Class] repeats
//  ListTile _repeatingDaySelectionTile() {
//    return ListTile(
//      title: Column(
//        children: <Widget>[
//          Row(
//            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//            children: <Widget>[
//              daySelectionColumn(Day.M),
//              daySelectionColumn(Day.Tu),
//              daySelectionColumn(Day.W),
//              daySelectionColumn(Day.Th),
//              daySelectionColumn(Day.F),
//            ],
//          ),
//          Row(
//            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//            children: <Widget>[
//              daySelectionColumn(Day.Sat),
//              daySelectionColumn(Day.Sun),
//            ],
//          )
//        ],
//      ),
//    );
//  }
//
//  /// Returns a [Column] containing the start and end time selection tiles
//  Column _timeSelectionColumn() {
//    return Column(
//      children: <Widget>[
//        _timeSelectionTile(true),
//        Divider(),
//        _timeSelectionTile(false),
//      ],
//    );
//  }
//
//  static String decToHexa(int n)
//  {
//    // char array to store hexadecimal number
//    List hexaDeciNum = new List();
//
//    // counter for hexadecimal number array
//    int i = 0;
//    while(n!=0)
//    {
//      // temporary variable to store remainder
//      int temp  = 0;
//
//      // storing remainder in temp variable.
//      temp = n % 16;
//
//      // check if temp < 10
//      if(temp < 10)
//      {
//        hexaDeciNum.add(String.fromCharCode(temp + 48));
//        i++;
//      }
//      else
//      {
//        hexaDeciNum.add(String.fromCharCode(temp + 55));
//        i++;
//      }
//
//      n = n~/16;
//    }
//
//    // printing hexadecimal number array in reverse order
//    String val = "";
//    for(int j=hexaDeciNum.length - 1; j>=0; j--) {
//      val += hexaDeciNum[j].toLowerCase();
//    }
//    return val;
//  }
//
//  /// Returns a [ListTile] for selecting the start or end time depending on
//  /// the boolean input.
//  ListTile _timeSelectionTile(bool isStart) {
//    return ListTile(
//      leading: Icon(Icons.access_time),
//      title: Text(
//        isStart ? "Select Start Time" : "Select End Time",
//        style: Theme.of(context).accentTextTheme.body2,
//      ),
//      trailing: isStart
//          ? Text(
//              startTime != null ? DateFormat.jm().format(startTime) : "",
//            )
//          : Text(endTime != null ? DateFormat.jm().format(endTime) : ""),
//      onTap: () => _selectTime(isStart, context),
//    );
//  }
//
//  /// Returns a [ListTile] containing a [TextFormField] for user input.
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
//      title: TextField(
//        controller: controller,
//        autofocus: false,
//        keyboardType: keyboardType,
//        style: Theme.of(context).accentTextTheme.body1,
//        decoration: InputDecoration(
//          labelText: hint,
//          labelStyle: TextStyle(color: Colors.grey),
//        ),
//      ),
//      subtitle: subtitle,
//    );
//  }
//
//  /// Helper function for selecting a day
//  /// Adds a day to the list of repeated days for this class
//  /// The day to add is the index of the day + 1 since enums start from 0
//  void selectDay(Day day) {
//    setState(() {
//      daysOfEvent.add(day.index + 1);
//    });
//  }
//
//  void updateCurrentTerm() async {
//    await updateAllTerms();
//    for (AcademicTerm term in allTerms.terms) {
//      if (DateTime.now().isAfter(term.startTime) &&
//          DateTime.now().isBefore(term.endTime)) {
//        this.currentTerm = term;
//      }
//    }
//  }
//
//  Future<void> updateAllTerms() async {
//    allTerms = await database.getTerms();
//  }
//
//  /// Helper function for deselcting a day
//  /// Removes a day from list of repeated days for this class
//  /// The day to remove is the index of the day + 1 since enums start from 0
//  void deselectDay(Day day) {
//    setState(() {
//      daysOfEvent.remove(day.index + 1);
//    });
//  }
//
//  /// Creates a Column object that contains a label for the day to be selected
//  /// and a check box for that day
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
//          },
//        ),
//      ],
//    );
//  }
//
//  /// Shows time picker dialog and returns the time chosen
//  Future<Null> _selectTime(bool isStart, BuildContext context) async {
//    // Hide keyboard before showing time picker
//    FocusScope.of(context).requestFocus(FocusNode());
//
//    // Add delay to be sure keyboard is no longer visible
//    await Future.delayed(Duration(milliseconds: 200));
//
//    final TimeOfDay picked = await showTimePicker(
//      context: context,
//      initialTime: isStart
//          ? startTime != null
//              ? TimeOfDay(hour: startTime.hour, minute: startTime.minute)
//              : TimeOfDay.now()
//          : endTime != null
//              ? TimeOfDay(hour: endTime.hour, minute: endTime.minute)
//              : TimeOfDay.now(),
//    );
//
//    if (picked != null) {
//      print("Date selected: ${picked.toString()}");
//      setState(() {
//        isStart
//            ? startTime = DateTime(2018, 1, 1, picked.hour, picked.minute)
//            : endTime = DateTime(2018, 1, 1, picked.hour, picked.minute);
//        print(isStart ? startTime.toString() : endTime.toString());
//      });
//    }
//  }
//
//  /// Returns the list of subjects from the academic term
//  ListTile _itemInListOfSubjects(String subjectName) {
//      return ListTile(
//        title: Text(subjectName),
//        onLongPress: () {
//          showDialog(
//              context: context,
//              builder: (BuildContext context) {
//                return SimpleDialog(
//                    title:
//                    Text("Are you sure you want to delete " + subjectName),
//                    children: <Widget>[
//                      Row(
//                        crossAxisAlignment: CrossAxisAlignment.center,
//                        mainAxisAlignment: MainAxisAlignment.center,
//                        children: <Widget>[
//                          RaisedButton(
//                            color: Colors.white,
//                            child: Text("Yes"),
//                            onPressed: () {
//                              setState(() {
//                                allTerms.subjects.remove(subjectName);
//                                Navigator.of(context).pop();
//                                Navigator.of(context).pop();
//                                //TODO: removed subject now update that in firestore
//                                database.updateDatabase();
//                              });
//                            },
//                          ),
//                          RaisedButton(
//                            color: Colors.white,
//                            child: Text("Cancel"),
//                            onPressed: () {
//                              Navigator.of(context).pop();
//                            },
//                          )
//                        ],
//                      )
//                    ]);
//              });
//        },
//        onTap: () {
//          setState(() {
//            _subjectController.text = subjectName;
//          });
//          Navigator.pop(context);
//        },
//      );
//  }
//
//  /// Shows dialog window to select a subject
//  void _showSubjectSelectionDialog() {
//    FirebaseUser user = Provider.of<FirebaseUser>(context);
//    List<Widget> subjects = List();
//    ListTile addSubject = ListTile(
//        onTap: () {
//          showDialog(
//              context: context,
//              builder: (BuildContext context) {
//                return SimpleDialog(
//                  title: Text("Enter New Subject Name"),
//                  children: <Widget>[
//                    TextFormField(
//                      style: Theme
//                          .of(context)
//                          .accentTextTheme
//                          .body1,
//                      decoration: InputDecoration(
//                        hintText: "Subject e.g. CS",
//                        hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
//                        contentPadding:
//                        EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
//                      ),
//                      onFieldSubmitted: (val) {
//                        print(val);
//                        setState(() {
//                          database.addSubject(val);
//                        });
//                        Navigator.pop(context);
//                      },
//                      textInputAction: TextInputAction.done,
//                    ),
//                  ],
//                );
//              });
//        },
//        title: Text("Add subject"));
//
//    showDialog(
//        context: context,
//        builder: (BuildContext context) {
//          return StreamBuilder<QuerySnapshot> (
//            stream: Firestore.instance.collection("subjects").where('user_id', isEqualTo: user.uid).snapshots(),
//            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//              subjects.clear();
//              if(snapshot.data != null) {
//                print("Snapshot data: " +
//                    snapshot.data.documents.length.toString());
//                snapshot.data.documents.forEach((document) =>
//                    subjects.add(
//                        _itemInListOfSubjects(document['subject_name'])));
//              }
//              subjects.add(addSubject);
//              return SimpleDialog(
//              title: Text("Choose a subject"), children: subjects);
//            }
//          );
//        });
//  }
//
//  /// Returns [ListTile] containing a subject
//  ListTile selectSubjectTile() {
//    return ListTile(
//      leading: Icon(Icons.chevron_right),
//      title: _subjectController.text.isNotEmpty
//          ? Text(
//              "Subject: " + _subjectController.text,
//              style: Theme.of(context).accentTextTheme.body1,
//            )
//          : Text(
//              "Choose a subject",
//              style: Theme.of(context).accentTextTheme.body1,
//            ),
//      onTap: () async {
//        _showSubjectSelectionDialog();
//      },
//    );
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    FirebaseUser user = Provider.of<FirebaseUser>(context);
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("Add New Class"),
//        backgroundColor: Theme.of(context).primaryColorDark,
//        actions: <Widget>[
//          IconButton(
//            icon: Icon(Icons.check),
//            onPressed: () {
//              updateCurrentTerm();
//              if(_subjectController.text != null || _courseNumberController.text != null || _courseTitleController.text != null
//              || _unitCountController.text != null || _locationController.text != null || _instructorController.text != null ||
//              _officeLocationController.text != null || _descriptionController.text != null || daysOfEvent.isNotEmpty ||
//              startTime != null || endTime != null)
//                {
//                  database.addClass(user, _subjectController.text,
//                      _courseNumberController.text, _courseTitleController.text,
//                      int.parse(_unitCountController.text),  _locationController.text,
//                      _instructorController.text, _officeLocationController.text,
//                      _descriptionController.text, daysOfEvent, startTime, endTime, decToHexa(pickerColor.value),widget.term);
//                  Navigator.of(context).pop();
//                }
//              else
//                {
//                  //TODO: handle alert for unfilled form
//                }
//
//            },
//          ),
//        ],
//      ),
//      body: Stepper(
//        currentStep: this.currentStep,
//        steps: getSteps(),
//        type: StepperType.vertical,
//        onStepTapped: (step) {
//          setState(() {
//            currentStep = step;
//          });
//        },
//        onStepCancel: () {
//          setState(() {
//            if (currentStep > 0) {
//              currentStep--;
//            } else {
//              currentStep = 0;
//            }
//          });
//        },
//        onStepContinue: () {
//          setState(() {
//            //Should be on the last step
//            if (currentStep < getSteps().length - 1) {
//              currentStep++;
//            } else {
//              database.addClass(user, _subjectController.text,
//                  _courseNumberController.text, _courseTitleController.text,
//                  int.parse(_unitCountController.text),  _locationController.text,
//                  _instructorController.text, _officeLocationController.text,
//                  _descriptionController.text, daysOfEvent, startTime, endTime, decToHexa(pickerColor.value), widget.term);
//              Navigator.of(context).pop();
//            }
//          });
//        },
//      ),
//    );
//  }
//}