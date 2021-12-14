import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:geocoder/geocoder.dart';
import '../model/Business.dart';
import 'restaurantView.dart';

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
      height: 140,
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
            child: InkWell(
              onTap: () async {
                try {
                  var dio = Dio();
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  String? token = prefs.getString("token");
                  dio.options.headers["Authorization"] = '$token';
                  Response response;
                  response = await dio.get(
                      "https://food-care2.herokuapp.com/rating/business/${business.id}");

                  if (response.statusCode == 200) {
                    Map<String, dynamic> map = response.data;
                    double rating = map.values.elementAt(1);
                    List<Location> locations = await locationFromAddress(
                        "${business.address.streetNumber} ${business.address.street}, ${business.address.city}");
                    double lat = locations[0].latitude;
                    double long = locations[0].longitude;

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RestaurantView(
                                  business: business,
                                  lat: lat,
                                  long: long,
                                  rating: rating,
                                )));
                  }
                } catch (e) {
                  debugPrint(e.toString());
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 2 / 6,
                    height: 140,
                    child: Image.asset(
                      business.typeOfBusiness == BusinessType.SHOP
                          ? "images/shop.png"
                          : "images/restaurant-.png",
                      width: 50,
                      height: 50,
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 100,
                    width: MediaQuery.of(context).size.width * 3 / 5,
                    child: Wrap(
                      children: [
                        Center(
                          child: Text(
                            "${business.name}",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Center(
                          child: Text(
                            "${business.address.country}, ${business.address.city} ${business.address.zipCode}",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Center(
                          child: Text(
                            " ${business.address.street} ${business.address.streetNumber}",
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
