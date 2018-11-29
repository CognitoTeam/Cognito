import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'dart:io';
import 'dart:async';
import 'package:cognito/database/firebase_login.dart';
import 'package:cognito/views/forgot_password_view.dart';
import 'package:cognito/views/academic_term_view.dart';

/// Login view screen
/// @author Julian Vu

class LoginView extends StatefulWidget {
  static String tag = "login-view";
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  FireBaseLogin _fireBaseLogin = FireBaseLogin();
  String _email;
  String _password;

  void _submit() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      _loginUser();
    }
  }

  ///User can login if email and passowrd are not null and
  ///firebase accepts the account
  Future<bool> _loginUser() async {
    print(_email);
    print(_password);
    if (_email == null || _password == null) {
      print("Error null password or email " +
          "Email: " +
          _email +
          " Password: " +
          _password);
      return false;
    } else {
      try {
        final firebaseUser =
            await _fireBaseLogin.signEmailIn(_email, _password);
        if (firebaseUser.isEmailVerified == false) {
          firebaseUser.sendEmailVerification();
        }
        if (firebaseUser != null) {
          print("Logged in!");
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => AcademicTermView()),
              ModalRoute.withName("/Home"));
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
          color: Colors.black45,
        ),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      ),
      validator: (val) => !val.contains('@') ? 'Invalid Email' : null,
      onSaved: (val) => _email = val,
    );

    final password = TextFormField(
      autofocus: false,
      obscureText: true,
      style: TextStyle(
        color: Colors.black,
      ),
      decoration: InputDecoration(
        hintText: "Password",
        hintStyle: TextStyle(
          color: Colors.black45,
        ),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      ),
      validator: (val) => val.length < 6 ? 'Password too short' : null,
      onSaved: (val) => _password = val,
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: ButtonTheme(
          minWidth: 200.0,
          height: 42.0,
          child: RaisedButton(
            child: Text(
              "Login",
              style: Theme.of(context).accentTextTheme.body1,
            ),
            color: Theme.of(context).accentColor,
            onPressed: _submit,
          )),
    );

    final forgotLabel = FlatButton(
      child: Text(
        "Forgot password?",
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ForgotPasswordView()));
      },
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
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: false,
        body: Center(
          child: new Form(
            key: _formKey,
            child: new ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 24.0, right: 24.0, bottom: 25.0),
              children: <Widget>[
                logo,
                SizedBox(
                  height: 15.0,
                ),
                email,
                SizedBox(
                  height: 15.0,
                ),
                password,
                loginButton,
                forgotLabel,
                cancelLabel,
              ],
            ),
          ),
        ));
  }
}
