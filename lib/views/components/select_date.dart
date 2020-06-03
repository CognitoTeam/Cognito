import 'package:flutter/material.dart';

class SelectDate extends StatefulWidget {
  SelectDate({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SelectDateState createState() => _SelectDateState();
}

class _SelectDateState extends State<SelectDate> {

  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    DefaultMaterialLocalizations dml = new DefaultMaterialLocalizations();
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        children: [
          widget.title != "" ?
          Container(
            padding: EdgeInsets.all(0),
            alignment: Alignment.centerLeft,
            child: Text(
              widget.title,
              style: Theme.of(context).primaryTextTheme.subtitle,
            ),
          ): Container(color: Colors.black,),
          Row(
              children: [
                Text(
                  dml.formatTimeOfDay(selectedTime, alwaysUse24HourFormat: false),
                  style: Theme.of(context).primaryTextTheme.subhead,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: RawMaterialButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    constraints: BoxConstraints.tight(Size(25, 25)),
                    elevation: 5,
                    fillColor: Theme.of(context).colorScheme.secondary,
                    child: Icon(
                      Icons.access_time,
                      color: Theme.of(context).backgroundColor,
                      size: 20,
                    ),
                    onPressed: () {_selectDate(context);},
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(0),
                  ),
                )
              ],
          )
        ],
      )
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: selectedTime,
    );
    if(picked != null && picked != selectedTime)
      setState(() {
        selectedTime = picked;
      });
  }
}
