import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:toast/toast.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:android_intent/android_intent.dart';
import 'package:userfront/models/merchant.dart';
import 'package:userfront/widgets/constants.dart';
import 'package:userfront/widgets/merchant_card.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  static const platformMethodChannel = const MethodChannel('merchant/getGPS');
  String nativeMessage = '';
  final PermissionHandler permissionHandler = PermissionHandler();
  Map<PermissionGroup, PermissionStatus> permissions;
  Geolocator geolocator = Geolocator();
  Position userLocation;
  List<Placemark> placemark;
  String sublocality = '';
  String city = '';
  String locationtoprint = 'Loading...';
  List<Merchant> m;
  List items = [
    {
      'imageurl': ['Loading'],
      'fullname': 'Loading',
      'shopname': 'Loading',
      'address': 'Loading'
    }
  ];
  @override
  void initState() {
    super.initState();
    print(items[0]);
    requestLocationPermission();
    //_gpsService();
    _getGPS();
    _getLocation().then((position) {
      setState(() {
        userLocation = position;
        getLocationCity(userLocation).then((place) {
          setState(() {
            placemark = place;
            sublocality = placemark[0].subLocality;
            city = placemark[0].locality;
            locationtoprint = sublocality + ', ' + city;
            getMerchantShops(userLocation, city).then((value) {
              setState(() {
                print('This is value');
                if (value == null) {
                } else {
                  items.clear();
                  items.add(value);
                  print(items.length);
                }
              });
            });
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Positioned(
                top: -120,
                right: -74,
                child: Image.asset('images/circle2.png')),
            Positioned(
              top: 60,
              left: 10,
              child: Text(
                'User_Front',
                style: TextStyle(fontSize: 24),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 120),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            locationtoprint,
                            style: TextStyle(
                                fontSize: 14, color: Color(0xff293340)),
                          ),
                          FlatButton(
                            child: Text(
                              'Change',
                              style: TextStyle(
                                  fontSize: 18, color: Color(0xff426ed9)),
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      height: 48,
                      decoration: BoxDecoration(
                          color: Color(0xfff6f7fb),
                          borderRadius: BorderRadius.all(Radius.circular(24))),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      color: Colors.grey[200],
                      child: ListView.builder(
                        itemCount: items.length + 1,
                        itemBuilder: (BuildContext context, int index) {
                          print(index);
                          if (index == 0) {
                            return Column(
                              children: <Widget>[
                                Container(
                                  color: Colors.orange,
                                  height: 200,
                                ),
                              ],
                            );
                          } else {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  MerchantCard(
                                    src: items[index - 1]['imageurl'],
                                    merchantShopName: items[index - 1]
                                        ['shopname'],
                                    merchantAddress: items[index - 1]
                                        ['address'],
                                    merchantCategory: items[index - 1]
                                        ['category'],
                                  )
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

//to know if gps is on
  Future<Null> _getGPS() async {
    String _message;
    try {
      final String result = await platformMethodChannel.invokeMethod('getGPS');
      _message = result;
      if (_message == 'false') {
        _checkGps(_message);
        print('this is _checkGps ' + _message);
      }
    } on PlatformException catch (e) {
      _message = "Can't do native stuff ${e.message}.";
    }
    setState(() {
      nativeMessage = _message;
    });
  }

  // to get location if gps is on
  Future<Position> _getLocation() async {
    var currentLocation;
    try {
      currentLocation = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }

  /*Show dialog if GPS not enabled and open settings location*/
  Future _checkGps(String message) async {
    print('running gps function2');
    if (message == 'false') {
      if (Theme.of(context).platform == TargetPlatform.android) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Can't get gurrent location"),
                content: const Text(
                    'Please make sure you enable GPS and set location mode to High accruacy and try again'),
                actions: <Widget>[
                  FlatButton(
                      child: Text('Ok'),
                      onPressed: () {
                        final AndroidIntent intent = AndroidIntent(
                            action:
                                'android.settings.LOCATION_SOURCE_SETTINGS');
                        intent.launch();
                        Navigator.of(context, rootNavigator: true)
                            .pop('dialog');
                      })
                ],
              );
            });
      }
    }
  }

  /*Checking if your App has been Given Permission*/
  Future<bool> requestLocationPermission({Function onPermissionDenied}) async {
    var granted = await _requestPermission(PermissionGroup.location);
    if (granted != true) {
      requestLocationPermission();
    }
    debugPrint('requestLocationPermission $granted');
    return granted;
  }

  //Code below is for asking location
  Future<bool> _requestPermission(PermissionGroup permission) async {
    final PermissionHandler _permissionHandler = PermissionHandler();
    var result = await _permissionHandler.requestPermissions([permission]);
    if (result[permission] == PermissionStatus.granted) {
      return true;
    }
    return false;
  }

  //get city name
  getLocationCity(Position userLocation) async {
    placemark = await Geolocator().placemarkFromCoordinates(
        userLocation.latitude, userLocation.longitude);
    // placemark =
    //   await Geolocator().placemarkFromCoordinates(19.151850, 72.937088);
    print(placemark[0].locality);
    return placemark;
  }

  getMerchantShops(location, city) async {
    print(location);
    var latitude = location.latitude.toString();
    var longitude = location.longitude.toString();
    try {
      Response response = await get(
        kurl + '/formaps',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'userlatitude': latitude,
          'userlongitude': longitude,
          'city': 'Thane',
        },
      ).timeout(const Duration(seconds: 10));
      String body = response.body;

      print(body);
      if (response.statusCode == 200) {
        return json.decode(body)['data'][0];
      } else {
        Toast.show(
          "Some error occurred",
          context,
          duration: 3,
          gravity: Toast.BOTTOM,
          textColor: Colors.black,
          backgroundColor: Colors.red[200],
        );
      }

      //call saving keys function
    } on TimeoutException catch (_) {
      Toast.show(
        "Check your internet connection",
        context,
        duration: 3,
        gravity: Toast.BOTTOM,
        textColor: Colors.black,
        backgroundColor: Colors.red[200],
      );
    } on SocketException catch (_) {
      Toast.show(
        "Check your internet connection",
        context,
        duration: 3,
        gravity: Toast.BOTTOM,
        textColor: Colors.black,
        backgroundColor: Colors.red[200],
      );
    }
  }
}
