import 'package:flutter/cupertino.dart';
import 'package:toast/toast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart';
import 'package:userfront/models/Mixpanel.dart';
import 'constants.dart';

class RazorPay {
  MixPanel mix = MixPanel();
  String userid;
  String merchantid;
  double amount;
  Razorpay _razorpay;
  BuildContext context;
  String orderid;
  RazorPay({this.context, this.amount, this.userid, this.merchantid}) {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }
  Future<void> checkout() async {
    getOrderId().then((value) {
      print(value);
      if (value != null) {
        this.orderid = value['id'];
        var options = {
          'key': 'rzp_test_4Mu3PQaOJWjgyV',
          'order_id': orderid,
          'name': 'CompanyName',
          'description': 'Payment',
          'prefill': {'contact': '', 'email': ''},
          'external': ['paytm']
        };
        try {
          print('opening razorpay');
          _razorpay.open(options);
        } catch (e) {
          debugPrint(e);
        }
      } else {
        print('try again');
      }
    });
  }

  void clear() {
    _razorpay.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    payment('Success');
    passResult();
    Toast.show('Success', this.context);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    payment('Failure');
    passResult();
    Toast.show('Falilure', this.context);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    payment('ExternalWallet');
    Toast.show('Externalwallet' + response.walletName, this.context);
  }

  Future getOrderId() async {
    print(this.amount * 100);
    try {
      Response response = await post(kurl + '/payments',
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode(<String, dynamic>{
            'merchantid': this.merchantid,
            'userid': this.userid,
            'amount': this.amount * 100,
          })).timeout(const Duration(seconds: 10));
      String body = response.body;
      String message = json.decode(body)['message'];
      print(body);
      onFetchOrderId(message);
      if (message == 'data saved for payments') {
        //print(body);
        return json.decode(body)['data'];
      } else if (message == '') {
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

  Future passResult() async {
    try {
      Response response = await post(kurl + '/getPaymentByOrder',
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode(<String, dynamic>{
            'order': this.orderid,
          })).timeout(const Duration(seconds: 10));
      String body = response.body;
      String message = json.decode(body)['message'];
      print(body);
      onFetchOrderId(message);

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

  onFetchOrderId(String message) async {
    mix.id = await mix.createMixPanel().then((_) {
      var result = mix.mixpanelAnalytics.track(
          event: 'fetchOrderId',
          properties: {'message': message, 'distinct_id': mix.id});
      result.then((value) {
        print(value);
      });
      return;
    });
  }

  payment(String message) async {
    mix.id = await mix.createMixPanel().then((_) {
      var result = mix.mixpanelAnalytics.track(
          event: 'onPaymentDone',
          properties: {'message': message, 'distinct_id': mix.id});
      result.then((value) {
        print(value);
      });
      return;
    });
  }
}
