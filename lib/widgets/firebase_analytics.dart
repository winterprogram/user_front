import 'dart:async';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class FireBaseAnalytics {
  String id;
  static FirebaseAnalytics analytics = FirebaseAnalytics();

  Future<void> logEvent(
      String eventName, Map<String, dynamic> parameters) async {
    await analytics.logEvent(name: eventName, parameters: parameters);
  }
}
