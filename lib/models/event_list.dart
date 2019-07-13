import 'event.dart';
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
    Event a = Event();
    a.title = "Homework A";
    a.priority = intValue(Priority.URGENT);
    return [
      a
    ];
  }
}