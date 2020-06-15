import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:userfront/widgets/Mixpanel.dart';
import 'package:userfront/widgets/firebase_analytics.dart';
import 'package:http/http.dart';
import 'package:userfront/widgets/constants.dart';
import 'package:toast/toast.dart';
import 'dart:async';
import 'dart:io';
import 'category_page.dart';
import 'constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'fcm_notification.dart';

class ProfileEdit extends StatefulWidget {
  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  MixPanel mix = MixPanel();
  FcmNotification fcm;
  FireBaseAnalytics fba = FireBaseAnalytics();
  Map<String, Widget> avatar = {
    'Restaurant/Bar': Icon(
      Icons.restaurant,
      color: Colors.black,
    ),
    'Beauty Salon/Spa': Icon(Icons.spa),
    'Cafe/Fast Food': Icon(Icons.local_cafe),
    'Ice-Cream Parlour': FaIcon(FontAwesomeIcons.iceCream),
    'Boutiques': FaIcon(FontAwesomeIcons.store)
  };
  List<String> categoryList = [
    'Restaurant/Bar',
    'Beauty Salon/Spa',
    'Cafe/Fast Food',
    'Ice-Cream Parlour',
    'Boutiques'
  ];
  List<String> selectedCategoryList;
  bool _autoValidate = false;
  final _formKey = GlobalKey<FormState>();
  String name;
  String email;
  @override
  void initState() {
    super.initState();
    fcm = new FcmNotification(context: context);
    fcm.initialize();
    mix.createMixPanel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Text(
                'Edit Profile',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(
                height: 20,
              ),
              Form(
                key: _formKey,
                autovalidate: _autoValidate,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      onSaved: (String value) {
                        name = value;
                      },
                      validator: (val) =>
                          val.isEmpty ? 'Name is required' : null,
                      textCapitalization: TextCapitalization.words,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff426ed9)),
                            borderRadius:
                                BorderRadius.all(Radius.circular(24))),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff426ed9)),
                            borderRadius:
                                BorderRadius.all(Radius.circular(24))),
                        hintText: 'Enter Your Full Name',
                        labelText: 'Full Name',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      onSaved: (String value) {
                        email = value;
                      },
                      validator: validateEmail,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff426ed9)),
                            borderRadius:
                                BorderRadius.all(Radius.circular(24))),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff426ed9)),
                            borderRadius:
                                BorderRadius.all(Radius.circular(24))),
                        hintText: 'Enter your email address eg - abc@xyz.com',
                        labelText: 'Email',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: Column(
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 5,
                                  ),
                                  MultiSelectChip(
                                    categoryList,
                                    avatar: avatar,
                                    onSelectionChanged: (selectedList) {
                                      setState(() {
                                        selectedCategoryList = selectedList;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Column(
                                      children: printChoice(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 48,
                            decoration: BoxDecoration(
                                border: Border.all(color: Color(0xff426ed9)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(24))),
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.blue),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                              ),
                              color: Colors.blue,
                              child: Text(
                                'Edit',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                editDetails();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  editDetails() async {
    SharedPreferences prefs =
        await SharedPreferences.getInstance(); //get instance of app memory
    String userid = prefs.getString('userid');
    try {
      Response response = await put(
        kurl + '/editUserDetails',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'userid': userid
        },
        body: jsonEncode(<String, dynamic>{
          'fullname': name,
          'email': email,
          'categoryselected': selectedCategoryList,
        }),
      ).timeout(const Duration(seconds: 10));
      String body = response.body;
      String status = json.decode(body)['message'];
      int code = json.decode(body)['status'];

      if (code == 200) {
        Toast.show(
          "Success: Your details have been edited",
          context,
          duration: 3,
          gravity: Toast.BOTTOM,
          textColor: Colors.black,
          backgroundColor: Colors.green[200],
        );
        Future.delayed(const Duration(milliseconds: 3000), () {
// Here you can write your code

          Navigator.pop(context);
        });
      } else if (code == 500) {
        Toast.show(
          "Failure: Something Went Wrong",
          context,
          duration: 3,
          gravity: Toast.BOTTOM,
          textColor: Colors.black,
          backgroundColor: Colors.red[200],
        );
      } else {
        Toast.show(
          'Try Again',
          context,
          duration: 3,
          gravity: Toast.BOTTOM,
          textColor: Colors.black,
          backgroundColor: Colors.red[200],
        );
      }

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

  String validateEmail(String value) {
    Pattern pattern = r'^[a-zA-z]+\W?\w+\W+[a-z]+\W+\w+';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  printChoice() {
    List<Widget> showChoice = List();
    showChoice.add(SizedBox(
      height: 10,
    ));
    if (selectedCategoryList != null) {
      selectedCategoryList.forEach((item) {
        showChoice.add(Container(
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
          decoration: BoxDecoration(
              color: Colors.blue,
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.all(Radius.circular(30))),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              avatar[item],
              Text(
                item,
                style: TextStyle(),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ));
        showChoice.add(SizedBox(
          height: 17,
        ));
      });
    }
    return showChoice;
  }
}
