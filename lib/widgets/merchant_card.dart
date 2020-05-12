import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:userfront/widgets/merchant_page.dart';

class MerchantCard extends StatelessWidget {
  final List<dynamic> src;
  final String merchantShopName;
  final String merchantName;
  final String merchantAddress;
  final String merchantCategory;
  MerchantCard(
      {this.src,
      this.merchantShopName,
      this.merchantName,
      this.merchantAddress,
      this.merchantCategory});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 264,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MerchantPage(
                            src: src,
                            merchantName: merchantName,
                            merchantAddress: merchantAddress,
                            merchantShopName: merchantShopName,
                            merchantCategory: merchantCategory,
                          )));
            },
            child: Container(
              height: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 15, left: 24.0),
                    child: Text(
                      merchantShopName,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15, left: 24.0),
                    child: Text(
                      merchantAddress,
                      style: TextStyle(fontSize: 12, color: Color(0xff474d60)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
              height: 51,
              decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey[200]))),
              child: FlatButton(
                onPressed: () {},
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
}
