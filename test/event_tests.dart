/// Tester file for Event class
import 'package:test/test.dart';
import 'package:cognito/models/event.dart';

void main() {
  test("Event Constructor Tests", () {
    Event testEvent = Event("Test Event Title", "This is a test Event object.", "Home", DateTime.now(), DateTime(2018, 12, 12));
    expect("Test Event Title", equals(testEvent.title));
    expect("This is a test Event object.", equals(testEvent.description));
    expect("Home", equals(testEvent.location));
    expect(1, equals(testEvent.timeBlock.length));
  });

  test("Event Modification Tests", () {
    Event testEvent = Event("Test Event Title", "This is a test Event object.", "Home", DateTime.now(), DateTime(2018, 12, 12));

    testEvent.title = "Changed event title";
    expect("Changed event title", equals(testEvent.title));

    testEvent.description = "Changed event description";
    expect("Changed event description", equals(testEvent.description));

    testEvent.location = "School";
    expect("School", testEvent.location);

    testEvent.timeBlock.clear();
    expect(0, testEvent.timeBlock.length);

    testEvent.addTimeBlock(DateTime.now(), DateTime(2018, 12, 12));
  });
}