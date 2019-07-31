import 'item.dart';
import '../../views/utils/PriorityAgenda/priority.dart';

class ItemsList {
  List<Item> _list;
  ItemsList(){
    _list = new List<Item>();
  }

  void addItem(Item item) {
    _list.add(item);
  }

  List getItems() {
    return [
      new Item("Homework A", Priority.DISCRETIONARY, "Test Test Test", 0.5),
      new Item("Homework B", Priority.URGENT, "Test Test Test", 0.8)];
  }
}