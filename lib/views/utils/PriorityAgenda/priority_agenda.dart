import 'package:flutter/material.dart';
import 'package:cognito/models/task.dart';
import 'package:cognito/models/class.dart';
import 'package:cognito/models/event.dart';
import 'package:cognito/models/assignment.dart';
import '../../../models/Items/items_list.dart';
import 'package:cognito/database/database.dart';
import '../PriorityAgenda/priority_utils/card.dart';
import 'item_add_page.dart';
import '../../../models/event_list.dart';
import 'package:cognito/models/academic_term.dart';

class PriorityAgenda extends StatefulWidget {

  final String title;
  DataBase database = DataBase();
  AcademicTerm term;

  PriorityAgenda(this.title);

  AcademicTerm getCurrentTerm() {
    for (AcademicTerm term in database.allTerms.terms) {
      if (DateTime.now().isAfter(term.startTime) &&
          DateTime.now().isBefore(term.endTime)) {
        this.term = term;
        print("Hello world" + term.classes[0].title);
        return term;
      }
    }
    return null;
  }

  @override
  _PriorityAgendaState createState() => new _PriorityAgendaState(getCurrentTerm());
}

class _PriorityAgendaState extends State<PriorityAgenda> {

  final AcademicTerm term;
  EventList itemsList;
  List items;

  _PriorityAgendaState(this.term);

  @override
  void initState() {
    super.initState();
    itemsList = new EventList();

    for(Class c in term.classes)
    {
      for(Assignment i in c.assignments)
        {
          itemsList.addEvent(i);
        }
      for(Assignment i in c.assessments)
      {
        itemsList.addEvent(i);
      }
    }
    for(Event i in term.events)
      {
        itemsList.addEvent(i);
      }
    for(Task i in term.tasks)
      {
        itemsList.addEvent(i);
      }
    items = itemsList.getItems();
  }

  @override
  void didUpdateWidget(PriorityAgenda oldWidget)
  {
    super.didUpdateWidget(oldWidget);
    items = itemsList.getItems();
  }

  @override
  Widget build(BuildContext context) {

    final itemBody = Container(
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
//              shape: RoundedRectangleBorder(
//                side: BorderSide(
//                  width: 1.0
//                )
//              ),
                elevation: 8,
                margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                child: Container(
                    decoration: BoxDecoration(color: Colors.blueAccent),
                    child: new CardBox(items[index])
                )
            );
          }
      ),
    );

//    final bottomBar = Container(
//      height: 75,
//      child: BottomAppBar(
//        color: Colors.blueGrey[300],
//        child: Row(
//          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//          children: <Widget>[
//            IconButton(
//              icon: Icon(Icons.add, color: Colors.white),
//              onPressed: () { Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddItemPage(itemsList)));},
//            )
//          ],
//        ),
//      ),
//    );

    return Scaffold(
      backgroundColor: Colors.white24,
      body: itemBody,
      //bottomNavigationBar: bottomBar,
    );
  }
}