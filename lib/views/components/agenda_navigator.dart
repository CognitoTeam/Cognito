import 'package:flutter/material.dart';

class AgendaNavigator extends StatelessWidget {
  final int currentIndex;
  final Function(int) onNavigationChange;

  AgendaNavigator({
    @required this.currentIndex,
    @required this.onNavigationChange,
    });


  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: new BorderRadius.only(
          topLeft: const Radius.circular(25.0),
          topRight: const Radius.circular(25.0),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Theme.of(context).primaryColorDark,
          selectedItemColor: Theme.of(context).buttonColor,
          currentIndex: currentIndex,
          onTap: onNavigationChange,
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.home),
              title: new Text('Agenda'),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.list),
              title: new Text('Priorities'),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.book),
              title: new Text('Tasks'),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.grade),
              title: new Text('Gradebook'),
            ),
          ],
        ),
      );
  }
}
