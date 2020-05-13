import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:userfront/models/Mixpanel.dart';
import 'package:userfront/widgets/constants.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

import 'navigation_page.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  MixPanel m = MixPanel();
  bool _autoValidate = false;
  SharedPreferences prefs;
  final _formKey = GlobalKey<FormState>();
  String phone;
  String password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            child: Stack(
          children: <Widget>[
            Container(
              alignment: Alignment(-1, -1),
              child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),
            Container(
              alignment: Alignment(-0.4, -0.6),
              child: Text(
                'Enter your login credentials',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Positioned(
              right: 20,
              top: -180,
              child: Container(
                child: Image.asset('images/circle.png'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: EdgeInsets.all(15),
                alignment: Alignment.center,
                child: Form(
                  autovalidate: _autoValidate,
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(),
                        child: TextFormField(
                          onSaved: (String value) {
                            phone = value;
                          },
                          validator: (val) => val.length != 10
                              ? 'Phone Number should have 10 digits'
                              : null,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xff426ed9)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(24))),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xff426ed9)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(24))),
                            hintText: 'Enter your mobile number',
                            labelText: 'Mobile Number',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: TextFormField(
                          onSaved: (String value) {
                            password = value;
                          },
                          obscureText: true,
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
                                    border:
                                        Border.all(color: Color(0xff00a5ec)),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(24))),
                                child: IconButton(
                                  onPressed: () {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());

                                    if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
                                      _formKey.currentState.save();
                                      print(phone);
                                      loginMerchant(context, phone, password);
                                    } else {
                                      setState(() {
                                        _autoValidate = true;
                                      });
                                    }
                                  },
                                  icon: Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                  ),
                                )),
                            contentPadding: EdgeInsets.all(10),
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xff426ed9)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(24))),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xff426ed9)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(24))),
                            hintText: 'Enter your password',
                            labelText: 'Password',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }

  login(bool value, String userid, String message) async {
    m.id = await m.createMixPanel().then((_) {
      var result = m.mixpanelAnalytics.track(event: 'clickLogin', properties: {
        'success': value,
        'userid': userid,
        'message': message,
        'distinct_id': m.id
      });
      result.then((value) {
        print('this is click login');
        print(value);
      });
    });
  }

  loginMerchant(BuildContext context, String mobile, String password) async {
    print(password);
    try {
      Response response = await post(
        kurl + '/loginforUser',
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(<String, dynamic>{
          'mobilenumber': mobile,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 10));
      String body = response.body;
      print(body);
      String status = json.decode(body)['message'];
      if (status == 'successful login') {
        save(json.decode(body)['data']['userid']);
        login(true, json.decode(body)['data']['userid'], status);
        Toast.show(
          "Login Successful",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
          textColor: Colors.black,
          backgroundColor: Colors.green[200],
        );
        Future.delayed(const Duration(milliseconds: 500), () {
          setState(() {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Navigation()),
            );
          });
        });
      } else {
        login(false, null, status);
        Toast.show(
          "Icorrect username/password",
          context,
          duration: 3,
          gravity: Toast.BOTTOM,
          textColor: Colors.black,
          backgroundColor: Colors.red[200],
        );
      }

      //call saving keys function
      print(body);
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

//save keys function
  void save(String userid) async {
    print(userid);
    print('hi');
    prefs = await SharedPreferences.getInstance(); //get instance of app memory
    final userkey = 'userid';
    //save keys in memory
    prefs.setString(userkey, userid);
    print(prefs.getString(userkey));
  }
}
