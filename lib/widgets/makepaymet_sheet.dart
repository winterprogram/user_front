import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'coupon_page.dart';

class MakePaymentModal extends StatefulWidget {
  @override
  _MakePaymentModalState createState() => _MakePaymentModalState();
}

class _MakePaymentModalState extends State<MakePaymentModal> {
  bool _autoValidate = false;
  final _formKey = GlobalKey<FormState>();
  int amount;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Wrap(children: [
        Container(
          height: 211,
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Opacity(
                  opacity: 0.2,
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 34,
                      height: 2,
                      decoration: BoxDecoration(
                          color: Color(0xff979797),
                          borderRadius: BorderRadius.all(Radius.circular(24))),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Enter Amount',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text('Rs. ',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                        Container(
                          width: 50,
                          child: TextFormField(
                            onSaved: (String value) {
                              amount = int.parse(value);
                            },
                            validator: (value) =>
                                value.length == 0 ? 'Enter Amount' : null,
                            decoration: InputDecoration(hintText: '00.00'),
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 40,
                      width: 136,
                      child: RaisedButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Confirm',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 5),
                              child: Icon(
                                Icons.arrow_forward,
                                size: 18,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                        onPressed: () {
                          FocusScope.of(context).requestFocus(FocusNode());

                          if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
                            _formKey.currentState.save();
                            print(amount);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Coupon()));
                          } else {
                            setState(() {
                              _autoValidate = true;
                            });
                          }
                        },
                        color: Color(0xff3A91EC),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
