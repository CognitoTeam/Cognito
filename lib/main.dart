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
            splashColor: Colors.transparent,
            colorScheme: ColorScheme(
              background: Colors.transparent,
              primaryVariant: Colors.transparent,
              secondary: Color(0xFFFFB142),
              primary: Colors.transparent,
              onSurface: Colors.transparent,
              brightness: Brightness.dark,
              onPrimary: Colors.transparent,
              secondaryVariant: Color(0xFF746868),
              onBackground: Color(0xFF34ACE0),
              onError: Color(0xFFEB5757),
              onSecondary: Colors.transparent,
              surface: Colors.transparent,
              error: Colors.transparent,
            ),
            buttonColor: Color(0xFFFF793F),
            buttonTheme: ButtonThemeData( textTheme: ButtonTextTheme.accent),
            iconTheme: IconThemeData(color: Colors.black, size: 20),
            primaryColor: Color(0xFF00227a),
            primaryColorLight: Color(0xFF6e74dc),
            primaryColorDark: Color(0xFFFFDA79),
            accentColor: Color(0xFFfbc02d),
            backgroundColor: Color(0xFFFFF9EE),
            dialogBackgroundColor: Color(0xFFFFF9EE),
            primaryTextTheme: TextTheme(
              headline1: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold
              ),
                headline2: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
                headline3: GoogleFonts.poppins(
                    color: Color(0xFFFFF9EE),
                    fontSize: 15,
                    fontWeight: FontWeight.bold
                ),
                headline4: GoogleFonts.poppins(
                    color: Color(0xFFFFF9EE),
                    fontSize: 12,
                    fontWeight: FontWeight.bold
                ),
                headline5: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 13,
                ),
                headline6: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                ),
                bodyText1: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
                bodyText2: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 15
                ),
                button: GoogleFonts.poppins(
                    color: Color(0xFFFFF9EE),
                    fontSize: 15,
                    fontWeight: FontWeight.bold
                ),
                caption: GoogleFonts.poppins(
                    color: Color(0xFFFFF9EE),
                    fontSize: 15,
                    fontWeight: FontWeight.bold
                ),
                overline: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                ),
                subtitle1: GoogleFonts.poppins(
                    color: Color(0xFF746868),
                    fontSize: 16
                ),
                subtitle2: GoogleFonts.poppins(
                    color: Color(0xFF746868),
                    fontSize: 13
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
