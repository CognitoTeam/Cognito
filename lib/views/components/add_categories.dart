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

class _AddCategoriesState extends State<AddCategories> {

  TextEditingController categoryNameController = new TextEditingController();
  TextEditingController categoryPercentController = new TextEditingController();
  List<Category> categories = new List<Category>();
  List<Widget> categoriesWidget = new List<Widget>();
  double percentageSum = 0.0;

  @override
  void initState() {
    super.initState();
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
            children: categoriesWidget ?? [Container()]
        ),
        width: 225,
      );
  }

  void updateCategory()
  {
    categoriesWidget.clear();
    setState(() {
      for(Category cat in categories)
        {
            print("Trying to add");
            categoriesWidget.add(Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Container(
                    child: Text(
                      "${cat.title}",
                      style: Theme.of(context).primaryTextTheme.headline5,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "${cat.weightInPercentage}%",
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
                        deleteCategory(cat);
                      },
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(0),
                    ),],
                ),
              ],
            )
            );
            categoriesWidget.add(Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 0),));
          }
        }
      );
  }

  void deleteCategory(Category category)
  {
    setState(() {
      for(Category c in categories)
        {
          if(c.title.toLowerCase() == category.title.toLowerCase())
            {
              percentageSum -= c.weightInPercentage;
              categories.remove(c);
            }
        }
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
    Widget okButton = new FlatButton(
      child: new Text("Ok"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog invalidCategoryAlert = AlertDialog(
      title: Text("The category information is invalid"),
      content: Text("Make sure name field is not empty and percentage is in range 1 - 100"),
      actions: [
        okButton,
      ],
    );

    AlertDialog overflowAlert = AlertDialog(
      title: Text("Categories would add up to above 100%"),
      content: Text("Consider inputted category values"),
      actions: [
        okButton,
      ],
    );

    AlertDialog invalidNameAlert = AlertDialog(
      title: new Text("Category name already in use"),
      content: new Text("Please check your added categories"),
      actions: <Widget>[
        okButton
      ],
    );

    Category newCategory = new Category(title: categoryNameController.text, weightInPercentage: double.parse(categoryPercentController.text));
    if(containsCategory(newCategory))
      {
        showDialog(
            context: context,
            builder: (BuildContext) {
              return invalidNameAlert;
            }
        );
      }
    else if(percentageSum + double.parse(categoryPercentController.text) > 100)
      {
        showDialog(
            context: context,
            builder: (BuildContext) {
              return overflowAlert;
            }
        );
      }
    else if(categoryNameController.text == "" || double.parse(categoryPercentController.text) < 0 || double.parse(categoryPercentController.text) > 100)
    {
      showDialog(
        context: context,
        builder: (BuildContext) {
          return invalidCategoryAlert;
        }
      );
    }
    else {
      //Meets the requirements for a new category
      percentageSum += double.parse(categoryPercentController.text);
      categoryNameController.clear();
      categoryPercentController.clear();
      categories.add(newCategory);
      updateCategory();
    }
  }

  bool containsCategory(Category category)
  {
    for(Category c in categories)
      {
        if(c.title.toLowerCase() == category.title.toLowerCase())
          {
            return true;
          }
      }
    return false;
  }
}

