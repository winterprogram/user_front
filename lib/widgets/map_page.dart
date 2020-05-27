import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:userfront/models/Mixpanel.dart';

class MapPage extends StatefulWidget {
  final Position userLocation;
  @override
  MapPage({this.userLocation});
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  MixPanel mix = MixPanel();
  String locationtoprint = 'Loading...';
  List<Placemark> placemark;
  String sublocality = '';
  String city = '';
  Position userLocation;
  StreamSubscription<LocationData> locationSubscription;
  LatLng userPosition;
  BitmapDescriptor pinLocationIcon;
  Set<Marker> _marker = Set();
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;
  var location = new Location();
  @override
  void initState() {
    super.initState();
    userLocation = widget.userLocation;
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(165, 200)), 'images/location_pin.png')
        .then((value) {
      pinLocationIcon = value;
    });
    getLocationCity(userLocation).then((place) {
      setState(() {
        placemark = place;
        sublocality = placemark[0].subLocality;
        city = placemark[0].locality;
        locationtoprint = sublocality + ', ' + city;
      });
    });
  }

  @override
  void dispose() {
    locationSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Stack(
                children: <Widget>[
                  GoogleMap(
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: false,
                    mapToolbarEnabled: false,
                    markers: _marker,
                    onTap: _handleTap,
                    compassEnabled: false,
                    tiltGesturesEnabled: false,
                    myLocationEnabled: true,
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(widget.userLocation.latitude,
                          this.widget.userLocation.longitude),
                      zoom: 17,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      _marker.add(Marker(
                        markerId: MarkerId(userLocation.toString()),
                        position: LatLng(
                            userLocation.latitude, userLocation.longitude),
                        icon: pinLocationIcon,
                      ));
                      _controller.complete(controller);
                      mapController = controller;
                      locationSubscription = location.onLocationChanged
                          .listen((LocationData position) {
                        setState(() {
                          userPosition =
                              LatLng(position.latitude, position.longitude);
                        });
                      });
                    },
                  ),
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: GestureDetector(
                      onTap: () {
                        goToMyLocation();
                      },
                      child: Container(
                        padding: EdgeInsets.all(15),
                        child: Icon(
                          Icons.my_location,
                          color: Color(0xff3A91EC),
                        ),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              height: 178,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 9.0),
                    child: Opacity(
                      opacity: 0.2,
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 30,
                          height: 2,
                          decoration: BoxDecoration(
                              color: Color(0xff979797),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24))),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 12, left: 20),
                    child: Text(
                      'SET YOUR LOCATION',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff293340)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20, left: 20),
                    child: Opacity(
                      opacity: 0.6,
                      child: Text('Location'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5, left: 20),
                    child: Text(
                      locationtoprint,
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xff293340),
                      ),
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 40,
                        width: 161,
                        child: RaisedButton(
                          child: Text(
                            'Confirm Location',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                          onPressed: () {
                            onClickConfirm();
                            Navigator.pop(context, userLocation);
                          },
                          color: Color(0xff3A91EC),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
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

  goToMyLocation() async {
    onClickCurrent();
    setState(() {
      userLocation = Position(
          latitude: userPosition.latitude, longitude: userPosition.longitude);
      _marker.clear();
      _marker.add(Marker(
        markerId: MarkerId(userPosition.toString()),
        position: LatLng(userPosition.latitude, userPosition.longitude),
        icon: pinLocationIcon,
      ));
    });
    getLocationCity(userLocation).then((place) {
      setState(() {
        placemark = place;
        sublocality = placemark[0].subLocality;
        city = placemark[0].locality;
        locationtoprint = sublocality + ', ' + city;
      });
    });
    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: userPosition, zoom: 17)));
  }

  _handleTap(LatLng point) {
    onClickMap();
    if (!mounted) {
      return;
    }
    setState(() {
      userLocation =
          Position(latitude: point.latitude, longitude: point.longitude);
      _marker.clear();
      _marker.add(Marker(
        markerId: MarkerId(userLocation.toString()),
        position: LatLng(userLocation.latitude, userLocation.longitude),
        icon: pinLocationIcon,
      ));
    });
    getLocationCity(userLocation).then((place) {
      setState(() {
        placemark = place;
        sublocality = placemark[0].subLocality;
        city = placemark[0].locality;
        locationtoprint = sublocality + ', ' + city;
      });
    });
    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: point, zoom: 17)));
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

  onClickCurrent() async {
    mix.id = await mix.createMixPanel().then((_) {
      var result = mix.mixpanelAnalytics.track(
          event: 'onClickMapPage',
          properties: {'button': 'currentLocation', 'distinct_id': mix.id});
      result.then((value) {
        print('this is click login');
        print(value);
      });
      return;
    });
  }

  onClickMap() async {
    mix.id = await mix.createMixPanel().then((_) {
      var result = mix.mixpanelAnalytics.track(
          event: 'onClickMapPage',
          properties: {'button': 'Map', 'distinct_id': mix.id});
      result.then((value) {
        print('this is click login');
        print(value);
      });
      return;
    });
  }

  onClickConfirm() async {
    mix.id = await mix.createMixPanel().then((_) {
      var result = mix.mixpanelAnalytics.track(
          event: 'onClickMapPage',
          properties: {
            'button': 'confirm',
            'location': locationtoprint,
            'distinct_id': mix.id
          });
      result.then((value) {
        print('this is click login');
        print(value);
      });
      return;
    });
  }
}
