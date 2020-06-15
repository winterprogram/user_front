import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'dart:async';
import 'dart:io';
import 'package:toast/toast.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:userfront/widgets/firebase_analytics.dart';
import 'package:userfront/widgets/summary_page.dart';
import 'Mixpanel.dart';
import 'constants.dart';
import 'package:shimmer/shimmer.dart';

import 'fcm_notification.dart';

class Coupon extends StatefulWidget {
  final double amount;
  @override
  Coupon(this.amount);
  @override
  _CouponState createState() => _CouponState();
}

class _CouponState extends State<Coupon> {
  FcmNotification fcm;
  MixPanel mix = MixPanel();
  String userid;
  String merchantid;
  double amount;
  final _controller = TextEditingController();
  String couponinitial;
  bool _autoValidate = false;
  final _formKey = GlobalKey<FormState>();
  Position userLocation;
  String couponcode;
  String status = 'Loading';
  List coupons = List();
  double discount;
  double faltdiscountupto;

  @override
  void initState() {
    super.initState();
    mix.createMixPanel();
    fcm = new FcmNotification(context: context);
    fcm.initialize();
    amount = this.widget.amount;
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 65.0),
                child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ),
              Padding(
                padding: EdgeInsets.only(left: 24, top: 26),
                child: Text(
                  'Apply Coupons',
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff293340),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 26.0, right: 24),
                child: Form(
                  key: _formKey,
                  autovalidate: _autoValidate,
                  child: Container(
                    child: TextFormField(
                      readOnly: true,
                      controller: _controller,
                      onSaved: (String value) {
                        couponcode = value;
                      },
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        suffixIcon: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 3, horizontal: 15),
                            height: 48,
                            decoration: BoxDecoration(
                                color: Color(0xff426ed9),
                                border: Border.all(color: Color(0xff00a5ec)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(24))),
                            child: IconButton(
                              onPressed: () {
                                onTapCoupon(
                                    _controller.text, 'ForwardCouponSelect');
                                print(_controller.text);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Summary(
                                              amount: amount,
                                              couponcode: _controller.text,
                                              discount: discount,
                                              faltdiscountupto:
                                                  faltdiscountupto,
                                              merchantid: merchantid,
                                              userid: userid,
                                            )));
                              },
                              icon: Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              ),
                            )),
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff426ed9)),
                            borderRadius:
                                BorderRadius.all(Radius.circular(24))),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff426ed9)),
                            borderRadius:
                                BorderRadius.all(Radius.circular(24))),
                        hintText: 'Enter Coupon Code',
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 17.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Divider(),
                    ),
                    Opacity(
                      opacity: 0.7,
                      child: Text(
                        'TAP TO COPY THE CODE',
                        style:
                            TextStyle(color: Color(0xff293340), fontSize: 11),
                      ),
                    ),
                    Expanded(
                      child: Divider(),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.only(top: 32, left: 24, right: 21),
                    child: ListView.builder(
                        itemCount: calclulateItemsLength(),
                        itemBuilder: (BuildContext context, int index) {
                          if (status == 'Loading') {
                            return Container(
                              height: 146,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  DottedBorder(
                                    dashPattern: [6, 3],
                                    borderType: BorderType.RRect,
                                    radius: Radius.circular(6),
                                    padding: EdgeInsets.all(0),
                                    color: Color(0xff37c898).withOpacity(0.5),
                                    child: Container(
                                      height: 32,
                                      width: 89,
                                      color:
                                          Color(0xff37c898).withOpacity(0.05),
                                      child: Center(
                                        child: Shimmer.fromColors(
                                          baseColor: Colors.grey[300],
                                          highlightColor: Colors.grey[100],
                                          enabled: true,
                                          child: Text('TVHSBC40',
                                              style: TextStyle(
                                                  color: Color(0xff1ea896),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 7.0),
                                    child: Shimmer.fromColors(
                                      baseColor: Colors.grey[300],
                                      highlightColor: Colors.grey[100],
                                      enabled: true,
                                      child: Text('Get 40% cashback',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff293340))),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 9),
                                    child: Opacity(
                                      opacity: 0.7,
                                      child: Shimmer.fromColors(
                                        baseColor: Colors.grey[300],
                                        highlightColor: Colors.grey[100],
                                        enabled: true,
                                        child: Text(
                                          'Use code WHATSNEW & get 25% discount upto Rs. 150 on your order.',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xff293340),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Divider()),
                                ],
                              ),
                            );
                          } else if (status == 'Loaded') {
                            return GestureDetector(
                              onTap: () {
                                onTapCoupon(
                                    coupons[index]['couponcode'], 'couponcard');
                                setState(() {
                                  _controller.text =
                                      coupons[index]['couponcode'];
                                  discount =
                                      double.parse(coupons[index]['discount']);
                                  faltdiscountupto = double.parse(
                                      coupons[index]['faltdiscountupto']);

                                  print(couponinitial);
                                });
                              },
                              child: Container(
                                height: 146,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    DottedBorder(
                                      dashPattern: [6, 3],
                                      borderType: BorderType.RRect,
                                      radius: Radius.circular(6),
                                      padding: EdgeInsets.all(0),
                                      color: Color(0xff37c898).withOpacity(0.5),
                                      child: Container(
                                        height: 32,
                                        width: 89,
                                        color:
                                            Color(0xff37c898).withOpacity(0.05),
                                        child: Center(
                                          child: Text(
                                              coupons[index]['couponcode'],
                                              style: TextStyle(
                                                  color: Color(0xff1ea896),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500)),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 7.0),
                                      child: Text(
                                          'Get ${coupons[index]['discount']} cashback',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff293340))),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 9),
                                      child: Opacity(
                                        opacity: 0.7,
                                        child: Text(
                                          'Use code WHATSNEW & get ${coupons[index]['discount']} discount upto Rs. ${coupons[index]['faltdiscountupto']} on your order.',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xff293340),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Divider()),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return Container(
                                child: Text(
                                    'No Coupons Active for this merchant'));
                          }
                        }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
    final merchantkey = 'merchantid';
    userid = prefs.getString(userkey);
    merchantid = prefs.getString(merchantkey);
    print(merchantid);
    print(userid);
    try {
      Response response = await get(
        kurl + '/couponforCheckOut',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'userid': userid,
          'merchantid': merchantid,
        },
      ).timeout(const Duration(seconds: 10));
      String body = response.body;
      String message = json.decode(body)['message'];
      int code = json.decode(body)['status'];
      //onFetchCoupon(message);
      //print(body);
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

  onFetchCoupon(String message) async {
    fcm.getToken().then((token) {
      var result = mix.mixpanelAnalytics.track(
          event: 'fetchCoupon',
          properties: {'message': message, 'distinct_id': token});
    });
  }

  onTapCoupon(String couponCode, String button) async {
    fcm.getToken().then((token) {
      var result = mix.mixpanelAnalytics.track(
          event: 'onClickCouponPage',
          properties: {
            'coupon': couponCode,
            'button': button,
            'distinct_id': token
          });
    });
  }
}
