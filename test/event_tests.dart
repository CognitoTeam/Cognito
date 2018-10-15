/// Tester file for Event class
import 'package:test/test.dart';
import 'package:cognito/models/event.dart';
import 'package:flutter/material.dart';

void main() {
  test("Event Constructor Tests", () {
    Event testEvent = Event(
        title: "Test Event Title",
        description: "This is a test Event object.",
        location: "Home",
        start: TimeOfDay.now(),
        end: TimeOfDay(hour: 11, minute: 59)
    );
    expect(testEvent.title, equals("Test Event Title"));
    expect(testEvent.description, "This is a test Event object.");
    expect(testEvent.location, equals("Home"));
  });

  test("Event Modification Tests", () {
    Event testEvent = Event(
        title: "Test Event Title",
        description: "This is a test Event object.",
        location: "Home",
        start: TimeOfDay.now(),
        end: TimeOfDay(hour: 11, minute: 59)
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
      start: TimeOfDay.now(),
    );

    expect(testEvent2.title, equals("Second Event"));
    expect(testEvent2.location, equals("Home"));
    expect(testEvent2.description, equals("Out of order description"));
  });
}