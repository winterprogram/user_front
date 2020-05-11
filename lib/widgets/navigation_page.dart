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
    Colors.blue,
    Colors.blue,
    Colors.blue,
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
        /*bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              elementColor[0] = Colors.black;
              elementColor[1] = Colors.black;
              elementColor[2] = Colors.black;
              elementColor[3] = Colors.black;
              elementColor[index] = Colors.blue;
              pageNumber = index;
            });
          },
          currentIndex: pageNumber,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              title: Text('Home'),
              icon: Icon(Icons.home, size: 25, color: elementColor[0]),
            ),
            BottomNavigationBarItem(
              title: Text('Search'),
              icon: Icon(Icons.search, size: 25, color: elementColor[1]),
            ),
            BottomNavigationBarItem(
              title: Text('Coupons'),
              icon: Icon(Icons.pages, size: 25, color: elementColor[2]),
            ),
            BottomNavigationBarItem(
              title: Text('Profile'),
              icon: Icon(Icons.person, size: 25, color: elementColor[3]),
            )
          ],
        ),
        */
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
        body: _pageChooser(pageNumber));
  }
}
