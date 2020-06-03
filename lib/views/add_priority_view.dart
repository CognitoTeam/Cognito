import 'package:flutter/material.dart';

class AddPriorityDialog extends StatefulWidget {
  final int priority;
  AddPriorityDialog(this.priority);
  @override
  _AddPriorityDialogState createState() => _AddPriorityDialogState();
}

class _AddPriorityDialogState extends State<AddPriorityDialog> {
  double _prioritySelected;
  int result;
  @override
  void initState() {
    super.initState();
    _prioritySelected = widget.priority.toDouble();
  }
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text("Select the priority"),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 42.0, left: 10, right: 10),
          child: SliderTheme(
            data: SliderThemeData.fromPrimaryColors(
                primaryColor: Theme.of(context).primaryColor,
                primaryColorDark: Theme.of(context).primaryColorDark,
                primaryColorLight: Theme.of(context).primaryColorLight,
                valueIndicatorTextStyle:
                    Theme.of(context).primaryTextTheme.bodyText1),
            child: Slider(
              value: _prioritySelected,
              max: 3.0,
              min: 1.0,
              divisions: 2,
              label: '${_prioritySelected.round()}',
              onChanged: (double value) {
                setState(() {
                  _prioritySelected = value;
                });
              },
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FlatButton(
                onPressed: () {
                  setState(() {
                    Navigator.of(context).pop();
                  });
                },
                child: Text("Cancel")),
            FlatButton(
                onPressed: () {
                  setState(() {
                    result = _prioritySelected.toInt();
                    Navigator.of(context).pop(result);
                  });
                },
                child: Text("Confirm"))
          ],
        )
      ],
    );
  }
}
