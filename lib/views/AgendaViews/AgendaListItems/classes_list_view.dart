import 'package:cognito/models/class.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../HexColor.dart';

class ClassesListView extends StatefulWidget {

  final DateTime selectedDate;

  const ClassesListView(this.selectedDate);

  @override
  _ClassesListViewState createState() => _ClassesListViewState();
}

class _ClassesListViewState extends State<ClassesListView> {
  @override
  Widget build(BuildContext context) {
    final classes = Provider.of<List<Class>>(context);
    //get classes for the day of the week
    List<Class> classesToday = getClassesOfToday(classes);
    return Container(
      child: classesToday == null || classesToday.length == 0 ?
        Text(
            "There are no classes currently",
            style: Theme.of(context).primaryTextTheme.bodyText2
        ) : ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: classesToday.length,
          itemBuilder: (context, i) {

            return getCard(classesToday[i]);
          }
      )
    );
 }

 HexColor getColor(String colorCode)
 {
   String code = colorCode.substring(9, colorCode.length - 1);
   return HexColor(code);
 }

 Container getCard(Class c)
 {
   return Container(
       decoration: BoxDecoration(
           color: c.returnColor(),
           borderRadius: BorderRadius.all(Radius.circular(20)),
           boxShadow: [BoxShadow(
               color: Colors.grey,
               blurRadius: 2.0,
               spreadRadius: 0.0,
               offset: Offset(2.0, 2.0)
           )]
       ),
       child: Container(
         width: 200,
         padding: EdgeInsets.all(15),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Text(
               c.title,
               textAlign: TextAlign.left,
               overflow: TextOverflow.fade,
               softWrap: false,
               style: Theme.of(context).primaryTextTheme.headline3,
             ),
             Row(
               children: [
                 Icon(
                     Icons.access_time, color: Theme.of(context).backgroundColor,
                 ),
                 Padding(padding: EdgeInsets.all(5),),
                 getTextWidgetTimeFormat(c)
               ],
             )
           ],
         )
       ),
     );
 }

  getTextWidgetTimeFormat(Class c) {
    return Text(
      "${DateFormat('h:mma').format(c.startTime)} - ${DateFormat('h:mma').format(c.endTime)}",
      overflow: TextOverflow.fade,
      softWrap: false,
      style: Theme.of(context).primaryTextTheme.headline4,
    );
  }

  List<Class> getClassesOfToday(List<Class> classes) {
      List<Class> todayClasses = new List();
      if(classes == null) return todayClasses;
      for(Class c in classes)
        {
          int dayNumber = 0;
          switch(DateFormat('EEEE').format(widget.selectedDate).toLowerCase())
          {
            case "monday": dayNumber = 0; break;
            case "tuesday" : dayNumber = 1; break;
            case "wednesday" : dayNumber = 2; break;
            case "thursday" : dayNumber = 3; break;
            case "friday" : dayNumber = 4; break;
            case "saturday" : dayNumber = 5; break;
            case "sunday" : dayNumber = 6; break;
          }
          if(c.daysOfEvent.contains(dayNumber)) todayClasses.add(c);
        }
      return todayClasses;
  }
}
