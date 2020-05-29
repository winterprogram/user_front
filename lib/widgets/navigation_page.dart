import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/rendering.dart';
import 'package:userfront/widgets/profile_page.dart';
import 'package:userfront/widgets/search_page.dart';
import 'coupons_page.dart';
import 'dashboard.dart';

class Navigation extends StatefulWidget {
  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  //final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  //final Firestore _db = Firestore.instance;
  //final FirebaseMessaging _fcm = FirebaseMessaging();
  //StreamSubscription iosSubscription;
  int pageNumber = 0;
  List<Color> elementColor = [
    Colors.white,
    Colors.blue,
    Colors.blue,
    Colors.blue,
  ];
  /*@override
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
        // save the token  OR subscribe to a topic here
      });
    }
    _fcm.requestNotificationPermissions(IosNotificationSettings());
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        final snackbar = SnackBar(
          content: Text(message['notification']['body']),
          behavior: SnackBarBehavior.floating,
          elevation: 3.0,
        );
        _scaffoldKey.currentState.showSnackBar(snackbar);
        /*showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );*/
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // TODO optional
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // TODO optional
      },
    );
  }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //key: _scaffoldKey,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey[400]))),
        child: CurvedNavigationBar(
          index: 0,
          color: Colors.white,
          buttonBackgroundColor: Colors.blue,
          animationDuration: Duration(milliseconds: 200),
          height: 50,
          backgroundColor: Colors.white,
          items: <Widget>[
            Icon(Icons.home, size: 25, color: elementColor[0]),
            Icon(Icons.search, size: 25, color: elementColor[1]),
            Icon(Icons.pages, size: 25, color: elementColor[2]),
            Icon(Icons.person, size: 25, color: elementColor[3]),
          ],
          onTap: (index) {
            setState(() {
              elementColor[0] = Colors.blue;
              elementColor[1] = Colors.blue;
              elementColor[2] = Colors.blue;
              elementColor[3] = Colors.blue;
              elementColor[index] = Colors.white;
              pageNumber = index;
            });
          },
        ),
      ),
      body: IndexedStack(
        children: <Widget>[
          Dashboard(),
          Search(),
          Coupons(),
          Profile(),
        ],
        index: pageNumber,
      ),
    );
  }
}
