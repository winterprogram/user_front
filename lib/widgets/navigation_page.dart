import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/rendering.dart';
import 'package:userfront/widgets/payment_history_page.dart';
import 'package:userfront/widgets/profile_page.dart';
import 'package:userfront/widgets/search_page.dart';
import 'coupons_page.dart';
import 'dashboard.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Icon(FontAwesomeIcons.rupeeSign, size: 25, color: elementColor[1]),
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
          PaymentHistory(),
          Coupons(),
          Profile(),
        ],
        index: pageNumber,
      ),
    );
  }
}
