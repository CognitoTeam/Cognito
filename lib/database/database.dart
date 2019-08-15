//import 'dart:io';
//import 'dart:convert';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cognito/database/firebase_login.dart';
import 'package:cognito/models/all_terms.dart';
import 'package:cognito/models/class.dart';
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

    //Fire store instance
    final firestore = Firestore.instance;

    void closeDatabase(){
      _instance = null;
    }

    Future<String> initializeFireStore() async {
      String uID = await _fireBaseLogin.currentUser();
      assert(uID != null);
      print(uID);
      Query query = firestore.collection('user_info').where('user_id', isEqualTo: uID);
      int uIDNumber;
      query.getDocuments().then((snapshot) {
        uIDNumber = snapshot.documents.length;
      });
      //If the users_info does not exist
      if (uIDNumber == 0) {
        //Create a user in the user info collection
//      allTerms = AllTerms();
        DocumentReference newUserInfo = Firestore.instance.collection("user_info").document();
        newUserInfo.setData({
          "user_id" : uID
        });
        return "";
      }
      //If user does exist in user_info collection
      else if (uIDNumber == 1){
        //print("Write json to disk from firestaore");
        //await writeJSON(documentSnapshot.data['terms']);
        getTerms();
        //      allTerms = await getAllTermsFromString(documentSnapshot.data['terms']);
        //String jsonString = await readJSON();
        //return jsonString;
        return "";
      }
    }

    /// Gets the current user's ID from Firebase.
    Future<String> getCurrentUserID() async {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      return user.uid;
    }


    void update() {
      readJSON().then((String jsonString) {
        Map<String, dynamic> updateData = <String, dynamic>{"terms": jsonString};
        _documentReference.updateData(updateData).whenComplete(() {
          print("Document Updated");
        }).catchError((e) => print(e));
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
      update();
    }


    Future<AllTerms> getTerms() async {
      AllTerms allTerms = AllTerms();
      print("GET TERMS");
      userID = await getCurrentUserID();
      print("User ID " + userID);
      firestore
          .collection("terms")
          .where("user_id", isEqualTo: userID)
          .snapshots().listen((data) =>
          data.documents.forEach((doc) => allTerms.terms.add(
              new AcademicTerm(doc['term_name'], doc['start_date'].toDate(), doc['end_date'].toDate())))
      );
      this.allTerms = allTerms;
      return allTerms;
    }

    Future<AcademicTerm> getCurrentTerm() async {
      AllTerms terms = await getTerms();
      for (AcademicTerm term in terms.terms) {
        if (DateTime.now().isAfter(term.startTime) &&
            DateTime.now().isBefore(term.endTime)) {
          return term;
        }
      }
      return null;
    }

    Future<List<Class>> getClasses() async {
      List<Class> classes = List();
      String userID = await getCurrentUserID();
      firestore.collection("classes")
          .where("user_id", isEqualTo: userID)
          .snapshots().listen((data) =>
          data.documents.forEach((doc) => classes.add(
              Class(title: doc['title'], subjectArea: doc['subject_area'],
                  courseNumber: doc['course_number'], instructor: doc['instructor'],
                  units: doc['units'], location: doc['location'],
                  officeLocation: doc['office_location'], description: doc['description'],
                  daysOfEvent: doc['days_of_event'],
                  start: doc['start_time'].toDate(), end: doc['end_time'].toDate())
          )));
    }

    void removeClass(String subjectArea, String courseNumber, String title)
    {
//    firestore.collection("classes").where("user_id", isEqualTo: )
    }

    void addClass(String subjectArea, String courseNumber, String title, int units, String location, String instructor,
        String officeLocation, String description, List<int> daysOfEvent, DateTime startTime, DateTime endTime) async {
      DocumentReference classCollectionReference = firestore.collection("classes").document();
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      classCollectionReference.setData({
        "user_id" : user,
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
        "end_time" : endTime
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
      });

      newTermReference.collection("classes_collection").document();
      newTermReference.collection("assignments_collection").document();
      newTermReference.collection("events_collection").document();
    }
}
