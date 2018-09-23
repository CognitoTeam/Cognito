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
}