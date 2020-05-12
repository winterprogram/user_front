import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'package:mixpanel_analytics/mixpanel_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:userfront/models/Mixpanel.dart';
import 'package:userfront/widgets/signup_page.dart';
import 'package:userfront/widgets/login_page.dart';

import 'navigation_page.dart';

// landing page
class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final user = StreamController<String>.broadcast();
  String _error;
  String _success;
  MixPanel m = MixPanel();

  @override
  void initState() {
    super.initState();
    checkfirstLogin();
  }

  signup(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUp()),
    );
    if (result == true) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            alignment: Alignment.bottomRight,
            image: AssetImage('images/login.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Image(
              image: AssetImage('images/logo.png'),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Container(
                    height: 48,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                      ),
                      child: Text('Login', style: TextStyle(fontSize: 15)),
                      onPressed: () {
                        onClickLandingPage('Login');
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Navigation()),
                        );
                      },
                      color: Colors.white,
                    ),
                  ),
                ), //Login Button
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Container(
                    height: 48,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                      ),
                      child: Text(
                        'Create an Account',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      onPressed: () {
                        onClickLandingPage('Signup');
                        signup(context);
                      },
                      color: Colors.transparent,
                    ),
                  ),
                ), //SignUp Button
              ],
            ),
          ],
        ),
      ),
    );
  }

  checkfirstLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var firstLogin = prefs.getBool('firstlogin');
    print(firstLogin);
    if (firstLogin != null && !firstLogin) {
      // Not first
    } else {
      // First time'
      print('firsttime');
      String deviceName;
      String identifier;
      String osVersion;
      String deviceBrand;
      final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
      try {
        if (Platform.isAndroid) {
          var build = await deviceInfoPlugin.androidInfo;
          osVersion = build.version.release;
          deviceBrand = build.brand;
          deviceName = build.model;
          identifier = build.androidId; //UUID for Android
        } else if (Platform.isIOS) {
          var data = await deviceInfoPlugin.iosInfo;
          deviceBrand = data.name;
          osVersion = data.systemVersion;
          deviceName = data.name;
          identifier = data.identifierForVendor; //UUID for iOS
        }
      } on PlatformException {
        print('Failed to get platform version');
      }
      print(deviceName);
      print(identifier);
      print(deviceBrand);
      print(osVersion);
      /*var result = _mixpanel.track(event: 'appInstall', properties: {
        'deviceName': deviceName,
        'deviceBrand': deviceBrand,
        'osVersion': osVersion,
        'installTime': DateTime.now().toString(),
      });*/

      var result = m.mixpanelAnalytics
          .engage(operation: MixpanelUpdateOperations.$set, value: {
        'deviceName': deviceName,
        'deviceBrand': deviceBrand,
        'osVersion': osVersion,
        'installTime': DateTime.now().toString(),
      });
      result.then((value) {
        print('This is first login');
        print(value);
      });
      prefs.setBool('firstlogin', false);
    }
  }

  onClickLandingPage(String button) {
    var result = m.mixpanelAnalytics
        .track(event: 'onClickLandingPage', properties: {'button': button});
    result.then((value) {
      print('this is on click');
      print(value);
    });
  }
}
