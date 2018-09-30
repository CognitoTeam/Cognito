///Login for FireBase login
///@author Praneet Singh
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';

class FireBaseLogin{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();

    Future<FirebaseUser> signInUser() async {
      GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication= await googleSignInAccount.authentication;

      FirebaseUser user = await _auth.signInWithGoogle(
        idToken: googleSignInAuthentication.idToken, accessToken: googleSignInAuthentication.accessToken);

      print("User Name : ${user.displayName}");
     return user;
    }
    Future<FirebaseUser> signIn(String email, String password) async {
    FirebaseUser user = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return user;
  }

  Future<FirebaseUser> createUser(String email, String password) async {
    FirebaseUser user = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    return user;
  }
    Future<FirebaseUser> signOutUser() async{
      googleSignIn.signOut();
      print("User Signed out");
    }

}