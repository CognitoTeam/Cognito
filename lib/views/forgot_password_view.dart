/// Forgot password view screen
/// @author Praneet Singh
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'dart:io';
import 'dart:async';
import 'package:cognito/views/firebase_login.dart';
class ForgotPasswordView extends StatefulWidget {
  
  static String tag = "Forgot_Password_View_view";
  @override
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView > {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  FireBaseLogin _fireBaseLogin = FireBaseLogin();
  String _email;

void _submit() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      _forgotPassword();
    }
  }

  Future<bool> _forgotPassword() async {
    print(_email);
    if(_email == null){
      print("Error null email " + "Email: " + _email);
      return false;
    }else{
      try{
       await _fireBaseLogin.sendPasswordResetEmail(_email);
       Navigator.pop(context);
        return true;
      }on PlatformException catch(e){
        if(Platform.isIOS){
          _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(e.details)));
        }else if(Platform.isAndroid){
          _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(e.message)));
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
        radius: 100.0,
        child: Image.asset("assets/circle_logo.png"),
      ),
    );
    
    final email = TextFormField(
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        style: Theme.of(context).primaryTextTheme.body1,
        decoration: InputDecoration(
        hintText: "Email",
        hintStyle: TextStyle(color: Colors.white70,),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      ),
        validator: (val) =>
                !val.contains('@') ? 'Invalid Email' : null,
        onSaved: (val) => _email = val,
      );

    final resetButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: ButtonTheme(
        minWidth: 200.0,
        height: 42.0,
        child: RaisedButton(
                   child: Text("Request reset email", style: Theme.of(context).accentTextTheme.body1,),
                  color: Theme.of(context).accentColor,
                  onPressed: _submit,
                )
      ),
    );
    
    final cancelLabel = FlatButton(
      child: Text("Cancel", style: TextStyle(color: Colors.black54),),
      onPressed: () {Navigator.pop(context);},
    );

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).primaryColor,
      resizeToAvoidBottomPadding: false, 
      body: new Padding(
          padding: const EdgeInsets.all(30.0),
          child: new Form(
            key: _formKey,
            child: new Column(
              children: <Widget>[
                logo,
                SizedBox(height: 64.0,),
                email,
                SizedBox(height: 24.0,),
                resetButton,
                cancelLabel,
              ],
            ),
          ),
        )
    );
  }
}
