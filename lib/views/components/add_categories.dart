import 'package:cognito/models/category.dart';
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
  int id;
  static int nextId = 0;
  TempCategory(this.name, this.percent){
    id = nextId++;
  }
}

class _AddCategoriesState extends State<AddCategories> {

  double percentage = 1.0;
  TextEditingController categoryNameController = new TextEditingController();
  TextEditingController categoryPercentController = new TextEditingController();
  List<TempCategory> addedCategories = new List<TempCategory>();
  List<Widget> categories = new List<Widget>();
  double percentageSum = 0.0;
  bool _categoryValueOverflow = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    TempCategory.nextId = 0;
  }


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
              percent: percentageSum/100,
              center: Text(
                  "$percentageSum%",
                  style: Theme.of(context).primaryTextTheme.subtitle2),
              progressColor: Color(0xFF33D9B2),
              circularStrokeCap: CircularStrokeCap.round,
              backgroundColor: Theme.of(context).backgroundColor,
            ),
          ],
        ),
        addCategoryWidget()
      ],
    );
  }

  Widget listCategories()
  {
      return Container(
        child: Column(
            children: categories ?? [Container()]
        ),
        width: 225,
      );
  }

  void updateCategory()
  {
    setState(() {
      for(TempCategory tc in addedCategories)
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
                      onPressed: () {
                        deleteCategory(tc.id);
                      },
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(0),
                    ),],
                ),
              ],
            )
            );
            categories.add(Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 0),));
          }
        }
      );
  }

  void deleteCategory(int id)
  {
    print("delete" + id.toString());
    setState(() {
      for(int i = 0; i < addedCategories.length; i++)
        {
          TempCategory tc = addedCategories[i];
          if(tc.id == id)
            {
              percentageSum -= tc.percent;
              addedCategories.removeAt(i);
            }
        }
      categories.clear();
      updateCategory();
    });
  }

  Widget addCategoryWidget()
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
                  errorText: _categoryValueOverflow ? "Value over 100%" : null,
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
                  errorText: _categoryValueOverflow ? "" : null,
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
            onPressed: addCategory,
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

  void addCategory()
  {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () { },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Categories would add up to above 100%"),
      content: Text("Consider inputted category values"),
      actions: [
        okButton,
      ],
    );

    AlertDialog(
      title: new Text("Category name already in use"),
      content: new Text("Please check your added categories"),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        new FlatButton(
          child: new Text("Close"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );

    for(TempCategory c in addedCategories)
      {
//        if(categoryNameController.text == c.name)
//          {
//            showDialog(
//                context: context,
//                builder: (BuildContext cotext)
//            {
//              return AlertDialog
//            });
//          }
      }
    addedCategories.add(new TempCategory(categoryNameController.text, double.parse(categoryPercentController.text)));
    if(percentageSum + double.parse(categoryPercentController.text) > 100)
      {
        setState(() {
          _categoryValueOverflow = true;
        });
      }
    else if(categoryNameController.text == "" || double.parse(categoryPercentController.text) < 0)
    {
      //TODO figure out error handling
    }
    else {
      percentageSum += double.parse(categoryPercentController.text);
      categories.clear();
      categoryNameController.clear();
      categoryPercentController.clear();
      updateCategory();
    }
  }
}

