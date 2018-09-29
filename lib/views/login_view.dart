/// Login view screen
/// @author Julian Vu
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  static String tag = "login-view";
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {

    final logo = Hero(
      tag: "hero",
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset("assets/logo.png"),
      ),
    );
    
    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      style: Theme.of(context).accentTextTheme.body1,
      decoration: InputDecoration(
        hintText: "Email",
        hintStyle: TextStyle(color: Colors.black54,),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      ),
    );

    final password = TextFormField(
      autofocus: false,
      obscureText: true,
      style: Theme.of(context).accentTextTheme.body1,
      decoration: InputDecoration(
        hintText: "Password",
        hintStyle: TextStyle(color: Colors.black54,),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        shadowColor: Theme.of(context).primaryColorLight,
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          onPressed: () {},
          color: Theme.of(context).primaryColor,
          child: Text("Login", style: Theme.of(context).primaryTextTheme.body1,),
        ),
      ),
    );

    final forgotLabel = FlatButton(
      child: Text("Forgot password?", style: TextStyle(color: Colors.black54),),
      onPressed: () {},
    );

    return Scaffold(
      backgroundColor: Colors.white,
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
