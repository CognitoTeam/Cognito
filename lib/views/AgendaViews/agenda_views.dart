import 'package:cognito/database/database.dart';
import 'package:cognito/models/academic_term.dart';
import 'package:cognito/models/class.dart';
import 'package:cognito/views/AgendaViews/gradebook_view.dart';
import 'package:cognito/views/AgendaViews/tasks_view.dart';
import 'package:cognito/views/AgendaViews/agenda_view.dart';
import 'package:cognito/views/AgendaViews/priority_agenda_view.dart';
import 'package:cognito/views/components/agenda_navigator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class AgendaViews extends StatefulWidget {
  AcademicTerm term;

  AgendaViews(this.term);
  @override
  _AgendaViewsState createState() => _AgendaViewsState();
}

class _AgendaViewsState extends State<AgendaViews> {

  int _currentIndex = 0;
  List<Widget> _children;
  PageController _pageController;
  final db = DataBase();
  @override
  void initState()
  {
    _pageController = PageController();
    _children = [
      AgendaView(widget.term),
      PriorityAgendaView(),
      TasksView(),
      GradebookView(),
    ];
    super.initState();
  }

  @override
  void dispose()
  {
    _pageController.dispose();
    super.dispose();
  }

  void onTabTapped(int index)
  {
    setState(
            () {
          _currentIndex = index;
        }
    );
    _pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);

    return Scaffold(
      body: StreamProvider<List<Class>>.value(
        value: db.streamClasses(user, widget.term),
        child: SizedBox.expand(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            children: _children,
          ),
        ),
      ),
      bottomNavigationBar: AgendaNavigator(currentIndex: _currentIndex, onNavigationChange: onTabTapped, term: widget.term,),
    );
  }
}
