import 'package:cloud_firestore/cloud_firestore.dart';
/// Models a club
/// @author Julian Vu
import 'package:cognito/models/event.dart';
import 'package:cognito/models/officer.dart';
import 'package:cognito/models/task.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'club.g.dart';

@JsonSerializable()

class Club extends Event {
  List<Officer> officers;
  List<Event> events;
  List<Task> tasks;

  Club(
      {String title,
      String description = "",
      String location = "",
      DateTime start,
      DateTime end,
      String id,
      int priority = 1})
      : super(
            title: title,
            description: description,
            location: location,
            start: start,
            end: end,
            id: id, 
            priority: priority) {
    officers = List();
    events = List();
    tasks = List();
  }

  factory Club.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    Club c = Club(
        id: doc.documentID,
        title: data['title'],
        description: data['description'],
        location: data['location'],
        priority: data['priority'],
    );

//
//    DocumentReference documentReference = Firestore.instance.collection('clubs')
//        .document(doc.documentID);
//    Query ref = documentReference.collection('events');
//    Stream<List<Event>> events = ref.snapshots().map((list) =>
//      list.documents.map((doc) => Event.fromFirestore(doc)));

//    StreamBuilder<List<Event>>(
//      stream: events,
//      builder: (context,snapshot) {
//        print("In here");
//        c.events = snapshot.data;
//        return Container();
//      },
//    );
//
//    print("Club Events " + c.events.length.toString());
//
//    ref = documentReference.collection('tasks');
//    Stream<List<Task>> tasks = ref.snapshots().map((list) =>
//        list.documents.map((doc) => Task.fromFirestore(doc)));
//    StreamBuilder<List<Task>>(
//        stream: tasks,
//        builder: (context,snapshot) {
//          c.tasks = snapshot.data;
//          return Container();
//    },
//    );
//
//    print("Club Tasks " + c.tasks.length.toString());
//
//    ref = documentReference.collection('officers');
//    Stream<List<Officer>> officers = ref.snapshots().map((list) =>
//        list.documents.map((doc) => Officer.fromFirestore(doc)));
//    StreamBuilder<List<Officer>>(
//      stream: officers,
//      builder: (context,snapshot) {
//        c.officers = snapshot.data;
//        return Container();
//      },
//    );
//    print("Club Officers " + c.officers.length.toString());
    return c;
  }

factory Club.fromJson(Map<String, dynamic> json) => _$ClubFromJson(json);

  Map<String, dynamic> toJson() => _$ClubToJson(this);
  /// Adds a club event to list of events
  void addEvent(Event event) {
    events.add(event);
  }

  /// Adds an officer to list of officers
  void addOfficer(Officer officer) {
    officers.add(officer);
  }
  /// Adds a task to list of tasks
  void addTask(Task task) {
    tasks.add(task);
  }

  Stream<List<Event>> streamClubEvents(FirebaseUser user, DocumentSnapshot doc) {
    Query ref = Firestore.instance
        .collection('clubs').document(doc.documentID).collection('events');
    return ref.snapshots().map((list) =>
        list.documents.map((doc) => Event.fromFirestore(doc)).toList());
  }
}
