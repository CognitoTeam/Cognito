import 'package:cognito/database/database.dart';
import 'package:cognito/models/academic_term.dart';
import 'package:cognito/models/class.dart';
import 'package:cognito/models/gpa_calculator.dart';
import 'package:cognito/views/main_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class GPAView extends StatefulWidget {
  final AcademicTerm term;

  GPAView(this.term);

  @override
  _GPAViewState createState() => _GPAViewState();
}

class _GPAViewState extends State<GPAView> {
  DataBase database = DataBase();

  List<Widget> allTermGPA(List<AcademicTerm> terms, FirebaseUser user) {
    List<Widget> all = List();
    GPACalculator gpa = GPACalculator();
    for (AcademicTerm t in terms) {
      gpa.addTerm(t, user);
    }
    //Get GPA of each term
    for (AcademicTerm t in gpa.termsMap.keys) {
      all.add(ListTile(
        title: Text(t.termName),
        trailing: Text(gpa.termsMap[t].toStringAsFixed(2)),
      ));
    }
    return all;
  }

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  double calculateGPA(List<AcademicTerm> terms, FirebaseUser user) {
    GPACalculator gpa = GPACalculator();
    for (AcademicTerm t in terms) {
      gpa.addTerm(t, user);
    }
    return gpa.gpa;
  }

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text("GPA", style: Theme
            .of(context)
            .primaryTextTheme
            .title,),
        backgroundColor: Theme
            .of(context)
            .primaryColorDark,),
      body: ListView(
        children: <Widget>[
            StreamBuilder<List<AcademicTerm>>(
            stream: database.streamTerms(user),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.done || snapshot.connectionState == ConnectionState.active)
              {
                if (snapshot.data != null) {
                  Map<AcademicTerm, List<Class>> termsMap = Map();
                  List<AcademicTerm> terms = snapshot.data;
                  for(int i = 0; i < terms.length; i++)
                  {
                    AcademicTerm term = terms[i];
                    return StreamBuilder<List<Class>>(
                      stream: database.streamClasses(user, term),
                      builder: (context, snapshot) {
                        List<Class> classes = snapshot.data;
                        termsMap[term] = classes;
                        return Container();
                      },
                    );
                  }
                  return ListTile(title: Text("Overall GPA:"),
                    trailing: Text(
                        calculateGPA(terms, user).toStringAsFixed(2)),);
                }
                else
                {
                  return new Container(
                    child: Center(child: Text("No GPA Yet"),),);
                }
              }
              else{
                return new Container(
                  child: Center(child: Text("Loading your GPA..." ),),);
              }
            },
          ),

          StreamBuilder<List<AcademicTerm>>(
            stream: database.streamTerms(user),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.done || snapshot.connectionState == ConnectionState.active)
              {
                if (snapshot.data != null) {
                  Map<AcademicTerm, List<Class>> termsMap = Map();
                  List<AcademicTerm> terms = snapshot.data;
                  for(int i = 0; i < terms.length; i++)
                  {
                    AcademicTerm term = terms[i];
                    return StreamBuilder<List<Class>>(
                      stream: database.streamClasses(user, term),
                      builder: (context, snapshot) {
                        List<Class> classes = snapshot.data;
                        termsMap[term] = classes;
                        return Container();
                      },
                    );
                  }
                  return ListTile(title: Text("Overall GPA:"),
                    trailing: Text(
                        calculateGPA(terms, user).toStringAsFixed(2)),);
                }
                else
                {
                  return new Container(
                    child: Center(child: Text("No GPA Yet"),),);
                }
              }
              else{
                return new Container(
                  child: Center(child: Text("Loading your GPA..." ),),);
              }
            },
          ),
        ],
      ),
    );
  }
}
