import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:userfront/models/user_signup.dart';
import 'package:userfront/widgets/common_button.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

import 'category_page.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _autoValidate = false;
  final _formKey = GlobalKey<FormState>();
  String name;
  String selectedGender;
  String phone;
  String password;
  String email;
  String zipcode;
  String selectedCity;
  String selectedCategory;
  DateTime dob = DateTime.now();
  final List<String> city = <String>['Navi Mumbai', 'Thane', 'Mumbai'];
  final List<String> gender = <String>['Male', 'Female', 'Other'];

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
          color: Color(0xFFf1d300),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.elliptical(30, 30),
              ),
            ),
            padding: EdgeInsets.all(10),
            child: Form(
              autovalidate: _autoValidate,
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  TextFormField(
                    onSaved: (String value) {
                      name = value;
                    },
                    validator: (val) => val.isEmpty ? 'Name is required' : null,
                    textCapitalization: TextCapitalization.words,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      icon: IconTheme(
                        data: IconThemeData(
                          color: Color(0xFFf1d300),
                        ),
                        child: Icon(Icons.person),
                      ),
                      hintText: 'Enter Your Full Name',
                      labelText: 'Full Name',
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        child: IconTheme(
                          data: IconThemeData(
                            color: Color(0xFFf1d300),
                          ),
                          child: Icon(Icons.accessibility),
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Container(
                          child: DropdownButtonFormField<String>(
                            validator: (value) =>
                                value == null ? 'Gender is required' : null,
                            hint: Text(
                              'Select your gender',
                              style: TextStyle(color: Colors.black),
                            ),
                            value: selectedGender,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            onChanged: (String newValue) {
                              setState(() {
                                selectedGender = newValue;
                              });
                            },
                            items: gender
                                .map<DropdownMenuItem<String>>((String item) {
                              return DropdownMenuItem<String>(
                                value: item,
                                child: Text(item),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
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
                      email = value;
                    },
                    validator: validateEmail,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      icon: IconTheme(
                        data: IconThemeData(
                          color: Color(0xFFf1d300),
                        ),
                        child: Icon(Icons.email),
                      ),
                      hintText: 'Enter your email address eg - abc@xyz.com',
                      labelText: 'Email',
                    ),
                  ),
                  TextFormField(
                    onSaved: (String value) {
                      password = value;
                    },
                    validator: validatePassword,
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
                  Row(
                    children: <Widget>[
                      Container(
                        child: IconTheme(
                          data: IconThemeData(
                            color: Color(0xFFf1d300),
                          ),
                          child: Icon(Icons.location_city),
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Container(
                          child: DropdownButtonFormField<String>(
                            validator: (value) =>
                                value == null ? 'City is required' : null,
                            hint: Text(
                              'Select City',
                              style: TextStyle(color: Colors.black),
                            ),
                            value: selectedCity,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            onChanged: (String newValue) {
                              setState(() {
                                selectedCity = newValue;
                              });
                            },
                            items: city
                                .map<DropdownMenuItem<String>>((String item) {
                              return DropdownMenuItem<String>(
                                value: item,
                                child: Text(item),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  TextFormField(
                    onSaved: (String value) {
                      zipcode = value;
                    },
                    validator: (val) =>
                        val.isEmpty ? 'Zip Code is required' : null,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      icon: IconTheme(
                        data: IconThemeData(
                          color: Color(0xFFf1d300),
                        ),
                        child: Icon(Icons.code),
                      ),
                      hintText: 'Enter your zip code',
                      labelText: 'Zip Code',
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        child: IconTheme(
                          data: IconThemeData(
                            color: Color(0xFFf1d300),
                          ),
                          child: Icon(Icons.child_care),
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Container(
                          child: DateTimeField(
                            initialValue: DateTime.now(),
                            validator: (value) {
                              if (value == null) {
                                return 'You have to specify the date of birth';
                              } else if (DateTime.now().year - value.year <
                                  14) {
                                return 'Your age should be greater than 14';
                              } else {
                                return null;
                              }
                            },
                            onShowPicker: (context, currentValue) {
                              return showDatePicker(
                                  context: context,
                                  firstDate: DateTime(1900),
                                  initialDate: dob,
                                  lastDate: DateTime(2100));
                            },
                            onChanged: (value) {
                              setState(() {
                                dob = value;
                              });
                            },
                            format: DateFormat("dd-MM-yyyy"),
                            decoration: InputDecoration(
                                labelText: 'Select your Date of Birth'),
                            onSaved: (value) {
                              dob = value;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    child: ClickButton(
                      buttonTitle: 'Next Page',
                      buttonFunction: () {
                        FocusScopeNode currentFocus = FocusScope.of(context);

                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                        if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
                          _formKey.currentState.save();
                          String dateofbirth =
                              DateFormat('dd-MM-yyyy').format(dob);
                          User u = new User(
                            fullname: name.trim(),
                            gender: selectedGender,
                            mailid: email.trim(),
                            city: selectedCity,
                            password: password.trim(),
                            zipcode: zipcode.trim(),
                            mobilenumber: phone.trim(),
                            dob: dateofbirth,
                          );
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Category(u)));
                        } else {
                          _autoValidate = true;
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String validateEmail(String value) {
    Pattern pattern = r'^[a-zA-z]+\W?\w+\W+[a-z]+\W+\w+';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  String validatePassword(String value) {
    Pattern pattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.{8,})';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value) || value.length < 6)
      return 'Must contain - Alphabet (Caps/small), Number and Specialsdfs';
    else
      return null;
  }
}
