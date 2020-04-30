import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:userfront/widgets/common_button.dart';
import 'package:userfront/widgets/constants.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:userfront/widgets/dashboard.dart';

import 'category_page.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _autoValidate = false;
  SharedPreferences prefs;
  final _formKey = GlobalKey<FormState>();
  String phone;
  String password;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Form(
          autovalidate: _autoValidate,
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                onSaved: (String value) {
                  phone = value;
                },
                validator: (val) => val.length != 10
                    ? 'Phone Number should have 10 digits'
                    : null,
                keyboardType: TextInputType.number,
                style: TextStyle(
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  icon: IconTheme(
                    data: IconThemeData(
                      color: Color(0xFFf1d300),
                    ),
                    child: Icon(Icons.contact_phone),
                  ),
                  hintText: 'Enter your mobile number',
                  labelText: 'Mobile Number',
                ),
              ),
              TextFormField(
                onSaved: (String value) {
                  password = value;
                },
                obscureText: true,
                style: TextStyle(
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  icon: IconTheme(
                    data: IconThemeData(
                      color: Color(0xFFf1d300),
                    ),
                    child: Icon(Icons.security),
                  ),
                  hintText: 'Enter your password',
                  labelText: 'Password',
                ),
              ),
              Container(
                  child: ClickButton(
                      buttonTitle: 'Login',
                      buttonFunction: () {
                        FocusScopeNode currentFocus = FocusScope.of(context);

                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }

                        if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
                          _formKey.currentState.save();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Category()),
                          );
                          print(phone);
                          loginMerchant(context, phone, password);
                        } else {
                          _autoValidate = true;
                        }
                      })),
            ],
          ),
        ),
      ),
    );
  }

  loginMerchant(BuildContext context, String mobile, String password) async {
    print(password);
    try {
      Response response = await post(
        kUserLogin,
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
              MaterialPageRoute(builder: (context) => Category()),
            );
          });
        });

        save(json.decode(body)['data'][0]['userid']);
      } else if (status == 'ask user to submit category list') {
        save(json.decode(body)['data'][0]['userid']);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Category()));
      } else {
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
