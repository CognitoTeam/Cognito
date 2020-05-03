import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cognito/database/database.dart';
import 'package:cognito/models/academic_term.dart';
import 'package:cognito/views/login_selection_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main(){
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context){
    DataBase db = DataBase();
    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser>.value(
          value: FirebaseAuth.instance.onAuthStateChanged,
      ),
    ],
        child: new MaterialApp(
          title: "UniPlan",
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            buttonColor: Color(0xFFFF793F),
            iconTheme: IconThemeData(color: Colors.black, size: 20),
            primaryColor: Color(0xFF00227a),
            primaryColorLight: Color(0xFF6e74dc),
            primaryColorDark: Color(0xFFFFDA79),
            accentColor: Color(0xFFfbc02d),
            backgroundColor: Color(0xFFFFF9EE),
            primaryTextTheme: TextTheme(
                title: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                ),
                body1: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
                body2: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 15
                ),
            ),
            accentTextTheme:
              TextTheme(
                  body1: TextStyle(color: Colors.black45, fontFamily: 'Poppins')
              ),
            inputDecorationTheme: InputDecorationTheme(
              hintStyle: TextStyle(
                  color: Colors.black45,
                  fontFamily: 'Poppins',
                  fontSize: 14.0
              ),
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                ),
            ),
          home: LoginSelectionView(),
        )
    );
  }
}
