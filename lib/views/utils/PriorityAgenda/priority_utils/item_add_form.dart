import 'package:flutter/material.dart';
import '../../../../models/Items/item.dart';
import '../priority.dart';
import '../../../../models/Items/items_list.dart';

class AddItemForm extends StatefulWidget {

  final ItemsList _items;

  AddItemForm(this._items);

  @override
  State<StatefulWidget> createState() => AddItemFormState();
}

class AddItemFormState extends State<AddItemForm> {

  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  int _radioValue = -1;

  void _handleRadioValueChange1(int value) {
    setState(() {
      _radioValue = value;
    });
  }

  @override void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Builder(
            builder: (context) => Form(
              key: _formKey,
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Task Name'),
                      controller: nameController,
                      validator: (value) {
                        if(value.isEmpty)
                        {
                          return 'Please enter a Task Name';
                        }
                      },
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Task Description'),
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      controller: descriptionController,
                    ),
                    new Padding(
                      padding: new EdgeInsets.all(8.0),
                    ),
                    new Padding(
                      padding: new EdgeInsets.all(8.0),
                    ),
                    Text(
                      'Priority :',
                      style: new TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Radio(
                            value: 0,
                            groupValue: _radioValue,
                            onChanged: _handleRadioValueChange1,
                          ),
                          Text('Discretionary',
                            style: new TextStyle(fontSize: 16.0),
                          ),

                          Radio(
                            value: 1,
                            groupValue: _radioValue,
                            onChanged: _handleRadioValueChange1,
                          ),
                          Text('Routine',
                            style: new TextStyle(fontSize: 16.0),
                          ),

                          Radio(
                            value: 2,
                            groupValue: _radioValue,
                            onChanged: _handleRadioValueChange1,
                          ),
                          Text('Urgent', style: new TextStyle(fontSize: 16.0),
                          ),
                        ]
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: RaisedButton(
                          onPressed: () {
                            Item item = Item(nameController.text, valueOf(_radioValue), descriptionController.text, 0.0);
                            widget._items.addItem(item);
                            print(item.name);
                            print(item.completion);
                            print(item.description);
                            Navigator.of(context).pop();
                          },
                          child: Text("Submit")
                      ),
                    )
                  ]
              ),
            )
        )
    );
  }
}