// Copyright 2019 UniPlan. All rights reserved
import 'package:cognito/database/database.dart';
import 'package:cognito/models/academic_term.dart';
import 'package:cognito/models/category.dart';
import 'package:cognito/models/class.dart';
import 'package:cognito/views/components/add_categories.dart';
import 'package:cognito/views/components/days_checkbox.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cognito/views/components/block_picker.dart';
import 'package:provider/provider.dart';
import 'components/select_time.dart';

enum Day { M, Tu, W, Th, F, Sat, Sun }

/// Class editing view
/// [author] Julian Vu
class ClassEditingView extends StatefulWidget {
  // Underlying class object
  final Class classObj;

  ClassEditingView({Key key, @required this.classObj}) : super(key: key);

  @override
  _ClassEditingViewState createState() => _ClassEditingViewState();
}

class _ClassEditingViewState extends State<ClassEditingView> with SingleTickerProviderStateMixin{
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
  SelectTime classStart = SelectTime(title: "Start Time",);
  SelectTime classEnd = SelectTime(title: "End Time",);
  List<int> daysRepeated = List();
  TextEditingController instructorController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController classLocationController = TextEditingController();
  TextEditingController officeLocationController = TextEditingController();
  SelectTime officeStart = SelectTime(title: "",);
  SelectTime officeEnd = SelectTime(title: "",);
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
              officeLocationController.text, descriptionController.text, daysRepeated, classStart.selectedDate, classEnd.selectedDate, officeDaysRepeated, officeStart.selectedDate, officeEnd.selectedDate, currentColor.value, null);},
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
