import 'dart:async';

import 'package:mixpanel_analytics/mixpanel_analytics.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class MixPanel {
  String id;
  final user = StreamController<String>.broadcast();
  String _error;
  String _success;
  MixpanelAnalytics mixpanelAnalytics;
  MixPanel() {
    getID().then((value) {
      this.id = value;
    });
    this.mixpanelAnalytics = MixpanelAnalytics(
      token: 'a86ebdc33c2fc94098a9bc92fbc53c88',
      userId$: this.user.stream,
      verbose: true,
      shaFn: (value) => value,
      onError: (e) => () {
        this._error = e;
        this._success = null;
      },
    );
    this.user.add(this.id);
  }
  Future getID() async {
    String identifier;
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        identifier = build.androidId; //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        identifier = data.identifierForVendor; //UUID for iOS
      }
    } on PlatformException {
      print('Failed to get platform version');
    }
    return identifier;
  }
}
