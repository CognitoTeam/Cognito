import 'package:cognito/views/components/class_gradebook_dropdown.dart';
import 'package:cognito/views/components/gradebook_item.dart';
import 'package:cognito/views/components/task_agenda_item.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../main_drawer.dart';

class GradebookView extends StatefulWidget {
  @override
  _GradebookViewState createState() => _GradebookViewState();
}

class _GradebookViewState extends State<GradebookView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(115),
        child: AppBar(
          backgroundColor: Theme.of(context).primaryColorDark,
          centerTitle: true,
          title: Text(
            "Gradebook",
            style: TextStyle(
                color: Colors.black,
                fontSize: 20.0
            ),),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),)
          ),
          flexibleSpace: Container(
            padding: EdgeInsets.fromLTRB(30, 75, 30, 0),
            child: Container(
              alignment: Alignment.center,
              width: 50,
              height: 50,
              child: ClassGradebookDropDown(),
            ),
          ),
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: gradesWidgets(),
    );
  }

  Widget gradesWidgets()
  {
    return ungradedItems();
  }

  Widget ungradedItems()
  {
    int ungradedTasksCount = 0;
    return ListView(
      padding: const EdgeInsets.all(15),
      children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFFB142)),
                child: Icon(
                    Icons.list,
                  color: Theme.of(context).backgroundColor,
                )
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "Ungraded Tasks",
                      style: Theme.of(context).primaryTextTheme.bodyText2
                  ),
                  Text(
                      "$ungradedTasksCount tasks here",
                      style: GoogleFonts.poppins(
                          color: Colors.grey,
                          fontSize: 13
                      )
                    ),
                  ],
                )
              ],
            ),
        Padding(
          padding: EdgeInsets.all(10),
        ),
        GradebookItem(),
        Padding(
          padding: EdgeInsets.all(10),
        ),
        GradebookItem(),
        Padding(
          padding: EdgeInsets.all(10),
        ),
        GradebookItem(),
        Padding(
          padding: EdgeInsets.all(10),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFFFB142)),
                child: Icon(
                  Icons.list,
                  color: Theme.of(context).backgroundColor,
                )
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "Graded Tasks",
                    style: Theme.of(context).primaryTextTheme.bodyText2
                ),
                Text(
                    "$ungradedTasksCount tasks here",
                    style: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontSize: 13
                    )
                ),
              ],
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.all(10),
        ),
        GradebookItem(),
        Padding(
          padding: EdgeInsets.all(10),
        ),
        GradebookItem(),
        Padding(
          padding: EdgeInsets.all(10),
        ),
        GradebookItem(),
        Padding(
          padding: EdgeInsets.all(10),
        ),
      ],
    );
  }
}
