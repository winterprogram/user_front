import 'package:flutter/cupertino.dart';
import 'package:toast/toast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorPay {
  Razorpay _razorpay;
  BuildContext context;
  RazorPay({this.context}) {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }
  void checkout(int amount) async {
    print('setting options');
    var options = {
      'key': 'rzp_test_4Mu3PQaOJWjgyV',
      'amount': amount * 100,
      'name': 'Company',
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
  }

  void clear() {
    _razorpay.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Toast.show('Success', this.context);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Toast.show('Falilure', this.context);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Toast.show('Externalwallet' + response.walletName, this.context);
  }
}
