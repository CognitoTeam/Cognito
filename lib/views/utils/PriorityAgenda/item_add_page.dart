import 'package:flutter/material.dart';
import '../../../models/Items/items_list.dart';
import '../PriorityAgenda/priority_utils/item_add_form.dart';

class AddItemPage extends StatelessWidget {

  final ItemsList items;

  AddItemPage(this.items);

  @override
  Widget build(BuildContext context) {

    final String addTitle = "Add Form Title";

    return Scaffold(
        appBar: AppBar(
            title: Text(addTitle)
        ),
        body: AddItemForm(items)
    );
  }
}