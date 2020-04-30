import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:userfront/models/user_signup.dart';
import 'package:http/http.dart';
import 'package:userfront/widgets/constants.dart';
import 'package:toast/toast.dart';
import 'dart:async';
import 'dart:io';
import 'common_button.dart';
import 'constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Category extends StatefulWidget {
  User u;
  Category(this.u);
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 35),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Color(0xFFf1d300),
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          color: kOverallColor,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.elliptical(30, 30),
              ),
            ),
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
                  child: ClickButton(
                      buttonTitle: 'SignUp',
                      buttonFunction: () {
                        this.widget.u.addCategory(selectedCategoryList);
                        createUser(this.widget.u);
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  //return selected  choice of priority
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
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: kOverallColor),
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
          height: 20,
        ));
      });
    }
    return showChoice;
  }

//button which integrates backend
  createUser(User u) async {
    try {
      Response response = await post(
        kUserSignup,
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(<String, dynamic>{
          'fullname': u.fullname,
          'gender': u.gender,
          'mobilenumber': u.mobilenumber,
          'password': u.password,
          'email': u.mailid,
          'city': u.city,
          'category': u.category,
          'zipcode': u.zipcode,
          'dob': u.dob,
          'categoryselected': u.category,
        }),
      ).timeout(const Duration(seconds: 10));
      String body = response.body;
      String status = json.decode(body)['status'];

      if (status == 'user registered') {
        Toast.show(
          "Success: Your account has been created. Please login.",
          context,
          duration: 3,
          gravity: Toast.BOTTOM,
          textColor: Colors.black,
          backgroundColor: Colors.green[200],
        );
        Future.delayed(const Duration(milliseconds: 3000), () {
// Here you can write your code

          setState(() {
            Navigator.pop(context);
            Navigator.pop(context, true);
            // Here you can write your code for open new view
          });
        });
      } else if (status == 'user already exist') {
        Toast.show(
          "Failure: Your account already exists.",
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
}

//return chips to be selected
class MultiSelectChip extends StatefulWidget {
  final Map<String, Widget> avatar;
  final List<String> reportList;
  final Function(List<String>) onSelectionChanged;
  MultiSelectChip(this.reportList, {this.avatar, this.onSelectionChanged});
  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  List<String> selectedChoices = List();

  _buildChoiceList() {
    List<Widget> choices = List();
    widget.reportList.forEach(
      (item) {
        choices.add(
          Container(
            padding: const EdgeInsets.all(2.0),
            child: ChoiceChip(
              avatar: widget.avatar[item],
              selectedColor: kOverallColor,
              labelStyle: TextStyle(color: Colors.black),
              label: Text(item),
              selected: selectedChoices.contains(item),
              onSelected: (selected) {
                setState(() {
                  if (selectedChoices.contains(item)) {
                    selectedChoices.remove(item);
                  } else {
                    selectedChoices.add(item);
                  }
                  widget.onSelectionChanged(selectedChoices);
                });
              },
            ),
          ),
        );
      },
    );
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _buildChoiceList(),
    );
  }
}
