//import 'dart:io';
//import 'dart:convert';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cognito/database/firebase_login.dart';
import 'package:cognito/models/all_terms.dart';
import 'package:cognito/models/assignment.dart';
import 'package:cognito/models/category.dart';
import 'package:cognito/models/class.dart';
import 'package:cognito/models/club.dart';
import 'package:cognito/models/event.dart';
import 'package:cognito/models/task.dart';
import 'package:cognito/models/officer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cognito/models/academic_term.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// FireStore storage for terms
/// @author Praneet Singh
class DataBase {
    static DataBase _instance;
    factory DataBase() {
      _instance ??= new DataBase._();
      return _instance;
    }

    DataBase._();

    final FireBaseLogin _fireBaseLogin = FireBaseLogin();

    DocumentReference _documentReference;

    AllTerms allTerms = AllTerms();

    String userID;

    int term_id = 0;

    //Fire store instance
    final firestore = Firestore.instance;

    void closeDatabase(){
      _instance = null;
    }

    Future<String> initializeFireStore() async {
      String uID = await _fireBaseLogin.currentUser();
      assert(uID != null);
      //If the users_info does not exist
      DocumentReference newUserInfo = Firestore.instance.collection('user_info').document();
      newUserInfo.setData({
        "user_id" : uID
      });
      return "";
    }

    /// Gets the current user's ID from Firebase.
    Future<String> getCurrentUserID() async {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      userID = user.uid;
      return user.uid;
    }


    void update() {
      readJSON().then((String jsonString) {
        Map<String, dynamic> updateData = <String, dynamic>{"terms": jsonString};
        /*_documentReference.updateData(updateData).whenComplete(() {
          print("Document Updated");
        }).catchError((e) => print(e));*/
      });
    }

    void delete() {
      _documentReference.delete().whenComplete(() {
        print("Deleted Successfully");
      }).catchError((e) => print(e));
    }

    void add() {
      //writeJSON('{"terms":[],"subjects":[]}');
      Map<String, dynamic> data = <String, dynamic>{"terms": '{"terms":[],"subjects":[]}'};
      _documentReference.setData(data).whenComplete(() {
        print("Document Added");
      }).catchError((e) => print(e));
    }

    Future<String> get _localPath async {
      final directory = await getApplicationDocumentsDirectory();
      return directory.path;
    }
    Future<AllTerms> getAllTermsFromString(String stringObject) async{
      Map<String, dynamic> allMap = await json.decode(stringObject);
      AllTerms all = AllTerms.fromJson(allMap);
      return all;
    }

    Future<File> get _localFile async {
      final path = await _localPath;
      return File('$path/terms.txt');
    }

    Future<String> readJSON() async {
      try {
        final file = await _localFile;
        // Read the file
        String contents = await file.readAsString();
        print("Reading JSON from local Storage");
        print("Reading from device: " + contents);
        return contents;
      } catch (e) {
        // If we encounter an error, return 0
        return e.toString();
      }
    }

    Future<File> writeJSON(String jsonString) async {
      print("Write:" + jsonString);
      final file = await _localFile;
      print("Writing JSON to local Storage");

      // Write the file
      return file.writeAsString(jsonString);
    }

    Future<void> updateDatabase() {
      print("Encoding terms");
//    String jsonString = json.encode(allTerms);
//    print(jsonString);
//    print("Writing database to storage");
//    writeJSON(jsonString);
      print("Update database");
//      update();
    }


    Future<AllTerms> getTerms() async {
      AllTerms allTerms = AllTerms();
      userID = await getCurrentUserID();
      QuerySnapshot querySnapshot = await firestore
          .collection('terms')
          .where('user_id', isEqualTo: userID)
          .getDocuments();
      for(int i = 0; i < querySnapshot.documents.length; i++)
        {
          DocumentSnapshot document = querySnapshot.documents[i];
          allTerms.addTerm(AcademicTerm(document['term_name'], document['start_date'].toDate(), document['end_date'].toDate()));
        }
      return allTerms;
    }

    Future updateTerms() async {
      allTerms = await getTerms();
    }

    Future<List<Assignment>> getAssignments(Class classObj, AcademicTerm term, bool forAssessment)
    async {
      List<Assignment> assignments = List();
      QuerySnapshot querySnapshot = await firestore.collection('classes').where('user_id', isEqualTo: userID).where('term_name', isEqualTo: term.termName)
          .where('title', isEqualTo: classObj.title).where('instructor', isEqualTo: classObj.instructor).getDocuments();
      //Documents for the class
      List<DocumentSnapshot> documents = querySnapshot.documents;
      if(documents.length == 0)
        {
          print("database.dart -> getAssignments ERROR: could not find any class");
        }
      else if(documents.length > 1)
        {
          print("database.dart -> getAssignments ERROR: found more than one class");
        }
      else
        {
         QuerySnapshot snapshot = await firestore.collection('classes').document(documents[0].documentID).collection("assignments").getDocuments();
         for(DocumentSnapshot documentSnapshot in snapshot.documents)
           {
             if(documentSnapshot.data["is_assessment"] == forAssessment)
               {
                 assignments.add(mapToAssignment(documentSnapshot.data));
               }
           }
        }
      return assignments;
    }

    Future<List<Category>> getCategories(Class classObj, AcademicTerm term)
    async {
      List<Category> categories = List();
      QuerySnapshot querySnapshot = await firestore.collection('classes').where('user_id', isEqualTo: userID).where('term_name', isEqualTo: term.termName)
          .where('title', isEqualTo: classObj.title).where('instructor', isEqualTo: classObj.instructor).getDocuments();
      List<DocumentSnapshot> documents = querySnapshot.documents;
      if(documents.length == 0)
      {
        print("database.dart->getAssignments ERROR: could not find any class");
      }
      else if(documents.length > 1)
      {
        print("database.dart->getAssignments ERROR: found more than one class");
      }
      else
      {
        QuerySnapshot snapshot = await firestore.collection('classes').document(documents[0].documentID).collection('categories').getDocuments();
        snapshot.documents.forEach((map)=>
            categories.add(mapToCategory(map.data))
        );
      }
      return categories;
    }


    Future<int> generateTermID(AcademicTerm term)
    async {
      QuerySnapshot termsSnapshot = await firestore.collection('terms').where('user_id', isEqualTo: userID)
          .where('start_date', isEqualTo: term.startTime).where('end_date', isEqualTo: term.endTime)
          .where('term_name', isEqualTo: term.termName).getDocuments();
      String s = termsSnapshot.documents[0].documentID;
      return s.hashCode;
    }

    Future<AcademicTerm> getCurrentTerm() async {
      updateTerms();
      for (AcademicTerm term in allTerms.terms) {
        if (DateTime.now().isAfter(term.startTime) &&
            DateTime.now().isBefore(term.endTime)) {
          return term;
        }
      }
      return null;
    }

    Future<List<Class>> getClasses() async {
      List<Class> classes = List();
      firestore.collection("classes")
          .where("user_id", isEqualTo: userID)
          .snapshots().listen((data) =>
          data.documents.forEach((doc) => classes.add(
              Class(title: doc['title'], subjectArea: doc['subject_area'],
                  courseNumber: doc['course_number'], instructor: doc['instructor'],
                  units: doc['units'], location: doc['location'],
                  officeLocation: doc['office_location'], description: doc['description'],
                  daysOfEvent: dynamicToIntList(doc['days_of_event']),
                  start: doc['start_time'].toDate(), end: doc['end_time'].toDate())
          )));
      return classes;
    }

    List<int> dynamicToIntList(List<dynamic> list)
    {
      List<int> list = List();
      list.forEach((item)=>list.add(item));
      return list;
    }

    void updateTermName(String termName, String newTermName)
    async {
      //Get the correct term
      QuerySnapshot querySnapshot = await firestore.collection("terms").where("user_id", isEqualTo: userID).where("term_name", isEqualTo: termName).getDocuments();
      print("Updating " + termName);
      if(querySnapshot.documents.length == 1)
        {
          print("DATABASE getTermsReference(): Retrieved data");
          querySnapshot.documents[0].reference.updateData(
            {
              "term_name" : newTermName
            }
          );
          print("term changed from " + termName);
          querySnapshot = await firestore.collection("classes").where("user_id", isEqualTo: userID).where("term_name", isEqualTo: termName).getDocuments();
          print("Update " + termName +  "Classes has " + querySnapshot.documents.length.toString());
          for(int i = 0; i < querySnapshot.documents.length; i++)
            {
              querySnapshot.documents[i].reference.updateData(
                {
                  "term_name" : newTermName
                }
              );
            }
          querySnapshot = await firestore.collection("events").where("user_id", isEqualTo: userID).where("term_name", isEqualTo: termName).getDocuments();
          for(int i = 0; i < querySnapshot.documents.length; i++)
          {
            querySnapshot.documents[i].reference.updateData(
                {
                  "term_name" : newTermName
                }
            );
          }
          querySnapshot = await firestore.collection("tasks").where("user_id", isEqualTo: userID).where("term_name", isEqualTo: termName).getDocuments();
          for(int i = 0; i < querySnapshot.documents.length; i++)
          {
            querySnapshot.documents[i].reference.updateData(
                {
                  "term_name" : newTermName
                }
            );
          }
          print("Update " + termName +  "Classes has " + querySnapshot.documents.length.toString());
          querySnapshot = await firestore.collection("clubs").where("user_id", isEqualTo: userID).where("term_name", isEqualTo: termName).getDocuments();
          for(int i = 0; i < querySnapshot.documents.length; i++)
          {
            querySnapshot.documents[i].reference.updateData(
                {
                  "term_name" : newTermName
                }
            );
          }
        }
      else if(querySnapshot.documents.length == 0)
        {
          print("DATABASE getTermsReference(): Did not retrieve any data");
        }
      else
        {
          print("DATABASE getTermsReference(): Retrieved duplicate data");
        }
    }

    void addUser(FirebaseUser user)
    {
      Firestore.instance.collection('user_info').document().setData({
        'user' : user.uid
      });
    }

    void addClass(String subjectArea, String courseNumber, String title, int units, String location, String instructor,
        String officeLocation, String description, List<int> daysOfEvent, DateTime startTime, DateTime endTime, AcademicTerm term) async {

      DocumentReference classCollectionReference = Firestore.instance.collection("classes").document();
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      classCollectionReference.setData({
        "user_id" : user.uid,
        "title" : title,
        "subject_area" : subjectArea,
        "course_number" : courseNumber,
        "instructor" : instructor,
        "units" : units,
        "location" : location,
        "office_location" : officeLocation,
        "description" : description,
        "days_of_event" : daysOfEvent,
        "start_time" : startTime,
        "end_time" : endTime,
        "term_name" : term.termName,
        "term_id" : await generateTermID(term)
      });

      classCollectionReference.collection("assignments").document();
    }

    void addAcademicTerm(String text, DateTime startDate, DateTime endDate) async
    {
      AcademicTerm term = new AcademicTerm(text, startDate, endDate);
      allTerms.addTerm(term);
      DocumentReference newTermReference = firestore.collection("terms").document();

      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      newTermReference.setData({
        "user_id" : user.uid,
        "term_name" : term.termName,
        "start_date" : term.startTime,
        "end_date" : term.endTime,
        "term_id" : await generateTermID(term)
      });

      newTermReference.collection("classes_collection").document();
      newTermReference.collection("assignments_collection").document();
      newTermReference.collection("events_collection").document();
    }

    void addSubject(String subjectName) async {
      DocumentReference newTermReference = firestore.collection("subjects").document();
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      newTermReference.setData({
        'user_id' : user.uid,
        'subject_name' : subjectName
      });
    }

    void addEvent(String title, String location, String description, List<int> daysOfEvent, bool isRepeated,
        DateTime startTime, DateTime endTime, int id, int priority, Duration duration, AcademicTerm term, DocumentReference newEventReferenceLocation) async {
      if(newEventReferenceLocation == null) {
        newEventReferenceLocation = firestore.collection("events").document();
      }

      newEventReferenceLocation.setData({
        "user_id" : userID,
        "title" : title,
        "location" : location,
        "description" : description,
        "days_of_event" : daysOfEvent,
        "repeated" : isRepeated,
        "start_time" : startTime,
        "end_time" : endTime,
        "term_id" : await generateTermID(term),
        "priority" : priority,
        "duration_in_minutes" : duration.inMinutes,
        "term_name" : term.termName
      });
    }

    Future addTask(String title, String location, String description, List<int> daysOfEvent, bool isRepeated,
        DateTime dueDate, int id, int priority, Duration duration, AcademicTerm term, DocumentReference newTaskReferenceLocation)
    async {
      if(newTaskReferenceLocation == null)
        {
          newTaskReferenceLocation = firestore.collection("tasks").document();
        }
      newTaskReferenceLocation.setData({
        "user_id" : userID,
        "title" : title,
        "location" : location,
        "description" : description,
        "days_of_event" : daysOfEvent,
        "repeated" : isRepeated,
        "due_date" : dueDate,
        "term_id" : await generateTermID(term),
        "priority" : priority,
        "duration_in_minutes" : duration.inMinutes,
        "term_name" : term.termName
      });
    }

    Future<String> addClub(Club club, AcademicTerm term)
    async {
      print("adding club");
      DocumentReference newClubReference = firestore.collection("clubs").document();
      newClubReference.setData({
        "user_id" : userID,
        "title" : club.title,
        "location" : club.location,
        "description" : club.description,
        "id" : club.id,
        "term_name" : term.termName,
        'term_id' : await generateTermID(term)
      });

      if(club.officers.isNotEmpty)
        {
          for(Officer o in club.officers) {
            newClubReference.collection("officers").document().setData({
              "officer_name" : o.officerName,
              "officer_position" : o.officerPosition
            });
          }
        }

      if(club.tasks.isNotEmpty)
        {
          for(Task t in club.tasks)
            {
              addTask(t.title, t.location, t.description, t.daysOfEvent,
                  t.isRepeated, t.dueDate, t.id, t.priority, t.duration, term,
                  newClubReference.collection("tasks").document());
            }
        }

      if(club.events.isNotEmpty)
        {
          for(Event e in club.events)
            {
              addEvent(e.title, e.location, e.description, e.daysOfEvent, e.isRepeated,
                  e.startTime, e.endTime, e.id, e.priority, e.duration, term,
                  newClubReference.collection("events").document());
            }
        }
      return newClubReference.documentID;
    }

    Future updateTermID(AcademicTerm term)
    async {
      term_id = await generateTermID(term);
    }

    Future addAssignment(Assignment assignment, Class classObj, AcademicTerm term) async {

      int termID = await generateTermID(term);
      String collectionName;
      String otherCollectionName;
      if (assignment.isAssessment)
        {
          collectionName = "assessments";
          otherCollectionName = "assignments";
        }
      else
        {
          collectionName = "assignments";
          otherCollectionName = "assessments";
        }

      DocumentReference docRefGradesUserTerm;
      DocumentReference docRefGradesUserTermAssignment;
      //Grades are separated into each [term of user]
      //Look for a [term of user]
      QuerySnapshot snapshot = await firestore.collection("grades").where("user_id", isEqualTo: userID).where("term_name", isEqualTo: term.termName).getDocuments();

      //First time adding a grade will need to create a [term of user]
      if(snapshot.documents.isEmpty) {
        docRefGradesUserTerm = Firestore.instance.collection("grades").document();
        docRefGradesUserTerm.setData({
          "user_id" : userID,
          "term_name" : term.termName
        });

        //create an assignment and assessment collection in grades since first time in
        docRefGradesUserTerm.collection(otherCollectionName);
        docRefGradesUserTermAssignment = docRefGradesUserTerm.collection(collectionName).document();
      }
      // user/term exists so add onto collection
      else
        {
          //Need the user and term ID to add onto the correct GRADES collection
          String userAndTermID = snapshot.documents[0].documentID;
          //Now the correct reference is added to grades {user, term_name} -> assignment collection
          docRefGradesUserTermAssignment = Firestore.instance.collection('grades').document(userAndTermID).collection(collectionName).document();
        }

      docRefGradesUserTermAssignment.setData({
        "category_title" : assignment.category.title,
        "category_weight_in_percentage" : assignment.category.weightInPercentage,
        "category_points_earned" : assignment.category.pointsEarned,
        "category_points_possible" : assignment.category.pointsPossible,
        "points_earned" : assignment.pointsEarned,
        "points_possible" : assignment.pointsPossible,
        "title" : assignment.title,
        "is_assessment" : assignment.isAssessment,
        "location" : assignment.location,
        "description" : assignment.description,
        "due_date" : assignment.dueDate,
        "term_id" : termID,
        "priority" : assignment.priority,
        "duration_in_minutes" : assignment.duration.inMinutes,
        "class_title" : classObj.title,
        "class_subject" : classObj.subjectArea,
        "class_number" : classObj.courseNumber
      });

      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      //Get the correct class document in class collection
      snapshot = await firestore.collection("classes").where('user_id', isEqualTo: user.uid).where('title', isEqualTo: classObj.title)
          .where('instructor', isEqualTo: classObj.instructor).where('term_name', isEqualTo:  term.termName).getDocuments();
      if(snapshot.documents.length == 0) print("ERROR: FDid not find any data by this query");
      if(snapshot.documents.length > 1) print("ERROR: Found more than one data entries");
      //Should be only a unique class
      if(snapshot.documents.length == 1)
        {
          firestore.collection("classes").document(snapshot.documents[0].documentID).collection('assignments').document().setData(
            {
              "category_title" : assignment.category.title,
              "category_weight_in_percentage" : assignment.category.weightInPercentage,
              "category_points_earned" : assignment.category.pointsEarned,
              "category_points_possible" : assignment.category.pointsPossible,
              "points_earned" : assignment.pointsEarned,
              "points_possible" : assignment.pointsPossible,
              "title" : assignment.title,
              "is_assessment" : assignment.isAssessment,
            }
          );
        }
    }


    Future addCategoryToClass(Category cat, Class aClass, AcademicTerm term) async {
      //Need to find the correct class
      QuerySnapshot snapshot = await firestore.collection('classes').where('user_id', isEqualTo: userID).where("term_name", isEqualTo: term.termName)
          .where('title', isEqualTo: aClass.title).where('instructor', isEqualTo: aClass.instructor).getDocuments();
      Firestore.instance.collection('classes').document(snapshot.documents[0].documentID).collection("categories").document().setData({
        "category_title" : cat.title,
        "category_weight_in_percentage" : cat.weightInPercentage
      });
    }

    Class documentToClass(DocumentSnapshot document)
    {
      List<int> listOfInt = List();
      for(int i = 0; i < document['days_of_event'].length; i++)
        {
          listOfInt.add(document['days_of_event'][i]);
        }
      return new Class(title: document['title'], description: document['decription'],
      location: document['location'], officeLocation: document['office_location'],
      start: document['start_time'].toDate(), end: document['end_time'].toDate(),
      subjectArea: document['subject_area'], courseNumber: document['course_number'],
      instructor: document['instructor'], units: document['units'],
      daysOfEvent: listOfInt, id: document['term_id']);
    }

    Event documentToEvent(DocumentSnapshot document)
    {
      List<int> listOfInt = List();
      for(int i = 0; i < document['days_of_event'].length; i++)
      {
        listOfInt.add(document['days_of_event'][i]);
      }

      return new Event(title: document['title'], location: document['location'], description: document['description'],
      daysOfEvent: listOfInt, isRepeated: document['repeated'], start: document['start_time'].toDate(),
      end: document['end_time'].toDate(), id: document['id'], priority: document['priority'],
      duration: Duration(minutes: document['duration_in_minutes']),
      );
    }

    Task documentToTask(DocumentSnapshot document)
    {
    List<int> listOfInt = List();
    for(int i = 0; i < document['days_of_event'].length; i++)
    {
    listOfInt.add(document['days_of_event'][i]);
    }
      return new Task(title: document['title'], location: document['location'],
      description: document['decription'], daysOfEvent: listOfInt, isRepeated: document['repeated'],
      dueDate: document['due_date'].toDate(), id: document['id'], priority: document['priority'],
      duration: Duration(minutes: document['duration_in_minutes']));
    }

    Club documentToClub(DocumentSnapshot document) {
      return new Club(title: document['title'], location: document['location'], description: document['description'],
      id: document['id']);
    }

    Assignment documentToAssignment(DocumentSnapshot document)
    {
      int minutes = document['duration_in_minutes'];
      Duration d = new Duration(minutes: minutes);
      return new Assignment(title: document['title'], isAssessment: document['is_assessment'], description: document['description'],
      location: document['location'], dueDate: document['due_date'].toDate(),
      id: document['term_id'], priority: document['priority'], duration: d,
      pointsEarned: document['points_earned'], pointsPossible: document['points_possible'],
          category: Category(
            title: document['category_title'], weightInPercentage: document['category_weight_in_percentage']
          ));
    }

    Category documentToCategory(DocumentSnapshot document) {
      return new Category(title: document['category_title'], weightInPercentage: document['category_weight_in_percentage']);
    }

    Assignment mapToAssignment(Map<String, dynamic> data)
    {
      return Assignment(title: data['title'], isAssessment: data['is_assessment'],
          pointsEarned: data['points_earned'], pointsPossible: data['points_possible'],
          category: Category(
              title: data['category_title'], weightInPercentage: data['category_weight_in_percentage']
          ));
    }

    Category mapToCategory(Map<String, dynamic> data)
    {
      return Category(
        title: data['category_title'], weightInPercentage: data['category_weight_in_percentage']
      );
    }

    Future removeClass(Class classObj, AcademicTerm term)
    async {
      QuerySnapshot snapshot = await firestore.collection('classes').where('user_id', isEqualTo: userID)
          .where('term_name', isEqualTo: term.termName).where('title', isEqualTo: classObj.title).where('instructor', isEqualTo: classObj.instructor)
          .getDocuments();
      snapshot.documents.forEach((document) =>
        firestore.collection('classes').document(document.documentID).delete()
      );
    }

    Future removeClub(Club clubObj, AcademicTerm term)
    async {
      QuerySnapshot snapshot = await firestore.collection('clubs').where('user_id', isEqualTo: userID)
          .where('term_name', isEqualTo: term.termName).where('term_id', isEqualTo: await generateTermID(term))
          .where('title', isEqualTo: clubObj.title)
          .getDocuments();
      print("Documents has a length of " + snapshot.documents.length.toString());
      for(DocumentSnapshot doc in snapshot.documents)
        {
          print(doc.documentID);
          firestore.collection('clubs').document(doc.documentID).delete();
        }
    }

    Future<int> termID(AcademicTerm term)
    async {
      if(term_id == 0)
        {
          return await generateTermID(term);
        }
      else
        {
          return term_id;
        }
    }

    void removeAcademicTerm(AcademicTerm termToRemove)
    async {
        QuerySnapshot snapshot = await firestore.collection('terms').where('user_id', isEqualTo: userID)
            .where('term_name', isEqualTo: termToRemove.termName)
            .getDocuments();
        String documentID = snapshot.documents[0].documentID;

        firestore.collection('terms').document(documentID).delete();

        snapshot = await firestore.collection('classes').where('user_id', isEqualTo: userID)
          .where('term_name', isEqualTo: termToRemove.termName).getDocuments();
        snapshot.documents.map((document) => firestore.collection('classes').document(documentID).delete());

        snapshot = await firestore.collection('tasks').where('user_id', isEqualTo: userID)
            .where('term_name', isEqualTo: termToRemove.termName).getDocuments();
        snapshot.documents.map((document) => firestore.collection('tasks').document(documentID).delete());

        snapshot = await firestore.collection('clubs').where('user_id', isEqualTo: userID)
            .where('term_name', isEqualTo: termToRemove.termName).getDocuments();
        snapshot.documents.map((document) => firestore.collection('clubs').document(documentID).delete());

        snapshot = await firestore.collection('events').where('user_id', isEqualTo: userID)
            .where('term_name', isEqualTo: termToRemove.termName).getDocuments();
        snapshot.documents.map((document) => firestore.collection('events').document(documentID).delete());
    }

  Future updateClass(Class oldClass, Class editedClass) async {
      AcademicTerm currentTerm = await getCurrentTerm();
      QuerySnapshot snapshot = await firestore.collection('classes').where('user_id', isEqualTo: userID)
          .where('title', isEqualTo: oldClass.title)
          .getDocuments();
      print("Snapshot length " + snapshot.documents.length.toString());
      for(int i = 0; i < snapshot.documents.length; i++)
      {
        snapshot.documents[i].reference.updateData(
          await classToMap(editedClass, currentTerm)
        );
      }
  }

  Future<Map<String, dynamic>> classToMap(Class classObj, AcademicTerm currentTerm)
  async {
    return {
      "user_id" : userID,
      "title" : classObj.title,
      "subject_area" : classObj.subjectArea,
      "course_number" : classObj.courseNumber,
      "instructor" : classObj.instructor,
      "units" : classObj.units,
      "location" : classObj.location,
      "office_location" : classObj.officeLocation,
      "description" : classObj.description,
      "days_of_event" : classObj.daysOfEvent,
      "start_time" : classObj.startTime,
      "end_time" : classObj.endTime,
      "term_name" : currentTerm.termName,
      'term_id' : await generateTermID(currentTerm)
    };
  }
}
