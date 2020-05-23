import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:userfront/models/Mixpanel.dart';
import 'package:userfront/widgets/image_picker.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'makepaymet_sheet.dart';

class MerchantPage extends StatefulWidget {
  final List<dynamic> src;
  final String merchantId;
  final String merchantShopName;
  final String merchantName;
  final String merchantAddress;
  final String merchantCategory;
  MerchantPage(
      {this.src,
      this.merchantId,
      this.merchantShopName,
      this.merchantName,
      this.merchantAddress,
      this.merchantCategory});
  @override
  _MerchantPageState createState() => _MerchantPageState();
}

class _MerchantPageState extends State<MerchantPage> {
  MixPanel mix = MixPanel();
  @override
  void initState() {
    super.initState();
    FacebookAudienceNetwork.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Expanded(
          child: Container(
            color: Colors.white,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          height: 242,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: widget.src.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 2.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      onClick('image');
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  GalleryPhotoViewWrapper(
                                                    url: widget.src,
                                                    initialIndex: index,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    backgroundDecoration:
                                                        const BoxDecoration(
                                                      color: Colors.white,
                                                    ),
                                                  )));
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black)),
                                        width: 280,
                                        child:
                                            Image.network(widget.src[index])),
                                  ),
                                );
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 18, left: 24.0),
                          child: Text(
                            widget.merchantCategory,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xffa61d55)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 14, left: 24.0),
                          child: Text(
                            widget.merchantShopName,
                            style: TextStyle(
                                fontSize: 27,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff293340)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20, left: 24.0, bottom: 25),
                          child: Text(
                            widget.merchantAddress,
                            style: TextStyle(
                                fontSize: 12, color: Color(0xff474d60)),
                          ),
                        ),
                        Divider(height: 1, color: Color(0xff979797)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: GestureDetector(
                                child: Container(
                                  child: Column(
                                    children: <Widget>[
                                      Icon(
                                        Icons.call,
                                        color: Color(0xff426ed9),
                                        size: 18,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          'Call',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff24272c)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 20.0, left: 30),
                              child: GestureDetector(
                                child: Container(
                                  child: Column(
                                    children: <Widget>[
                                      Transform.rotate(
                                        angle: 180 * pi / 180,
                                        child: Icon(
                                          Icons.subdirectory_arrow_left,
                                          color: Color(0xff426ed9),
                                          size: 18,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          'Direction',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff24272c)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 25.0),
                          child: Align(
                            child: Container(
                              height: 48,
                              width: 162,
                              child: RaisedButton(
                                onPressed: () {
                                  onClick('MakePayment');
                                  saveMerchantId();
                                  showModalBottomSheet(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      backgroundColor: Colors.white,
                                      context: context,
                                      builder: (context) => MakePaymentModal());
                                },
                                color: Color(0xff3a91ec),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Make Payment',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Icon(
                                        Icons.arrow_forward,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(24)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Expanded(
                          child: Container(
                            color: Colors.grey[300],
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 5),
                            child: FacebookNativeAd(
                              placementId: "3013166852096438_3013315605414896",
                              adType: NativeAdType.NATIVE_AD,
                              width: double.infinity,
                              backgroundColor: Colors.white,
                              titleColor: Colors.black,
                              descriptionColor: Colors.black,
                              buttonColor: Color(0xff426ed9),
                              buttonTitleColor: Colors.white,
                              buttonBorderColor: Colors.white,
                              listener: (result, value) {
                                print("Native Ad: $result --> $value");
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  onClick(String button) async {
    mix.id = await mix.createMixPanel().then((_) {
      var result = mix.mixpanelAnalytics.track(
          event: 'onClickMerchantPage',
          properties: {'button': button, 'distinct_id': mix.id});
      result.then((value) {
        print(value);
      });
      return;
    });
  }

  saveMerchantId() async {
    SharedPreferences prefs =
        await SharedPreferences.getInstance(); //get instance of app memory
    final merchantkey = 'merchantid';
    //save keys in memory
    prefs.setString(merchantkey, this.widget.merchantId);
  }
}
