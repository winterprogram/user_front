import 'package:flutter/material.dart';

import 'fcm_notification.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  FcmNotification fcm;

  @override
  void initState() {
    super.initState();
    fcm = new FcmNotification(context: context);
    fcm.initialize();
  }

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
