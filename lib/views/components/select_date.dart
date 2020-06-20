import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SelectDate extends StatefulWidget {
  SelectDate({Key key, this.title}) : super(key: key);

  final String title;
  DateTime selectedDate = DateTime.fromMicrosecondsSinceEpoch(0);

  @override
  _SelectDateState createState() => _SelectDateState();
}

class _SelectDateState extends State<SelectDate> {


  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
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
              style: Theme.of(context).primaryTextTheme.subtitle1,
            ),
          ): Container(color: Colors.black,),
          Row(
              children: [
                Text(
                  DateFormat('h:mma').format(widget.selectedDate),
                  style: Theme.of(context).primaryTextTheme.subtitle2,
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
        widget.selectedDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, selectedTime.hour, selectedTime.minute);
      });
  }
}
