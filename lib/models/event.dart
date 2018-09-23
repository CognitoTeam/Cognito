/// Models an event on a schedule
/// @author Julian Vu
class Event {
  /// Instance variables
  String title, description, location;
  Map<DateTime, DateTime> timeBlock;

  /// Default constructor that creates an Event from all information
  Event({String title, String description = "", String location = "", DateTime start, DateTime end}) {
    this.title = title;
    this.description = description;
    this.location = location;
    this.timeBlock = Map();
    if (start != null && end != null) {
      this.timeBlock[start] = end;
    }
  }

  /// Adds a time block to the map
  addTimeBlock(DateTime start, DateTime end) {
    timeBlock[start] = end;
  }

}