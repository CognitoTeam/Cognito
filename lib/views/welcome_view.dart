import 'package:cognito/views/update_user_info.dart';
import 'package:flutter/material.dart';

/// Welcome view
/// @author Praneet Singh

class WelcomeView extends StatefulWidget {
  static String tag = "home-view";
  @override
  _WelcomeViewState createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;
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
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      Text(
                        "Welcome to Cognito!",
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
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: ButtonTheme(
                        minWidth: 200.0,
                        height: 42.0,
                        child: RaisedButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UpdateUserInfo())),
                          color: Theme.of(context).accentColor,
                          child: Text(
                            "Let's get started!",
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
