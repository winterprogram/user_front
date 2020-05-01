import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:userfront/widgets/profile_page.dart';
import 'package:userfront/widgets/search_page.dart';
import 'coupons_page.dart';
import 'dashboard.dart';
import 'landing_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Navigation extends StatefulWidget {
  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int pageNumber = 0;
  List<Color> elementColor = [
    Colors.white,
    Color(0xFFf1d300),
    Color(0xFFf1d300),
    Color(0xFFf1d300)
  ];
  Widget _pageChooser(int page) {
    switch (page) {
      case 0:
        return Dashboard();
        break;
      case 1:
        return Search();
        break;
      case 2:
        return Coupons();
        break;
      case 3:
        return Profile();
        break;
      default:
        return Container(
            child: Center(
          child: Text(
            'No page found',
            style: TextStyle(fontSize: 35),
          ),
        ));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Icon(null),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app, size: 35),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove('userid');
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext ctx) => LandingPage()),
                    ModalRoute.withName('/'));
              },
            ),
          ],
          backgroundColor: Color(0xFFf1d300),
          elevation: 0,
        ),
        bottomNavigationBar: CurvedNavigationBar(
          index: 0,
          color: Colors.white,
          buttonBackgroundColor: Color(0xFFf1d300),
          animationDuration: Duration(milliseconds: 200),
          height: 60,
          backgroundColor: Colors.grey[300],
          items: <Widget>[
            Icon(Icons.home, size: 35, color: elementColor[0]),
            Icon(Icons.search, size: 35, color: elementColor[1]),
            Icon(Icons.pages, size: 35, color: elementColor[2]),
            Icon(Icons.person, size: 35, color: elementColor[3]),
          ],
          onTap: (index) {
            setState(() {
              elementColor[0] = Color(0xFFf1d300);
              elementColor[1] = Color(0xFFf1d300);
              elementColor[2] = Color(0xFFf1d300);
              elementColor[3] = Color(0xFFf1d300);
              elementColor[index] = Colors.white;
              pageNumber = index;
            });
          },
        ),
        body: _pageChooser(pageNumber));
  }
}
