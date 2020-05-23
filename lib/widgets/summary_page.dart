import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:userfront/models/Mixpanel.dart';
import 'package:userfront/widgets/razorpay.dart';

class Summary extends StatefulWidget {
  final String userid;
  final String merchantid;
  final double amount;
  final String couponcode;
  final double discount;
  final double faltdiscountupto;
  @override
  Summary(
      {this.amount,
      this.couponcode,
      this.discount,
      this.faltdiscountupto,
      this.merchantid,
      this.userid});
  @override
  _SummaryState createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  MixPanel mix = MixPanel();
  double amount;
  String couponcode;
  double discount;
  double faltdiscountupto;
  double coupondiscount;
  int conveniencefee;
  double total;
  RazorPay r;
  String userid;
  String merchantid;

  @override
  void initState() {
    super.initState();
    amount = this.widget.amount;
    couponcode = this.widget.couponcode;
    discount = this.widget.discount;
    faltdiscountupto = this.widget.faltdiscountupto;
    print(couponcode);
    if (couponcode != '') {
      if (amount * discount / 100 < faltdiscountupto) {
        coupondiscount = amount * (discount) / 100;
      } else {
        coupondiscount = faltdiscountupto;
      }
      total = amount - coupondiscount;
    } else {
      total = amount;
      coupondiscount = 0;
    }
    conveniencefee = (calculateConvenience(0.02 * total)).round();
    total += conveniencefee;
    userid = this.widget.userid;
    merchantid = this.widget.merchantid;
    r = RazorPay(
        context: context,
        amount: total,
        userid: userid,
        merchantid: merchantid);
  }

  @override
  void dispose() {
    super.dispose();
    r.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Positioned(
              right: 0,
              child: Container(
                child: Image.asset('images/green-circle.png'),
              ),
            ),
            Container(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 24, top: 65.0),
                        child: IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 24, top: 26),
                        child: Text(
                          'Order Summary',
                          style: TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Padding(
                            padding:
                                EdgeInsets.only(left: 24, top: 23, right: 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Sub Total',
                                  style: TextStyle(
                                      color: Color(0xff293340), fontSize: 15),
                                ),
                                Text(
                                  'Rs. $amount',
                                  style: TextStyle(
                                      color: Color(0xff293340),
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(left: 24, top: 19, right: 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Convenience Fee',
                                  style: TextStyle(
                                      color: Color(0xff293340), fontSize: 15),
                                ),
                                Text(
                                  'Rs. $conveniencefee',
                                  style: TextStyle(
                                      color: Color(0xff293340),
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(left: 24, top: 19, right: 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Coupon Discount',
                                  style: TextStyle(
                                      color: Color(0xff293340), fontSize: 15),
                                ),
                                Text(
                                  '$coupondiscount',
                                  style: TextStyle(
                                      color: Color(0xff26C8A8),
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 24, top: 24, right: 24),
                            child: DottedBorder(
                              dashPattern: [6, 3],
                              borderType: BorderType.RRect,
                              radius: Radius.circular(6),
                              padding: EdgeInsets.all(0),
                              color: Color(0xff37c898).withOpacity(0.5),
                              child: Container(
                                height: 33,
                                color: Color(0xff37c898).withOpacity(0.05),
                                child: Center(
                                  child: Text('$couponcode',
                                      style: TextStyle(
                                          color: Color(0xff1ea896),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    height: 88,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Divider(),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      'Rs. $total',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20,
                                          color: Color(0xff293340)),
                                    ),
                                    Container(
                                      height: 48,
                                      width: 169,
                                      child: RaisedButton(
                                        onPressed: () async {
                                          onClick('MakePayment');
                                          await r.checkout();
                                          /*Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Navigation()),
                                            (Route<dynamic> route) => false,
                                          );*/
                                        },
                                        color: Color(0xff3a91ec),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              'Make Payment',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Icon(
                                                Icons.arrow_forward,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(24)),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  onClick(String button) async {
    mix.id = await mix.createMixPanel().then((_) {
      var result = mix.mixpanelAnalytics.track(
          event: 'onClickSummaryPage',
          properties: {'button': button, 'distinct_id': mix.id});
      result.then((value) {
        print('this is click login');
        print(value);
      });
      return;
    });
  }

  calculateConvenience(double convenience) {
    if (convenience < 0.1) {
      return convenience;
    } else {
      return convenience + calculateConvenience(0.02 * convenience);
    }
  }
}
