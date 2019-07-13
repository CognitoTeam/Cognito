import 'package:flutter/material.dart';
import '../../../models/Items/items_list.dart';
import '../PriorityAgenda/priority_utils/card.dart';
import 'item_add_page.dart';
import '../../../models/event_list.dart';

class PriorityAgenda extends StatefulWidget {
  final String title;

  PriorityAgenda(this.title);

  @override
  _PriorityAgendaState createState() => new _PriorityAgendaState();
}

class _PriorityAgendaState extends State<PriorityAgenda> {

  EventList itemsList;
  List items;

  @override
  void initState() {
    super.initState();
    itemsList = new EventList();
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