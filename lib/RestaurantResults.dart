import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_care/restaurantView.dart';

import 'Business.dart';

class RestaurantResult extends StatefulWidget {
  late List<Business> businessList;

  RestaurantResult({required this.businessList});

  @override
  State createState() {
    return _RestaurantResult(businessList: businessList);
  }
}

class _RestaurantResult extends State<RestaurantResult> {
  late List<Business> businessList;

  _RestaurantResult({required this.businessList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
      itemBuilder: (context, index) {
        return BusinessRow(business: businessList.elementAt(index));
      },
      itemCount: businessList.length,
    ));
  }
}

class BusinessRow extends StatelessWidget {
  Business business;
  BusinessRow({required this.business});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 130,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Color(0xFFfae3e2).withOpacity(0.3),
          spreadRadius: 1,
          blurRadius: 1,
          offset: Offset(0, 1),
        )
      ]),
      child: Card(
        borderOnForeground: false,
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            side: BorderSide(color: Colors.black.withOpacity(0.3))),
        child: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
            child: Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(5),
                  child: Text(
                    "${business.name}",
                    style: TextStyle(fontSize: 20),
                  ),
                  height: 100,
                  width: 110,
                ),
                Container(
                  alignment: Alignment.center,
                  height: 100,
                  padding: EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          "${business.address.country}",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Center(
                        child: Text(
                          "${business.address.city}, ${business.address.street} ${business.address.streetNumber}",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Center(
                        child: Text(
                          "open hours: ${business.openHour} - ${business.closeHour}",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}
