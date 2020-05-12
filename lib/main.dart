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
          display1: TextStyle(color: Colors.black, fontFamily: 'FiraSans'),
          display2: TextStyle(color: Colors.black, fontFamily: 'FiraSans'),
          display3: TextStyle(color: Colors.black, fontFamily: 'FiraSans'),
          display4: TextStyle(color: Colors.black, fontFamily: 'FiraSans'),
          body1: TextStyle(color: Colors.black, fontFamily: 'FiraSans'),
          body2: TextStyle(color: Colors.black, fontFamily: 'FiraSans'),
          headline: TextStyle(color: Colors.black, fontFamily: 'FiraSans'),
          title: TextStyle(color: Colors.black, fontFamily: 'FiraSans'),
          subhead: TextStyle(color: Colors.black, fontFamily: 'FiraSans'),
          subtitle: TextStyle(color: Colors.black, fontFamily: 'FiraSans'),
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
          display1: TextStyle(color: Colors.black, fontFamily: 'FiraSans'),
          display2: TextStyle(color: Colors.black, fontFamily: 'FiraSans'),
          display3: TextStyle(color: Colors.black, fontFamily: 'FiraSans'),
          display4: TextStyle(color: Colors.black, fontFamily: 'FiraSans'),
          body1: TextStyle(color: Colors.black, fontFamily: 'FiraSans'),
          body2: TextStyle(color: Colors.black, fontFamily: 'FiraSans'),
          headline: TextStyle(color: Colors.black, fontFamily: 'FiraSans'),
          title: TextStyle(color: Colors.black, fontFamily: 'FiraSans'),
          subhead: TextStyle(color: Colors.black, fontFamily: 'FiraSans'),
          subtitle: TextStyle(color: Colors.black, fontFamily: 'FiraSans'),
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
