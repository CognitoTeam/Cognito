import 'package:cognito/views/buffer_view.dart';
import 'package:flutter/material.dart';
import 'package:cognito/views/login_view.dart';
import 'dart:async';
import 'package:cognito/database/firebase_login.dart';
import 'package:cognito/views/signup_view.dart';

/// Login selection view
/// View screen to select mode of authentication
/// @author Julian Vu

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
        height: 50.0,
        child: RaisedButton.icon(
          onPressed: () async {
            bool b = await _loginUser();

            b
                ? Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => BufferView()),
                    ModalRoute.withName("/Home"))
                : Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Google login failed!'),
                    ),
                  );
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: Colors.white,
          label: Text("Sign in with Google",
              style: Theme.of(context).accentTextTheme.body1),
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
        height: 50.0,
        child: RaisedButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => LoginView()));
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          color: Theme.of(context).accentColor,
          child: Text("Sign in with Email",
              style: Theme.of(context).accentTextTheme.body1),
        ),
      ),
    );

    final signUp = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: ButtonTheme(
        minWidth: 150.0,
        height: 50.0,
        child: RaisedButton(
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => SignUpView())),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          color: Theme.of(context).primaryColorLight,
          child: Text(
            "Sign Up",
            style: Theme.of(context).accentTextTheme.body1,
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: null,
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

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // GlobalKey for form validation
  final GlobalKey _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Widget background = Container(color: Colors.blue);
    Widget loginSheet = Container(
      height: MediaQuery.of(context).size.height / 1.5,
      width: MediaQuery.of(context).size.width,
      child: Material(
        borderRadius: BorderRadius.circular(35),
        color: Color(0xFFFFF9EE),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.mail_outline,
                      color: Colors.black26,
                    ),
                    contentPadding: EdgeInsets.all(12.0),
                    hintStyle: TextStyle(color: Colors.black26),
                    hintText: "john.doe@example.com",
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 0.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white),
                child: TextFormField(
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: Colors.black26,
                    ),
                    contentPadding: EdgeInsets.all(12.0),
                    hintStyle: TextStyle(color: Colors.black26),
                    hintText: "Password",
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 24.0, top: 6.0),
                alignment: Alignment.centerLeft,
                child: Text("Forgot Password"),
              ),
              Container(
                padding: EdgeInsets.all(24.0),
                child: MaterialButton(
                  onPressed: () {},
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  height: 50,
                  minWidth: MediaQuery.of(context).size.width,
                  color: Colors.blue,
                  child: Text(
                    "Log In",
                    style: TextStyle(
                      color: Color(0xFFFFF9EE),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 24.0, right: 24.0),
                child: MaterialButton(
                  onPressed: () {},
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  height: 50,
                  minWidth: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Text(
                    "Sign in with Google",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(24.0),
                alignment: Alignment.center,
                child: Text("Don't have an Account? Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );

    return Stack(
      children: <Widget>[
        background,
        Positioned(
          child: loginSheet,
          top: MediaQuery.of(context).size.height / 2.5,
        ),
      ],
    );
  }
}
