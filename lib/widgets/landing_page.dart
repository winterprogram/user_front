import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info/device_info.dart';
import 'package:userfront/widgets/firebase_analytics.dart';
import 'package:userfront/widgets/signup_page.dart';
import 'package:userfront/widgets/login_page.dart';
import 'package:mixpanel_analytics/mixpanel_analytics.dart';
import 'Mixpanel.dart';
import 'fcm_notification.dart';

// landing page
class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  FcmNotification fcm;
  MixPanel mix = MixPanel();
  FireBaseAnalytics fba = FireBaseAnalytics();
  final PermissionHandler permissionHandler = PermissionHandler();
  Map<PermissionGroup, PermissionStatus> permissions;
  @override
  void initState() {
    super.initState();
    mix.createMixPanel();
    fcm = new FcmNotification(context: context);
    fcm.initialize();
    checkfirstLogin();
  }

  signup(BuildContext context) async {
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
                          MaterialPageRoute(builder: (context) => Login()),
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
      String osName;
      String deviceBrand;
      final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
      try {
        if (Platform.isAndroid) {
          var build = await deviceInfoPlugin.androidInfo;
          osName = 'Android';
          osVersion = build.version.release;
          deviceBrand = build.brand;
          deviceName = build.model;
          identifier = build.androidId; //UUID for Android
        } else if (Platform.isIOS) {
          var data = await deviceInfoPlugin.iosInfo;
          osName = 'IOS';
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
      var result = mix.mixpanelAnalytics
          .engage(operation: MixpanelUpdateOperations.$set, value: {
        'osName': osName,
        'deviceName': deviceName,
        'deviceBrand': deviceBrand,
        'osVersion': osVersion,
        'installTime': DateTime.now().toUtc().toIso8601String(),
        'distinct_id': fcm.getToken()
      });
      result.then((value) {
        print('This is first login');
        print(value);
      });

      prefs.setBool('firstlogin', false);
    }
  }

  onClickLandingPage(String button) async {
    fcm.getToken().then((value) {
      print(value);
      var result = mix.mixpanelAnalytics.track(
          event: 'onClickLandingPage',
          properties: {'button': button, 'distinct_id': value});
      result.then((value) {
        print('this is on click');
        print(value);
      });
    });
  }
}
