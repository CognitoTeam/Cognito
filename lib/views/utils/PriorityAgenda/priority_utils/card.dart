import 'package:flutter/material.dart';
import '../../../../models/Items/item.dart';
import '../item_edit_page.dart';
import '../../../../models/Items/items_list.dart';

class CardBox extends StatefulWidget {

  final Item _item;
  final ItemsList _list;

  CardBox(this._item, this._list);

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
              widget._item.name + '  -',
              style: Theme.of(context).accentTextTheme.body2,
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  super.widget._item.getPriorityString(),
                  style: TextStyle(
                      color: widget._item.getPriorityColor(),
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
              value: widget._item.completion,
              label: 'Status: ${widget._item.completion*100}%',
              onChanged: (value){
                setState(() {
                  widget._item.completion = value;
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
}