/// Models an event on a schedule
/// @author Julian Vu
class Event {
  /// Instance variables
  String title, description, location;
  Map<DateTime, DateTime> timeBlock;

  /// Default constructor that creates an Event from all information
  Event(this.title, this.description, this.location, DateTime start, DateTime end) {
    timeBlock = Map();
    timeBlock[start] = end;
  }

  /// Adds a time block to the map
  addTimeBlock(DateTime start, DateTime end) {
    timeBlock[start] = end;
  }

}