import 'dart:async';

import 'package:mixpanel_analytics/mixpanel_analytics.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class MixPanel {
  String id;
  final _user$ = StreamController<String>.broadcast();
  String _error;
  String _success;
  MixpanelAnalytics mixpanelAnalytics;

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
    this.id = identifier;
    this._user$.add(identifier);
  }

  Future<void> createMixPanel() async {
    this.id = await getID().then((_) {
      this.mixpanelAnalytics = MixpanelAnalytics(
        token: 'a86ebdc33c2fc94098a9bc92fbc53c88',
        userId$: this._user$.stream,
        shouldAnonymize: false,
        verbose: true,
        shaFn: (value) => value,
        onError: (e) => () {
          this._error = e;
          this._success = null;
        },
      );

      this._user$.add(this.id);
      print(this.id);
      return id;
    });
  }
}
