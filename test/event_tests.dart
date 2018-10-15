/// Tester file for Event class
import 'package:test/test.dart';
import 'package:cognito/models/event.dart';
import 'dart:convert';

void main() {
  test("Event Constructor Tests", () {
    Event testEvent = Event(
        title: "Test Event Title",
        description: "This is a test Event object.",
        location: "Home",
        start: DateTime.now(),
        end: DateTime(2018, 0, 0, 11, 44),
    );
    expect(testEvent.title, equals("Test Event Title"));
    expect(testEvent.description, "This is a test Event object.");
    expect(testEvent.location, equals("Home"));
  });

  test("Event JSon Tests", () {
    List<int> days = [1,2,3];
    Event testEvent = Event(
        title: "Test Event Title",
        description: "This is a test Event object.",
        location: "Home",
        start: DateTime.now(),
        end: DateTime(2018, 0, 0, 11, 44),
        isRepeated: true,
        daysOfEvent: days

    );

  
  String jsonString = json.encode(testEvent);
  final jsonEvent = json.decode(jsonString);
  Event event = Event.fromJson(jsonEvent);
  print(jsonString);
  

    expect(testEvent.title, equals(event.title));
    expect(testEvent.description, equals(event.description));
    expect(testEvent.location, equals(event.location));
    expect(testEvent.startTime, equals(event.startTime));
    expect(testEvent.endTime, equals(event.endTime));
    expect(testEvent.isRepeated, equals(event.isRepeated));
    expect(testEvent.daysOfEvent, equals(event.daysOfEvent));

  });
test("Event Time Parse Tests", () {
    List<int> days = [1,2,3];
    Event testEvent = Event(
        title: "Test Event Title",
        description: "This is a test Event object.",
        location: "Home",
        start: DateTime.now(),
        end: DateTime(2018, 0, 0, 11, 44),
        isRepeated: true,
        daysOfEvent: days

    );




  });
  test("Event Modification Tests", () {
    Event testEvent = Event(
        title: "Test Event Title",
        description: "This is a test Event object.",
        location: "Home",
        start: DateTime.now(),
        end: DateTime(2018, 0, 0, 11, 44),
    );

    testEvent.title = "Changed event title";
    expect(testEvent.title, equals("Changed event title"));

    testEvent.description = "Changed event description";
    expect(testEvent.description, equals("Changed event description"));

    testEvent.location = "School";
    expect(testEvent.location, equals("School"));
  });

  test("Optional Arguments Constructor Tests", () {
    Event testEvent = Event(
      title: "Test Event with Optional Arguments"
    );

    expect(testEvent.title, equals("Test Event with Optional Arguments"));
    expect(testEvent.description, equals(""));
    expect(testEvent.location, equals(""));

    Event testEvent2 = Event(
      title: "Second Event",
      location: "Home",
      description: "Out of order description",
      start: DateTime.now(),
        end: DateTime(2018, 0, 0, 11, 44),
    );

    expect(testEvent2.title, equals("Second Event"));
    expect(testEvent2.location, equals("Home"));
    expect(testEvent2.description, equals("Out of order description"));
  });
}