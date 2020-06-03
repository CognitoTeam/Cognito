import 'package:flutter/material.dart';

class AddCategories extends StatefulWidget {
  @override
  _AddCategoriesState createState() => _AddCategoriesState();
}

class _AddCategoriesState extends State<AddCategories> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Categories",
          style: Theme.of(context).primaryTextTheme.subhead,
        ),
        createCategories()
      ],
    );
  }

  Widget createCategories()
  {
    return Row(

    );
  }
}

