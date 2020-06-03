import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class AddCategories extends StatefulWidget {

  final FocusNode focusNodeCategoryName;
  final FocusNode focusNodeCategoryPercent;

  AddCategories(this.focusNodeCategoryName, this.focusNodeCategoryPercent);

  @override
  _AddCategoriesState createState() => _AddCategoriesState();
}

class TempCategory {
  String name;
  double percent;
  TempCategory(this.name, this.percent);
}

class _AddCategoriesState extends State<AddCategories> {

  double percentage = 1.0;
  TextEditingController categoryNameController;
  TextEditingController categoryPercentController;
  List<TempCategory> addedCategories = new List<TempCategory>();
  List<Widget> categories = new List<Widget>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Categories",
          style: Theme.of(context).primaryTextTheme.subtitle2,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            listCategories(),
            CircularPercentIndicator(
              radius: 60.0,
              lineWidth: 6.0,
              percent: percentage,
              center: Text(
                  "${percentage * 100}%",
                  style: Theme.of(context).primaryTextTheme.subtitle2),
              progressColor: Color(0xFF33D9B2),
              circularStrokeCap: CircularStrokeCap.round,
              backgroundColor: Theme.of(context).backgroundColor,
            ),
          ],
        ),
        addCategory()
      ],
    );
  }

  Widget listCategories()
  {
      return Container(
        child: Column(
            children: categories
        ),
        width: 225,
      );
  }

  List<Widget> categoriesWidgets(TempCategory tc)
  {
    categories.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Container(
                child: Text(
                  "${tc.name}",
                  style: Theme.of(context).primaryTextTheme.headline5,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
            Row(
              children: [
                Text(
                  "${tc.percent}%",
                  style: Theme.of(context).primaryTextTheme.headline5,
                ),
                SizedBox(width: 10),
                RawMaterialButton(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  constraints: BoxConstraints.tight(Size(20, 20)),
                  elevation: 5,
                  fillColor: Theme.of(context).colorScheme.onError,
                  child: Icon(
                    Icons.remove,
                    color: Theme.of(context).backgroundColor,
                    size: 15,
                  ),
                  onPressed: () {},
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(0),
                ),],
            ),
          ],
        )
        );
  }

  Widget addCategory()
  {
      return Row(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 120,
              child: TextField(
                controller: categoryNameController,
                focusNode: widget.focusNodeCategoryName,
                expands: false,
                decoration: InputDecoration(
                  hintText: "ie Homework",
                  contentPadding: EdgeInsets.all(5),
                  isDense: true,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: Theme.of(context).colorScheme.secondaryVariant,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: Theme.of(context).colorScheme.secondaryVariant,
                      )
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 15,),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 70,
              child: TextField(
                controller: categoryPercentController,
                focusNode: widget.focusNodeCategoryPercent,
                textAlign: TextAlign.left,
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly
                ], // Only numbers can be entered
                keyboardType: TextInputType.number,
                expands: false,
                decoration: InputDecoration(
                  hintText: "ie 25",
                  contentPadding: EdgeInsets.all(5),
                  isDense: true,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: Theme.of(context).colorScheme.secondaryVariant,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: Theme.of(context).colorScheme.secondaryVariant,
                      )
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 15,),
          RaisedButton(
            onPressed: () {
              setState() {
                addedCategories.add(new TempCategory(categoryNameController.value.toString(), double.parse(categoryPercentController.value.toString())));
              }
            },
            child: Text(
              "Add Category",
              style: Theme.of(context).primaryTextTheme.button,
            ),
            color: Theme.of(context).colorScheme.onBackground,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
          )
        ],
      );
  }
}

