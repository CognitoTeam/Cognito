import 'package:cognito/models/category.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryDropdown extends StatefulWidget {

  String dropdownValue = 'Class One';
  List<Category> categories;

  CategoryDropdown(this.categories);
  
  @override
  _CategoryDropdownState createState() => _CategoryDropdownState();
}

class _CategoryDropdownState extends State<CategoryDropdown> {

  @override
  void initState() {
    //TODO: Make this usable
    if(widget.categories.isEmpty)
      {
        widget.categories = [
          new Category(
            title: "Class One",
            weightInPercentage: 0
          )
        ];
      }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: widget.dropdownValue,
      icon: Icon(
        Icons.keyboard_arrow_down,
        color: Theme.of(context).colorScheme.secondaryVariant,
      ),
      iconSize: 24,
      elevation: 0,
      style: Theme.of(context).primaryTextTheme.subtitle1,
      underline: Container(
        height: 1,
        color: Theme.of(context).colorScheme.secondaryVariant,
      ),
      onChanged: (String newValue) {
        setState(() {
          widget.dropdownValue = newValue;
        });
      },
      items: widget.categories.map((e) => e.title)
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
