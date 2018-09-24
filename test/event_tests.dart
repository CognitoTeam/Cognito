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
    expect(testEvent.title, equals("Test Event Title"));
    expect(testEvent.description, "This is a test Event object.");
    expect(testEvent.location, equals("Home"));
    expect(testEvent.timeBlock.length, equals(1));
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
    expect(testEvent.title, equals("Changed event title"));

    testEvent.description = "Changed event description";
    expect(testEvent.description, equals("Changed event description"));

    testEvent.location = "School";
    expect(testEvent.location, equals("School"));

    testEvent.timeBlock.clear();
    expect(testEvent.timeBlock.length, equals(0));

    testEvent.addTimeBlock(DateTime.now(), DateTime(2018, 12, 12));
    expect(testEvent.timeBlock.length, equals(1));
  });

  test("Optional Arguments Constructor Tests", () {
    Event testEvent = Event(
      title: "Test Event with Optional Arguments"
    );

    expect(testEvent.title, equals("Test Event with Optional Arguments"));
    expect(testEvent.description, equals(""));
    expect(testEvent.location, equals(""));
    expect(testEvent.timeBlock.length, equals(0));

    Event testEvent2 = Event(
      title: "Second Event",
      location: "Home",
      description: "Out of order description",
      start: DateTime.now(),
    );

    expect(testEvent2.title, equals("Second Event"));
    expect(testEvent2.location, equals("Home"));
    expect(testEvent2.description, equals("Out of order description"));
    expect(testEvent2.timeBlock.length, equals(0));
  });
}