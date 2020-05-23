import 'package:flutter/material.dart';
import 'package:userfront/widgets/landing_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:userfront/widgets/navigation_page.dart';
//  show AppBar, BuildContext, Center, Colors, Column, FloatingActionButton, Icon, Icons, Key, MainAxisAlignment, MaterialApp, Scaffold, State, StatefulWidget, StatelessWidget, Text, Theme, ThemeData, Widget, runApp;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  var userid = prefs.getString('userid');

  print(userid);
  runApp(MaterialApp(
      theme: ThemeData.light().copyWith(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        textTheme: TextTheme(
          headline4: TextStyle(color: Colors.black, fontFamily: 'FiraSans'),
          headline3: TextStyle(color: Colors.black, fontFamily: 'FiraSans'),
          headline2: TextStyle(color: Colors.black, fontFamily: 'FiraSans'),
          headline1: TextStyle(color: Colors.black, fontFamily: 'FiraSans'),
          bodyText1: TextStyle(color: Colors.black, fontFamily: 'FiraSans'),
          bodyText2: TextStyle(color: Colors.black, fontFamily: 'FiraSans'),
          headline5: TextStyle(color: Colors.black, fontFamily: 'FiraSans'),
          headline6: TextStyle(color: Colors.black, fontFamily: 'FiraSans'),
          subtitle1: TextStyle(color: Colors.black, fontFamily: 'FiraSans'),
          subtitle2: TextStyle(color: Colors.black, fontFamily: 'FiraSans'),
          caption: TextStyle(color: Colors.black, fontFamily: 'FiraSans'),
          overline: TextStyle(color: Colors.black, fontFamily: 'FiraSans'),
          button: TextStyle(
            fontFamily: 'FiraSans',
          ),
        ),
      ),
      home: userid == null ? LandingPage() : Navigation()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        textTheme: TextTheme(
          headline4: TextStyle(color: Colors.black, fontFamily: 'FiraSans'),
          headline3: TextStyle(color: Colors.black, fontFamily: 'FiraSans'),
          headline2: TextStyle(color: Colors.black, fontFamily: 'FiraSans'),
          headline1: TextStyle(color: Colors.black, fontFamily: 'FiraSans'),
          bodyText1: TextStyle(color: Colors.black, fontFamily: 'FiraSans'),
          bodyText2: TextStyle(color: Colors.black, fontFamily: 'FiraSans'),
          headline5: TextStyle(color: Colors.black, fontFamily: 'FiraSans'),
          headline6: TextStyle(color: Colors.black, fontFamily: 'FiraSans'),
          subtitle1: TextStyle(color: Colors.black, fontFamily: 'FiraSans'),
          subtitle2: TextStyle(color: Colors.black, fontFamily: 'FiraSans'),
          caption: TextStyle(color: Colors.black, fontFamily: 'FiraSans'),
          overline: TextStyle(color: Colors.black, fontFamily: 'FiraSans'),
          button: TextStyle(
            fontFamily: 'FiraSans',
          ),
        ),
      ),
      home: LandingPage(),
    );
  }
}
