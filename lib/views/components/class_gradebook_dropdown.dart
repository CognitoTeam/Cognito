import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ClassGradebookDropDown extends StatefulWidget {

  ClassGradebookDropDown({Key key}) : super(key: key);

  @override
  _ClassGradebookDropDownState createState() => _ClassGradebookDropDownState();
}

class _ClassGradebookDropDownState extends State<ClassGradebookDropDown> {

  String dropdownValue = 'Class One';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: Icon(
        Icons.keyboard_arrow_down,
        color: Colors.black,
      ),
      iconSize: 24,
      elevation: 0,
      style: GoogleFonts.poppins(
        color: Colors.black,
        fontSize: 15,
      ),
      underline: Container(
        height: 2,
        color: Colors.black,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: <String>['Class One', 'Class Two', 'Class Three', 'Class Four']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
