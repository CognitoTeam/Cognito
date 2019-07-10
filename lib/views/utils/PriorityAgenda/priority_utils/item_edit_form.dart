import 'package:flutter/material.dart';
import '../../../../models/Items/item.dart';
import '../priority.dart';

class EditItemForm extends StatefulWidget {

  final Item _item;

  EditItemForm(this._item);

  @override
  State<StatefulWidget> createState() => EditItemFormState();
}

class EditItemFormState extends State<EditItemForm> {

  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController;
  TextEditingController descriptionController;
  int _radioValue = -1;

  @override
  void initState()
  {
    super.initState();
    nameController = new TextEditingController();
    descriptionController = new TextEditingController();
    _radioValue = intValue(widget._item.priority);
    nameController.text = widget._item.name.toString();
    descriptionController.text = widget._item.description.toString();
  }

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
                      controller: descriptionController..text = widget._item.description.toString(),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                          child: RaisedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.clear),
                                  Text("Cancel")
                                ],
                              )
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                          child: RaisedButton(
                              onPressed: () {
                                widget._item.name = nameController.text;
                                widget._item.description = descriptionController.text;
                                widget._item.priority = valueOf(_radioValue);
                                Navigator.of(context).pop();
                              },
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.edit),
                                  Text("Edit")
                                ],
                              )
                          ),
                        )
                      ],
                    )
                  ]
              ),
            )
        )
    );
  }
}