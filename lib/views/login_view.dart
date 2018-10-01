import 'dart:async';

import 'package:cognito/views/firebase_login.dart';
import 'package:cognito/views/home_view.dart';
/// Login view screen
/// @author Julian Vu
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  
  static String tag = "login-view";
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  FireBaseLogin _fireBaseLogin = FireBaseLogin();
  String _email;
  String _password;

final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<bool> _loginUser() async {
    _email = _emailController.text;
    _password = _passwordController.text;
    if(_email == null || _password == null){
      //print("Error null password or email " + "Email: " + _email + " Password: " + _password);
      return false;
    }else{
      final firebaseUser = await _fireBaseLogin.signEmailIn(_email, _password);
      if (firebaseUser != null) {
        return true;
      } else {
        return false;
      }
    }
  }

  
  @override
  Widget build(BuildContext context) {

    final logo = Hero(
      tag: "hero",
      child: CircleAvatar(

        backgroundColor: Colors.transparent,
        radius: 128.0,
        child: Image.asset("assets/circle_logo.png"),
      ),
    );
    
    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      style: Theme.of(context).primaryTextTheme.body1,
      controller: _emailController,
      decoration: InputDecoration(
        hintText: "Email",
        hintStyle: TextStyle(color: Colors.white70,),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      ),
    );

    final password = TextFormField(
      autofocus: false,
      obscureText: true,
      controller: _passwordController,
      style: Theme.of(context).primaryTextTheme.body1,
      decoration: InputDecoration(
        hintText: "Password",

      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: ButtonTheme(
        minWidth: 200.0,
        height: 42.0,
        child: RaisedButton(
          onPressed: () async {
                          bool b = await _loginUser();

                          b ? Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView()))
                              : print("Error Login failed!");
                                
                          },
                          
          color: Theme.of(context).accentColor,
          child: Text("Login", style: Theme.of(context).accentTextTheme.body1,),
        ),
      ),
    );

    final forgotLabel = FlatButton(
      child: Text("Forgot password?", style: TextStyle(color: Colors.black54),),
      onPressed: () {},
    );

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: 64.0,),
            email,
            SizedBox(height: 8.0,),
            password,
            SizedBox(height: 24.0,),
            loginButton,
            forgotLabel,
          ],
        ),
      ),
    );
  }
}
