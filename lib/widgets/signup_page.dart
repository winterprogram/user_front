import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:userfront/models/user_signup.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

import 'category_page.dart';
import 'fcm_notification.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  FcmNotification fcm;
  bool _autoValidate = false;
  final _formKey = GlobalKey<FormState>();
  String name;
  String selectedGender;
  String phone;
  final password = TextEditingController();
  final verifyPassword = TextEditingController();
  String email;
  String zipcode;
  String selectedCity;
  String selectedCategory;
  DateTime dob = DateTime.now();
  final List<String> city = <String>['Navi Mumbai', 'Thane', 'Mumbai'];
  final List<String> gender = <String>['Male', 'Female', 'Other'];

  @override
  void initState() {
    super.initState();
    fcm = new FcmNotification(context: context);
    fcm.initialize();
  }

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
              Positioned(
                right: 20,
                top: -180,
                child: Container(
                  child: Image.asset('images/circle.png'),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 70),
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Enter your details to create a new account',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Form(
                      autovalidate: _autoValidate,
                      key: _formKey,
                      child: Expanded(
                        child: Container(
                          child: ListView(
                            children: <Widget>[
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                child: TextFormField(
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
                                        borderSide: BorderSide(
                                            color: Color(0xff426ed9)),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(24))),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xff426ed9)),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(24))),
                                    hintText: 'Enter Your Full Name',
                                    labelText: 'Full Name',
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                child: DropdownButtonFormField<String>(
                                  isDense: true,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(10),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xff426ed9)),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(24))),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xff426ed9)),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(24))),
                                    labelText: 'Select your gender',
                                  ),
                                  validator: (value) => value == null
                                      ? 'Gender is required'
                                      : null,
                                  value: selectedGender,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      selectedGender = newValue;
                                    });
                                  },
                                  items: gender.map<DropdownMenuItem<String>>(
                                      (String item) {
                                    return DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(item),
                                    );
                                  }).toList(),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
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
                                        borderSide: BorderSide(
                                            color: Color(0xff426ed9)),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(24))),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xff426ed9)),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(24))),
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
                                        borderSide: BorderSide(
                                            color: Color(0xff426ed9)),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(24))),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xff426ed9)),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(24))),
                                    hintText:
                                        'Enter your email address eg - abc@xyz.com',
                                    labelText: 'Email',
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                child: TextFormField(
                                  controller: password,
                                  validator: validatePassword,
                                  obscureText: true,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(10),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xff426ed9)),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(24))),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xff426ed9)),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(24))),
                                    hintText: 'Enter your password',
                                    labelText: 'Password',
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                child: TextFormField(
                                  controller: verifyPassword,
                                  validator: (val) {
                                    if (val.isEmpty) {
                                      return 'Required';
                                    } else if (password.text !=
                                        verifyPassword.text) {
                                      return 'Password does not match';
                                    } else {
                                      return null;
                                    }
                                  },
                                  obscureText: true,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(10),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xff426ed9)),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(24))),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xff426ed9)),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(24))),
                                    hintText: 'Enter your password again',
                                    labelText: 'Verify Password',
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                child: DropdownButtonFormField<String>(
                                  isDense: true,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(10),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xff426ed9)),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(24))),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xff426ed9)),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(24))),
                                    labelText: 'Select City',
                                  ),
                                  validator: (value) =>
                                      value == null ? 'City is required' : null,
                                  value: selectedCity,
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      selectedCity = newValue;
                                    });
                                  },
                                  items: city.map<DropdownMenuItem<String>>(
                                      (String item) {
                                    return DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(item),
                                    );
                                  }).toList(),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                child: TextFormField(
                                  onSaved: (String value) {
                                    zipcode = value;
                                  },
                                  validator: (val) => val.isEmpty
                                      ? 'Zip Code is required'
                                      : null,
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(10),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xff426ed9)),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(24))),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xff426ed9)),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(24))),
                                    hintText: 'Enter your zip code',
                                    labelText: 'Zip Code',
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                child: DateTimeField(
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                  initialValue: DateTime.now(),
                                  validator: (value) {
                                    if (value == null) {
                                      return 'You have to specify the date of birth';
                                    } else if (DateTime.now().year -
                                            value.year <
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
                                    contentPadding: EdgeInsets.all(10),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xff426ed9)),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(24))),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xff426ed9)),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(24))),
                                    labelText: 'Select your Date of Birth',
                                  ),
                                  onSaved: (value) {
                                    dob = value;
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 48,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(24))),
                                child: RaisedButton(
                                  color: Color(0xff426ed9),
                                  child: Text(
                                    'Next Page',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                                  onPressed: () {
                                    FocusScopeNode currentFocus =
                                        FocusScope.of(context);

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
                                        password: password.text.trim(),
                                        zipcode: zipcode.trim(),
                                        mobilenumber: phone.trim(),
                                        dob: dateofbirth,
                                      );
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Category(u)));
                                    } else {
                                      _autoValidate = true;
                                    }
                                  },
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.blue),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
