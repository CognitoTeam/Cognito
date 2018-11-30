import 'dart:io';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cognito/database/firebase_login.dart';
import 'package:cognito/models/all_terms.dart';
import 'package:path_provider/path_provider.dart';

/// FireStore storage for terms
/// @author Praneet Singh
class DataBase {
  static DataBase _instance;
  factory DataBase() => _instance ??= new DataBase._();
  DataBase._();
  
  final FireBaseLogin _fireBaseLogin = FireBaseLogin();

  DocumentReference _documentReference;
  
  AllTerms allTerms;
  void closeDatabase(){
    _instance = null;
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
      allTerms = AllTerms();
      print("No data in database yet");
      return '';
    } else {
      print("Write json to disk from firestore");
      await writeJSON(documentSnapshot.data['terms']);
      allTerms = await getAllTermsFromString(documentSnapshot.data['terms']);
      String jsonString = await readJSON();
      return jsonString;
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
    writeJSON('{"terms":[],"subjects":[]}');
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
    String jsonString = json.encode(allTerms);
    print(jsonString);
    print("Writing database to storage");
    writeJSON(jsonString);
    print("Update database");
    update();
   
  }
}
