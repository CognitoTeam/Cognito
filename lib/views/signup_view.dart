import 'package:cognito/database/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'dart:io';
import 'package:cognito/database/firebase_login.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:cognito/views/welcome_view.dart';

/// Sign up view screen
/// @author Praneet Singh

class SignUpView extends StatefulWidget {
  static String tag = "SignUp-view";
  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _formKey = GlobalKey<FormState>();
  final _passKey = GlobalKey<FormFieldState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  FireBaseLogin _fireBaseLogin = FireBaseLogin();
  String _email;
  String _password;
  String _confirmPassword;
  DataBase database = DataBase();

  void _submit(BuildContext context) {
    final form = _formKey.currentState;

    if (form.validate()) {
      form.save();
      _signUpUser(context);
    }
  }

  ///User sign up with email and password
  Future<bool> _signUpUser(BuildContext context) async {
    if (_email == null || _password == null || _confirmPassword == null) {
      return false;
    } else if (_password != _confirmPassword) {
      print("Password Dont match");
      return false;
    } else {
      try {
        final firebaseUser = await _fireBaseLogin.createEmailUser(_email, _password);
        firebaseUser.sendEmailVerification();
        if (firebaseUser != null) {
          database.initializeFireStore();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => WelcomeView()));
          return true;
        } else {
          return false;
        }
      } on PlatformException catch (e) {
        if (Platform.isIOS) {
          _scaffoldKey.currentState
              .showSnackBar(SnackBar(content: Text(e.details)));
        } else if (Platform.isAndroid) {
          _scaffoldKey.currentState
              .showSnackBar(SnackBar(content: Text(e.message)));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: "hero",
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 110.0,
        child: Image.asset("assets/logo-1024.png"),
      ),
    );

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      style: TextStyle(
        color: Colors.black,
      ),
      decoration: InputDecoration(
        hintText: "Email",
        hintStyle: TextStyle(
          color: Colors.black,
        ),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      ),
      validator: (val) => !val.contains('@') ? 'Invalid Email' : null,
      onSaved: (val) => _email = val,
    );

    final password = TextFormField(
      key: _passKey,
      autofocus: false,
      obscureText: true,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: "Password",
        hintStyle: TextStyle(
          color: Colors.black,
        ),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      ),
      validator: (val) => val.length < 6 ? 'Password too short' : null,
      onSaved: (val) => _password = val,
    );
    final confirmPassword = TextFormField(
      autofocus: false,
      obscureText: true,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: "Confirm password",
        hintStyle: TextStyle(
          color: Colors.black,
        ),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      ),
      validator: (confirmation) {
        String password = _passKey.currentState.value;
        return equals(confirmation, password)
            ? null
            : "Passwords do not match!";
      },
      onSaved: (val) => _confirmPassword = val,
    );
    final signUpButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: ButtonTheme(
        minWidth: 200.0,
        height: 42.0,
        child: RaisedButton(
          child: Text(
            "Sign Up",
            style: Theme.of(context).accentTextTheme.body1,
          ),
          color: Theme.of(context).accentColor,
          onPressed: () => _submit(context),
        ),
      ),
    );

    final cancelLabel = FlatButton(
      child: Text(
        "Cancel",
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: false,
        key: _scaffoldKey,
        body: Center(
          child: new Form(
            key: _formKey,
            child: new ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(bottom: 1.0, left: 24.0, right: 24.0),
              children: <Widget>[
                logo,
                SizedBox(
                  height: 16.0,
                ),
                email,
                SizedBox(
                  height: 16.0,
                ),
                password,
                SizedBox(
                  height: 16.0,
                ),
                confirmPassword,
                SizedBox(
                  height: 16.0,
                ),
                signUpButton,
                cancelLabel,
              ],
            ),
          ),
        ));
  }
}
