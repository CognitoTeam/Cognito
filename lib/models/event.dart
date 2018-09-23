/// Models an event on a schedule
/// @author Julian Vu
class Event {
  /// Instance variables
  String _title, _description, _location;
  Map<DateTime, DateTime> _timeBlock;

  /// Default constructor that creates an Event from all information
  Event(this._title, this._description, this._location, DateTime start, DateTime end) {
    _timeBlock = Map();
    _timeBlock[start] = end;
  }

  /// Gets the location
  get location => _location;

  /// Sets the location
  set location(value) {
    _location = value;
  }

  /// Gets the description
  get description => _description;

  /// Sets the description
  set description(value) {
    _description = value;
  }

  /// Gets the title
  String get title => _title;

  /// Sets the title
  set title(String value) {
    _title = value;
  }

  /// Adds a time block to the map
  addTimeBlock(DateTime start, DateTime end) {
    _timeBlock[start] = end;
  }

}