import 'package:flutter/material.dart';
import '../PriorityAgenda/priority_utils/item_edit_form.dart';
import '../../../models/Items/item.dart';

class EditItemPage extends StatelessWidget {

  final Item item;

  EditItemPage(this.item);

  @override
  Widget build(BuildContext context) {

    final String editTitle = "Edit Form Title";

    return Scaffold(
        appBar: AppBar(
            title: Text(editTitle)
        ),
        body: EditItemForm(item)
    );
  }
}