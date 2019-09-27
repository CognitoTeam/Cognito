import 'package:cognito/views/academic_term_view.dart';
import 'package:flutter/material.dart';
import 'package:cognito/database/firebase_login.dart';

class UpdateUserInfo extends StatefulWidget {
  static String tag = "home-view";
  @override
  _UpdateUserInfoState createState() => _UpdateUserInfoState();
}

class _UpdateUserInfoState extends State<UpdateUserInfo>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;
  FireBaseLogin _fireBaseLogin = FireBaseLogin();
  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
        duration: new Duration(milliseconds: 3000), vsync: this);
    animation = new CurvedAnimation(
        parent: animationController, curve: Curves.elasticOut)
      ..addListener(() => this.setState(() {}))
      ..addStatusListener((AnimationStatus status) {});
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      Text(
                        "What should we call you?",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: animation.value * 25),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      controller: _firstName,
                      keyboardType: TextInputType.text,
                      autofocus: false,
                      style: Theme.of(context).primaryTextTheme.body1,
                      decoration: InputDecoration(
                        hintText: "First name",
                        hintStyle: TextStyle(
                          color: Colors.white70,
                        ),
//                        contentPadding:
//                            EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),

                      ),
                    ), 
                    TextFormField(
                      controller: _lastName,
                      keyboardType: TextInputType.text,
                      autofocus: false,
                      style: Theme.of(context).primaryTextTheme.body1,
                      decoration: InputDecoration(
                        hintText: "Last name",
                        hintStyle: TextStyle(
                          color: Colors.white70,
                        ),
//                        contentPadding:
//                            EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      ),
                    ), 
                  ],
                ),
              ),
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: ButtonTheme(
                        minWidth: 200.0,
                        height: 42.0,
                        child: RaisedButton(
                          onPressed: () async{
                            await _fireBaseLogin.updateUser(_firstName.text, _lastName.text);
                            String user = await _fireBaseLogin.userName();
                            print(user);
                            print(_firstName.text+ _lastName.text);
                            Navigator.pushAndRemoveUntil(context, 
                            MaterialPageRoute(builder: (context) => 
                                AcademicTermView()), ModalRoute.withName("/Home"));
                                },
                          color: Theme.of(context).accentColor,
                          child: Text(
                            "Start!",
                            style: Theme.of(context).accentTextTheme.body1,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
