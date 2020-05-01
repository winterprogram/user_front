import 'package:flutter/material.dart';

class Coupons extends StatefulWidget {
  @override
  _CouponsState createState() => _CouponsState();
}

class _CouponsState extends State<Coupons> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
            color: Color(0xFFf1d300),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.vertical(
                  top: Radius.elliptical(30, 30),
                ),
              ),
            )));
  }
}
