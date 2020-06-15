import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:userfront/widgets/fcm_notification.dart';
import 'package:userfront/widgets/firebase_analytics.dart';
import 'package:userfront/widgets/merchant_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Mixpanel.dart';
import 'makepaymet_sheet.dart';

class MerchantCard extends StatelessWidget {
  final BuildContext ctx;
  final FcmNotification fcm = FcmNotification();
  final MixPanel mix = MixPanel();
  final List<dynamic> src;
  final String merchantId;
  final String merchantShopName;
  final String merchantName;
  final String merchantAddress;
  final String merchantCategory;
  final double latitude;
  final double longitude;
  final String mobile;
  MerchantCard(
      {this.ctx,
      this.src,
      this.merchantId,
      this.merchantShopName,
      this.merchantName,
      this.merchantAddress,
      this.merchantCategory,
      this.latitude,
      this.longitude,
      this.mobile});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 264,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              onTapMerchantCard(merchantId, 'MerchantCard');
              Navigator.push(
                  ctx,
                  MaterialPageRoute(
                      builder: (ctx) => MerchantPage(
                            src: src,
                            merchantId: merchantId,
                            merchantName: merchantName,
                            merchantAddress: merchantAddress,
                            merchantShopName: merchantShopName,
                            merchantCategory: merchantCategory,
                            latitude: latitude,
                            longitude: longitude,
                            mobile: mobile,
                          )));
            },
            child: Column(
              children: <Widget>[
                Container(
                  height: 113,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: src.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black)),
                              width: 214,
                              child: Image.network(src[index])),
                        );
                      }),
                ),
                Container(
                  height: 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 15, left: 24.0),
                        child: Text(
                          merchantShopName,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15, left: 24.0),
                        child: Text(
                          merchantAddress,
                          style:
                              TextStyle(fontSize: 12, color: Color(0xff474d60)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
              height: 51,
              decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey[200]))),
              child: FlatButton(
                onPressed: () {
                  onTapMerchantCard(merchantId, 'MakePayment');
                  saveMerchantId();
                  showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      backgroundColor: Colors.white,
                      context: context,
                      builder: (context) => MakePaymentModal());
                },
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.blue,
                    ),
                    Text(
                      'Make Payment',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }

  saveMerchantId() async {
    SharedPreferences prefs =
        await SharedPreferences.getInstance(); //get instance of app memory
    final merchantkey = 'merchantid';
    //save keys in memory
    prefs.setString(merchantkey, merchantId);
  }

  onTapMerchantCard(String merchantid, String button) async {
    mix.createMixPanel();
    fcm.initialize();
    fcm.getToken().then((token) {
      var result = mix.mixpanelAnalytics.track(event: 'onClick', properties: {
        'button': button,
        'merchantid': merchantid,
        'distinct_id': token
      });
    });
  }
}
