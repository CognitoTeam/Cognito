import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SelectDate extends StatefulWidget {
  DateTime selectedDate = DateTime.now();
  final ValueChanged<DateTime> onDateSelected;

  SelectDate({this.onDateSelected});

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
            Row(
              children: [
                Text(
                  getDateTimeString(widget.selectedDate),
                  style: Theme.of(context).primaryTextTheme.subtitle1,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: RawMaterialButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    constraints: BoxConstraints.tight(Size(25, 25)),
                    elevation: 5,
                    fillColor: Theme.of(context).colorScheme.secondary,
                    child: Icon(
                      Icons.calendar_today,
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

  String getDateTimeString(DateTime dateTime)
  {
    const monthNames = ["January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    int day = dateTime.day;
    return DateFormat('EEEE').format(dateTime) + ', $day ' +  monthNames[dateTime.month];
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: widget.selectedDate != null
            ? DateTime(widget.selectedDate.year, widget.selectedDate.month, widget.selectedDate.day)
            : DateTime.now(),
        firstDate: DateTime(1990),
        lastDate: DateTime(3000));

    if (picked != null) {
      setState(() {
        widget.selectedDate = picked;
        widget.onDateSelected(widget.selectedDate);
      });
    }
  }
}
