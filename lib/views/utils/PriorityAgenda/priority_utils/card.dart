import 'package:flutter/material.dart';
import '../../../../models/Items/item.dart';
import '../priority.dart';
import '../item_edit_page.dart';
import '../../../../models/event.dart';

class CardBox extends StatefulWidget {

  final Event _item;

  CardBox(this._item);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new CardBoxState();
  }
}

class CardBoxState extends State<CardBox> {

  @override
  Widget build(BuildContext context) {
    return new ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        leading: Container(
          padding: EdgeInsets.only(right: 5.0),
          decoration: new BoxDecoration(
              border: new Border(
                  right: new BorderSide(width: 1, color: Colors.white24)
              )
          ),
          child: IconButton(
              icon: Icon(Icons.edit, color: Colors.white, size: 20,),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => EditItemPage(widget._item)));
              }),
        ),
        title: Row(
          children: <Widget>[
            Text(
              widget._item.title + '  -',
              style: Theme.of(context).accentTextTheme.body2,
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  widget._item.priority.toString(),
                  style: TextStyle(
                      color: getPriorityColor(widget._item.priority),
                      fontSize: 12.0
                  ),
                ),
              ),
            )
          ],
        ),
        subtitle: Row(
          children: <Widget>[
//            Text(
//              "Status :" + (widget._item.completion * 100).toString() + "%",
//              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//            ),
            Slider(
              value: 0,//widget._item.comp,
              label: 'Status: ${0/*widget._item.completion*100*/}%',
              onChanged: (value){
                setState(() {
                  //widget._item.completion = value;
                });
              },
              activeColor: Color.fromRGBO(0, 0, 255, 1),
              inactiveColor: Colors.white,
              divisions: 10,
            )
          ],
        ),

        trailing:
        Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 20.0),
        onTap: () {
          print("Pushed the detailed page");
        }
    );
  }
  Color getPriorityColor(int priority) {
    switch (priority) {
      case 3:
        {
          return Colors.red[100];
        }
        break;
      case 2:
        {
          return Colors.yellow[100];
        }
        break;
      case 1:
        {
          return Colors.green[100];
        }
        break;
      default:
        {
          return Colors.white;
        }
    }
  }
}