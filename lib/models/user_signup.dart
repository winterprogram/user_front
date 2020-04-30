import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class User {
  final String fullname;
  final String gender;
  final String mailid;
  final String mobilenumber;
  final String city;
  final String password;
  final String zipcode;
  final List<String> category;
  final String dob;
  User({
    @required this.fullname,
    @required this.gender,
    @required this.mailid,
    @required this.mobilenumber,
    @required this.city,
    @required this.password,
    @required this.zipcode,
    this.category,
    @required this.dob,
  });
}
