import 'dart:math';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:toast/toast.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:userfront/models/Mixpanel.dart';
import 'constants.dart';

class Coupons extends StatefulWidget {
  @override
  _CouponsState createState() => _CouponsState();
}

class _CouponsState extends State<Coupons> {
  MixPanel mix = MixPanel();
  String status = 'Loading';
  List coupons = List();
  @override
  void initState() {
    super.initState();
    getCoupons().then((value) {
      setState(() {
        if (value != null) {
          coupons = value;
          print(coupons);
        }
        print(status);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(top: 60, left: 30, right: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Your Coupons',
              style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff293340)),
            ),
            Expanded(
              child: Container(
                child: ListView.builder(
                    itemCount: calclulateItemsLength(),
                    itemBuilder: (BuildContext context, int index) {
                      if (status == 'Loading') {
                        return Padding(
                          padding: EdgeInsets.only(top: 24),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300],
                            highlightColor: Colors.grey[100],
                            enabled: true,
                            child: Container(
                              padding: EdgeInsets.only(top: 24, left: 31),
                              height: 220,
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))),
                            ),
                          ),
                        );
                      } else if (status == 'Loaded') {
                        if (coupons[index]['valid'] == '1') {
                          return Padding(
                            padding: EdgeInsets.only(top: 24),
                            child: Container(
                                padding: EdgeInsets.only(top: 24, left: 31),
                                height: 220,
                                decoration: BoxDecoration(
                                    color: chooseColor(),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'DISCOUNT',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Text(
                                        '${coupons[index]['discount']}%',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 21),
                                      child: Row(
                                        children: <Widget>[
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                'EXPIRY',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 9,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 9.0),
                                                child: Text(
                                                  coupons[index]['enddate'],
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(left: 47),
                                            child: Column(
                                              children: <Widget>[
                                                Text(
                                                  'DISCOUNT UPTO',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 9,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10.0),
                                                  child: Text(
                                                    'Rs.${coupons[index]['faltdiscountupto']}',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 15),
                                      child: Text(
                                        'MERCHANT',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 8),
                                      child: Text(
                                        coupons[index]['merchantname'],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )
                                  ],
                                )),
                          );
                        } else {
                          return Padding(
                            padding: EdgeInsets.only(top: 24),
                            child: Container(
                                padding: EdgeInsets.only(top: 24, left: 31),
                                height: 220,
                                decoration: BoxDecoration(
                                    color: HSLColor.fromAHSL(1, 0, 0.67, 0.55)
                                        .toColor(),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'DISCOUNT',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10.0),
                                              child: Text(
                                                '${coupons[index]['discount']}%',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(right: 20),
                                          child: Text(
                                            'EXPIRED',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 22,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        )
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 21),
                                      child: Row(
                                        children: <Widget>[
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                'EXPIRY',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 9,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 9.0),
                                                child: Text(
                                                  coupons[index]['enddate'],
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(left: 47),
                                            child: Column(
                                              children: <Widget>[
                                                Text(
                                                  'DISCOUNT UPTO',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 9,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10.0),
                                                  child: Text(
                                                    'Rs.${coupons[index]['faltdiscountupto']}',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 15),
                                      child: Text(
                                        'MERCHANT',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 8),
                                      child: Text(
                                        coupons[index]['merchantname'],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )
                                  ],
                                )),
                          );
                        }
                      } else {
                        return Text('Some Error Occurred');
                      }
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }

  chooseColor() {
    int index = 1 + Random().nextInt(23);
    double hue = (index % 24) * 15.toDouble();
    print(hue);
    return HSLColor.fromAHSL(1, hue, 0.67, 0.55).toColor();
  }

  int calclulateItemsLength() {
    if (status == 'Loading') {
      return 1;
    } else if (status == 'Loaded') {
      return coupons.length;
    } else {
      return 1;
    }
  }

  getCoupons() async {
    SharedPreferences prefs =
        await SharedPreferences.getInstance(); //get instance of app memory
    final userkey = 'userid';
    String userid = prefs.getString(userkey);
    print(userid);
    try {
      Response response = await get(
        kurl + '/fetchCouponUser',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'userid': userid,
        },
      ).timeout(const Duration(seconds: 10));
      String body = response.body;
      print(body);
      String message = json.decode(body)['message'];
      int code = json.decode(body)['status'];
      //print(body);
      fetchCoupons(message);
      if (code == 200) {
        //print(body);
        setState(() {
          status = 'Loaded';
        });
        return json.decode(body)['data'];
      } else if (code == 404) {
        setState(() {
          status = 'No Coupons';
        });
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

  fetchCoupons(String message) async {
    mix.id = await mix.createMixPanel().then((_) {
      var result = mix.mixpanelAnalytics.track(
          event: 'fetchCoupons',
          properties: {'message': message, 'distinct_id': mix.id});
      result.then((value) {
        print('this is click login');
        print(value);
      });
      return;
    });
  }
}
