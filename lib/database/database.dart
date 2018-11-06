import 'dart:io';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cognito/database/firebase_login.dart';
import 'package:cognito/models/academic_term.dart';
import 'package:cognito/models/all_terms.dart';
import 'package:path_provider/path_provider.dart';

/// FireStore storage for terms
/// @author Praneet Singh
class DataBase {
  final FireBaseLogin _fireBaseLogin = FireBaseLogin();
  DocumentReference _documentReference;
  AllTerms allTerms = AllTerms();
  Future<bool> startFireStore() async {
    String jsonString = await initializeFireStore();
    print("Read from the disk and populate UI");
    final jsonTerms = json.decode(jsonString);
    AllTerms allTerm = AllTerms.fromJson(jsonTerms);
    allTerms.terms = allTerm.terms;
  }

  Future<String> initializeFireStore() async {
    String uID = await _fireBaseLogin.currentUser();
    assert(uID != null);
    _documentReference = Firestore.instance.document("users/$uID");
    assert(_documentReference != null);
    print("Get document reference");
    DocumentSnapshot documentSnapshot = await _documentReference.get();
    if (!documentSnapshot.exists) {
      add();
      print("No data in database yet");
      return '';
    } else {
      print("Write json to disk from firestore");
      await writeJSON(documentSnapshot.data['terms']);
      return await readJSON();
    }
  }

  void update() {
    readJSON().then((String jsonString) {
      Map<String, dynamic> updateData = <String, dynamic>{"terms": jsonString};
      _documentReference.updateData(updateData).whenComplete(() {
        print("Document Updated");
      }).catchError((e) => print(e));
    });
    // });
  }

  void delete() {
    _documentReference.delete().whenComplete(() {
      print("Deleted Successfully");
    }).catchError((e) => print(e));
  }

  void add() {
    writeJSON('{"terms":[]}');
    Map<String, dynamic> data = <String, dynamic>{"terms": '{"terms":[]}'};
    _documentReference.setData(data).whenComplete(() {
      print("Document Added");
    }).catchError((e) => print(e));
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
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
      return contents;
    } catch (e) {
      // If we encounter an error, return 0
      return e.toString();
    }
  }

  Future<File> writeJSON(String jsonString) async {
    final file = await _localFile;
    print("Writing JSON to local Storage");

    // Write the file
    return file.writeAsString(jsonString);
  }

  Future<void> updateDatabase() {
    String jsonString = json.encode(allTerms);
    print("Encoding terms");
    writeJSON(jsonString);
    print("Writing database to storage");
    update();
    print("Update database");
  }
}
