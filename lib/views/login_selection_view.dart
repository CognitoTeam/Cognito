/// Login selection view
/// View screen to select mode of authentication
/// @author Julian Vu
import 'package:flutter/material.dart';
import 'package:cognito/views/login_view.dart';
import 'dart:async';
import 'package:cognito/database/firebase_login.dart';
import 'package:cognito/views/signup_view.dart';
import 'package:cognito/views/academic_term_view.dart';

class LoginSelectionView extends StatefulWidget {
  static String tag = "login-selection-view";
  @override
  _LoginSelectionViewState createState() => _LoginSelectionViewState();
}

enum AuthStatus {
  notDetermined,
  notSignedIn,
  signedIn,
}

class _LoginSelectionViewState extends State<LoginSelectionView> {
  FireBaseLogin _fireBaseLogin = FireBaseLogin();
  AuthStatus authStatus = AuthStatus.notDetermined;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _fireBaseLogin.currentUser().then((userId) {
      setState(() {
        authStatus =
            userId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
    });
  }
  ///Login user with Google signin
  Future<bool> _loginUser() async {
    final firebaseUser = await _fireBaseLogin.signInGoogleUser();
    if (firebaseUser != null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (authStatus == AuthStatus.signedIn) {
      return AcademicTermView();
    } else {
      final logo = Hero(
        tag: "hero",
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 128.0,
          child: Image.asset("assets/logo-1024.png"),
        ),
      );

      final withGoogle = Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: ButtonTheme(
          minWidth: 200.0,
          height: 42.0,
          child: RaisedButton.icon(
            onPressed: () async {
              bool b = await _loginUser();

              b
                  ? Navigator.pushAndRemoveUntil(context, 
                  MaterialPageRoute(builder: (context) => 
                  AcademicTermView()), ModalRoute.withName("/Home"))
                  : Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Google login failed!'),
                      ),
                    );
            },
            color: Colors.white,
            label: Text(
              "Sign in with Google",
              style: TextStyle(
                fontFamily: 'Roboto',
                color: Color.fromRGBO(68, 68, 76, .8),
              ),
            ),
            icon: Image.asset(
              'assets/google.png',
              width: 35.0,
            ),
            textColor: Colors.black,
          ),
        ),
      );

      final withEmail = Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: ButtonTheme(
          minWidth: 200.0,
          height: 42.0,
          child: RaisedButton(
            onPressed: () {
              Navigator.of(context).pushNamed(LoginView.tag);
            },
            color: Theme.of(context).accentColor,
            child: Text("Sign in with Email",
                style: Theme.of(context).accentTextTheme.body1),
          ),
        ),
      );

      final signUp = Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: ButtonTheme(
          minWidth: 200.0,
          height: 42.0,
          child: RaisedButton(
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => SignUpView())),
            color: Theme.of(context).primaryColorLight,
            child: Text(
              "Sign Up",
              style: Theme.of(context).accentTextTheme.body1,
            ),
          ),
        ),
      );

      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            children: <Widget>[
              logo,
              SizedBox(
                height: 64.0,
              ),
              withGoogle,
              withEmail,
              signUp,
            ],
          ),
        ),
      );
    }
  }
}
