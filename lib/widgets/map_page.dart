import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:userfront/widgets/firebase_analytics.dart';
import 'package:search_map_place/search_map_place.dart';
//import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:floating_search_bar/floating_search_bar.dart';
//import 'package:google_maps_webservice/places.dart';
import 'package:userfront/widgets/constants.dart';

import 'Mixpanel.dart';
import 'fcm_notification.dart';

class MapPage extends StatefulWidget {
  final Position userLocation;
  @override
  MapPage({this.userLocation});
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  FcmNotification fcm;
  //GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

  final _tcontroller = TextEditingController();
  FocusNode _focus = new FocusNode();
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
  //Mode _mode = Mode.overlay;
  @override
  void initState() {
    super.initState();
    mix.createMixPanel();
    fcm = new FcmNotification(context: context);
    fcm.initialize();
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
    _focus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    locationSubscription.cancel();
    _tcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Container(
                child: Stack(
                  fit: StackFit.expand,
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
                          anchor: Offset(0.5, 0.75),
                          draggable: false,
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
                    Positioned(
                      top: 10,
                      left: 15,
                      right: 15,
                      child: SearchMapPlaceWidget(
                        apiKey: kGoogleApiKey,
                        // The language of the autocompletion
                        language: 'en',
                        // The position used to give better recomendations. In this case we are using the user position
                        location: LatLng(
                            userLocation.latitude, userLocation.longitude),
                        radius: 30000,
                        onSelected: (Place place) async {
                          final geolocation = await place.geolocation;

                          mapController.animateCamera(
                              CameraUpdate.newLatLng(geolocation.coordinates));
                          mapController.animateCamera(
                              CameraUpdate.newLatLngBounds(
                                  geolocation.bounds, 0));
                        },
                      ),
                    )
                    /*Positioned(
                      top: 10,
                      left: 15,
                      right: 15,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.white,
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Expanded(
                                  child: TextField(
                                    onChanged:(String str){

                      },
                                    onTap: autoComplete(),
                                    controller: _tcontroller,
                                    focusNode: _focus,
                                    cursorColor: Colors.black,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.go,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 15),
                                        hintText: "Search..."),
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      _tcontroller.clear();
                                      _focus.unfocus();
                                    },
                                    icon: Icon(Icons.cancel))
                              ],
                            ),
                            Visibility(
                                child: Container(
                              color: Colors.grey[100],
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: 2,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(height: 20);
                                  }),
                            ))
                          ],
                        ),
                      ),
                    ),*/
                  ],
                ),
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

  /*autoComplete() async {
    Prediction p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      mode: _mode,
      language: "en",
      components: [Component(Component.country, "in")],
    );
    displayPrediction(p);
  }

  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      // get detail (lat/lng)
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId)

      print(detail.result.addressComponents);
    }
  }

  void onError(PlacesAutocompleteResponse response) {
    Scaffold.of(context).showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }*/

  void _onFocusChange() {
    debugPrint("Focus: " + _focus.hasFocus.toString());
  }

  goToMyLocation() async {
    onClickCurrent();
    setState(() {
      userLocation = Position(
          latitude: userPosition.latitude, longitude: userPosition.longitude);
      _marker.clear();
      _marker.add(Marker(
        anchor: Offset(0.5, 0.75),
        draggable: false,
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
        anchor: Offset(0.5, 0.75),
        draggable: false,
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
    fcm.getToken().then((token) {
      var result = mix.mixpanelAnalytics.track(
          event: 'onClickMapPage',
          properties: {'button': 'currentLocation', 'distinct_id': token});
    });
  }

  onClickMap() async {
    fcm.getToken().then((token) {
      var result = mix.mixpanelAnalytics.track(
          event: 'onClickMapPage',
          properties: {'button': 'Map', 'distinct_id': token});
    });
  }

  onClickConfirm() async {
    fcm.getToken().then((token) {
      var result = mix.mixpanelAnalytics.track(
          event: 'onClickMapPage',
          properties: {
            'button': 'confirm',
            'location': locationtoprint,
            'distinct_id': token
          });
    });
  }
}
