/// Tester file for Event class
import 'package:test/test.dart';
import 'package:cognito/models/event.dart';

void main() {
  test("Event Constructor Tests", () {
    Event testEvent = Event(
        title: "Test Event Title",
        description: "This is a test Event object.",
        location: "Home",
        start: DateTime.now(),
        end: DateTime(2018, 12, 12)
    );
    expect("Test Event Title", equals(testEvent.title));
    expect("This is a test Event object.", equals(testEvent.description));
    expect("Home", equals(testEvent.location));
    expect(1, equals(testEvent.timeBlock.length));
  });

  test("Event Modification Tests", () {
    Event testEvent = Event(
        title: "Test Event Title",
        description: "This is a test Event object.",
        location: "Home",
        start: DateTime.now(),
        end: DateTime(2018, 12, 12)
    );

    testEvent.title = "Changed event title";
    expect("Changed event title", equals(testEvent.title));

    testEvent.description = "Changed event description";
    expect("Changed event description", equals(testEvent.description));

    testEvent.location = "School";
    expect("School", testEvent.location);

    testEvent.timeBlock.clear();
    expect(0, equals(testEvent.timeBlock.length));

    testEvent.addTimeBlock(DateTime.now(), DateTime(2018, 12, 12));
    expect(1, equals(testEvent.timeBlock.length));
  });

  test("Optional Arguments Constructor Tests", () {
    Event testEvent = Event(
      title: "Test Event with Optional Arguments"
    );

    expect("Test Event with Optional Arguments", equals(testEvent.title));
    expect("", equals(testEvent.description));
    expect("", equals(testEvent.location));
    expect(0, equals(testEvent.timeBlock.length));

    Event testEvent2 = Event(
      title: "Second Event",
      location: "Home",
      description: "Out of order description",
      start: DateTime.now(),
    );

    expect("Second Event", equals(testEvent2.title));
    expect("Home", equals(testEvent2.location));
    expect("Out of order description", equals(testEvent2.description));
    expect(0, equals(testEvent2.timeBlock.length));
  });
}