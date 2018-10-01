import 'dart:async';

import 'package:cognito/views/firebase_login.dart';
import 'package:cognito/views/home_view.dart';
/// Sign up view screen
/// @author Praneet Singh
/// 
import 'package:flutter/material.dart';

class SignUpView extends StatefulWidget {
  
  static String tag = "SignUp-view";
  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {

  FireBaseLogin _fireBaseLogin = FireBaseLogin();
  String _email;
  String _password;
  String _confirmPassword;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Future<bool> _SignUpUser() async {
    _email = _emailController.text;
    _password = _passwordController.text;
    _confirmPassword = _confirmPasswordController.text;
    if(_email == null || _password == null || _confirmPassword == null){
      print("Error null password or email " + "Email: " + _email + " Password: " + _password);
      return false;
      
    }else if(_password != _confirmPassword){
      print("Password");
        return false;
    }else{
      final firebaseUser = await _fireBaseLogin.createEmailUser(_email, _password);
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
    final confirmPassword = TextFormField(
      autofocus: false,
      obscureText: true,
      controller: _confirmPasswordController,
      validator: (value) {
        if(value != _password){
          print("value");
          return 'Passwords do not match!';
        }
      },
      style: Theme.of(context).primaryTextTheme.body1,
      decoration: InputDecoration(
        hintText: "Confirm Password",
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: ButtonTheme(
        minWidth: 200.0,
        height: 42.0,
        child: RaisedButton(
          onPressed: () async {
                          bool b = await _SignUpUser();
                          b ? Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView()))
                              : print("Error SignUp failed!");
                                
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
            confirmPassword,
            SizedBox(height: 24.0,),
            loginButton,
            forgotLabel,
          ],
        ),
      ),
    );
  }
}
