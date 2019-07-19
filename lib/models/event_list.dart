import 'event.dart';
import 'assignment.dart';
import '../views/utils/PriorityAgenda/priority.dart';

class EventList {
  List<Event> _list;
  EventList(){
    _list = new List<Event>();
  }

  void addEvent(Event item) {
    _list.add(item);
  }

  List getItems() {
//    Event a = Event();
//    a.title = "Homework A";
//    a.priority = intValue(Priority.URGENT);
//
//    Assignment b = new Assignment();
//    b.title = "Assignment A";
//    b.priority = 0;
//
//    return [
//      a,
//      b
//    ];
  return _list;
  }
}