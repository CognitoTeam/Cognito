///Login for FireBase login
///@author Praneet Singh
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cognito/database/database.dart';
import 'dart:async';

class FireBaseLogin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();
  FirebaseUser _user;
  DataBase dataBase;

  Future<FirebaseUser> signInGoogleUser() async {
    final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken
    );
    _user = await _auth.signInWithCredential(credential);
    print("User Name : ${_user.displayName}");
    return _user;
  }

  Future<bool> updateUser(String firstName, String lastName, {String photoUrl = ""}) async{
    final FirebaseUser currentUser =  await _auth.currentUser();
    UserUpdateInfo userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.displayName = firstName + " " + lastName;
    userUpdateInfo.photoUrl = photoUrl;
    await currentUser.updateProfile(userUpdateInfo);
  }
  Future<String> fireBaseUserID() async{
  final FirebaseUser currentUser =  await _auth.currentUser();
  return currentUser.uid;
  }

  Future<String> userName() async{
    final FirebaseUser currentUser =  await _auth.currentUser();
    return currentUser.displayName;
  }

  ///User can sign in with email and password
  Future<FirebaseUser> signEmailIn(String email, String password) async {
    FirebaseUser user = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    assert(user != null);
    assert(await user.getIdToken() != null);
    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    _user = currentUser;
    print('signInEmail succeeded: $user');
    return user;
  }

  ///User can create a new account
  Future<FirebaseUser> createEmailUser(String email, String password) async {
    FirebaseUser user = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    assert(user != null);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    print('signInEmail succeeded: $user');
    return user;
  }

  Future<String> currentUser() async {
    FirebaseUser user = await _auth.currentUser();
    return user?.uid;
  }

  ///User can reset password through email verification
  Future<void> sendPasswordResetEmail(String email) async {
    return _auth.sendPasswordResetEmail(email: email);
  }

  Future<String> signOutUser() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    print("User Signed out");
    return "signed out";
  }
}
