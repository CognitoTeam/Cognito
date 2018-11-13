import 'package:cognito/models/officer.dart';
/// Tester file for Club class
import 'package:test/test.dart';
import 'package:cognito/models/club.dart';
import 'package:cognito/models/event.dart';

void main() {
  test("Test Club Constructor", () {
    Club stem = Club(
      title: "STEM",
      description: "Science Technology Engineering Math club",
      location: "BGHS",
      start: DateTime.now(),
      end: DateTime.now(),
    );

    expect(stem.title, equals("STEM"));
    expect(stem.description, equals("Science Technology Engineering Math club"));
    expect(stem.location, equals("BGHS"));
    expect(stem.officers.isEmpty, isTrue);
    expect(stem.events.isEmpty, isTrue);
    expect(stem.tasks.isEmpty, isTrue);
  });

  test("Test Adders", () {
    Club stem = Club(
        title: "STEM",
        description: "Science Technology Engineering Math club",
        location: "BGHS",
        start: DateTime.now(),
        end: DateTime.now(),
    );

    Officer david = Officer("David Chuong", "President");
    Officer hector = Officer("Hector Flores", "Vice President");

    stem.addOfficer(david);
    stem.addOfficer(hector);
    expect(stem.officers.isNotEmpty, isTrue);
    expect(stem.officers.length, equals(2));
    expect(stem.officers[0].officerName, equals("David Chuong"));
    expect(stem.officers[1].officerName, equals("Hector Flores"));

    stem.addEvent(
      Event(
        title: "Info meeting",
        description: "First informational meeting",
        location: "BGHS"
      )
    );
    expect(stem.events.isNotEmpty, isTrue);
    expect(stem.events.length, equals(1));
    expect(stem.events[0].title, equals("Info meeting"));
    expect(stem.events[0].description, equals("First informational meeting"));
    expect(stem.events[0].location, equals("BGHS"));
  });
}