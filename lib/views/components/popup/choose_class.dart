import 'dart:math';

import 'package:cognito/models/class.dart';
import 'package:cognito/views/add_assignment_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ChooseClassDialog extends StatefulWidget {

  final List<Class> classes;

  const ChooseClassDialog(this.classes);

  @override
  _ChooseClassDialogState createState() => _ChooseClassDialogState();
}

class _ChooseClassDialogState extends State<ChooseClassDialog> {
  Color _color = Colors.green;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.fromLTRB(40, 40, 0, 0),
      titleTextStyle: Theme.of(context).primaryTextTheme.headline2,
      title: Text('Choose a Class'),
      content: Container(
        width: double.maxFinite,
        height: 300.0,
        child: ListView(
          padding: EdgeInsets.all(8.0),
          //map List of our data to the ListView
          children: listViewButtons(),
        ),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      actions: <Widget>[
        new FlatButton(
          child: new Text('CANCEL'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }

  List<Widget> listViewButtons()
  {
    List<Widget> buttons = List();
    for(Class c in widget.classes)
      {
        buttons.add(
            ChooseClassButton(c: c)
        );
      }
    return buttons;
  }
}

class ChooseClassButton extends StatefulWidget {

  final Class c;

  const ChooseClassButton({Key key, this.c}) : super(key: key);

  @override
  _ChooseClassButtonState createState() => _ChooseClassButtonState();
}

class _ChooseClassButtonState extends State<ChooseClassButton> {
  Color _backgroundColor;
  Color _secondaryTrim;

  @override
  void initState() {
    _backgroundColor = Colors.transparent;
    _secondaryTrim = Color(widget.c.colorCode);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
//        setState(() {
//          _backgroundColor = _secondaryTrim;
//          _secondaryTrim = Theme.of(context).backgroundColor;
//        });
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AddAssignmentView(widget.c)
                    )
                );
//        setState(() {
//          _backgroundColor = Theme.of(context).backgroundColor;
//          _secondaryTrim = _secondaryTrim;
//        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
        height: 45.0,
        decoration: BoxDecoration(
          color: _backgroundColor,
          border: Border.all(
              color: _secondaryTrim
          ),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        alignment: Alignment.center,
        child: Text(
          widget.c.title,
          style: GoogleFonts.poppins(
              color: _secondaryTrim,
              fontSize: 15
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

