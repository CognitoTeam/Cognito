import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cognito/database/firebase_login.dart';
import 'package:cognito/database/term_storage.dart';
/// FireStore storage for terms
/// @author Praneet Singh
class DataBase {
  final FireBaseLogin _fireBaseLogin = FireBaseLogin();
  DocumentReference _documentReference;
  final TermStorage _storage = TermStorage();
  
    
    Future<String> initializeFireStore() async{
      String uID = await _fireBaseLogin.currentUser();
      assert(uID != null);
      _documentReference = Firestore.instance.document("users/$uID");
      assert(_documentReference != null);
      print("Get document reference");
      DocumentSnapshot documentSnapshot = await _documentReference.get();
      if(!documentSnapshot.exists){
             add();
            print("No data in database yet");
            return '';
      }else{
    await _storage.writeJSON(documentSnapshot.data['terms']);
    print("Write json to disk from firestore");
      return await  _storage.readJSON();
      }
  }

  void update() {
    _storage.readJSON().then((String jsonString) {
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
    _storage.writeJSON('{"terms":[]}');
    Map<String, dynamic> data = <String, dynamic>{"terms": '{"terms":[]}'};
    _documentReference.setData(data).whenComplete(() {
      print("Document Added");
    }).catchError((e) => print(e));
  }
}
