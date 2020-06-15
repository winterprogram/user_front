import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:userfront/models/user_signup.dart';
import 'package:userfront/widgets/profile_edit.dart';
import 'fcm_notification.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User u;
  FcmNotification fcm;

  @override
  void initState() {
    super.initState();
    fcm = new FcmNotification(context: context);
    fcm.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: FutureBuilder(
          future: createUser(),
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.hasData) {
              u = asyncSnapshot.data;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 34,
                      top: 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          u.fullname,
                          style: TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff293340),
                          ),
                        ),
                        SizedBox(
                          height: 9,
                        ),
                        Opacity(
                          opacity: 0.6,
                          child: Text(
                            '${u.mobilenumber}, ${u.mailid}',
                            style: TextStyle(
                              color: Color(0xff293340),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Container(
                            height: 30,
                            child: RaisedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProfileEdit()));
                              },
                              color: Color(0xff426ed9),
                              child: Text(
                                'Edit',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.blue),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 29)
                      ],
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: EdgeInsets.only(top: 16, left: 20, right: 20),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Statistics',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Text(
                                  'No. of Coupons Issued',
                                  style: TextStyle(
                                    color: Color(0xff293340),
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(height: 15),
                                Text(
                                  'No. of Coupons Redeemed',
                                  style: TextStyle(
                                    color: Color(0xff293340),
                                    fontSize: 14,
                                  ),
                                )
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Text(
                                  '5',
                                  style: TextStyle(
                                    color: Color(0xff293340),
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(height: 15),
                                Text(
                                  '15',
                                  style: TextStyle(
                                    color: Color(0xff293340),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else if (asyncSnapshot.hasError) {
              return Text('An Error Occurred');
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  createUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mail = prefs.getString('email');
    String name = prefs.getString('name');
    int mobile = prefs.getInt('mobile');
    String zipcode = prefs.getString('zipcode');
    String gender = prefs.getString('gender');
    return User(
        fullname: name,
        gender: gender,
        mailid: mail,
        mobilenumber: mobile.toString(),
        zipcode: zipcode);
  }
}
