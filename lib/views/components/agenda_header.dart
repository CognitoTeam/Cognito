import 'package:cognito/views/calendar_view.dart';
import 'package:cognito/views/main_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class AgendaHeader extends StatelessWidget {

  final DateTime selectedDate;
  final CalendarView calendarView;
  const AgendaHeader({Key key, this.selectedDate, this.calendarView}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 236.0,
      color: Theme.of(context).backgroundColor,
      child: new Container(
          decoration: new BoxDecoration(
              color: Theme.of(context).primaryColorDark,
              borderRadius: new BorderRadius.only(
                bottomLeft: const Radius.circular(40.0),
                bottomRight: const Radius.circular(40.0),
              )
          ),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(17, 125, 0, 0),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            DateFormat.MMMMEEEEd().format(selectedDate),
                            style: Theme.of(context).primaryTextTheme.body1,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 25, 15, 15),
                    alignment: Alignment.topCenter,
                    child: CircularPercentIndicator(
                      radius: 90.0,
                      lineWidth: 10.0,
                      percent: 0.75,
                      center: Text(
                          "75%",
                          style: Theme.of(context).primaryTextTheme.body1),
                      progressColor: Color(0xFF33D9B2),
                      circularStrokeCap: CircularStrokeCap.round,
                      backgroundColor: Theme.of(context).backgroundColor,
                    ),
                  )
                ],
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: calendarView
              )
            ],
          )

      )
    );
  }
}
