import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_care/Product.dart';
import 'package:food_care/restaurantView.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:geocoder/geocoder.dart';

import 'Business.dart';

class FavoritesView extends StatefulWidget {
  late List<Business> businessList;

  FavoritesView({required this.businessList});

  @override
  State createState() {
    return _FavoritesView(businessList: businessList);
  }
}

class _FavoritesView extends State<FavoritesView> {
  late List<Business> businessList;

  _FavoritesView({required this.businessList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: businessList.length != 0
            ? ListView.builder(
                itemBuilder: (context, index) {
                  return favouriteRow(businessList.elementAt(index));
                },
                itemCount: businessList.length,
              )
            : Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                child: Text("Empty list"),
                alignment: Alignment.center,
              ));
  }

  Widget favouriteRow(Business business) {
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
                    width: MediaQuery.of(context).size.width * 2 / 5,
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
                  Container(
                    width: MediaQuery.of(context).size.width * 1 / 5,
                    height: 100,
                    child: IconButton(
                      icon: Icon(
                        Icons.delete,
                        size: 32,
                        color: Colors.red,
                      ),
                      onPressed: () async {
                        try {
                          var dio = Dio();
                          SharedPreferences sharedPreferences =
                              await SharedPreferences.getInstance();
                          String? token = sharedPreferences.getString("token");
                          dio.options.headers["Authorization"] = '$token';
                          Response response = await dio.delete(
                              "https://food-care2.herokuapp.com/favorite/business/${business.id}");
                          if (response.statusCode == 200) {
                            setState(() {
                              businessList.removeWhere(
                                  (element) => element.id == business.id);
                            });
                          }
                        } catch (e) {
                          debugPrint(e.toString());
                        }
                      },
                    ),
                  )
                ],
              ),
            )),
      ),
    );
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
                    width: MediaQuery.of(context).size.width * 2 / 5,
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
                  Container(
                    width: MediaQuery.of(context).size.width * 1 / 5,
                    height: 100,
                    child: IconButton(
                      icon: Icon(
                        Icons.delete,
                        size: 32,
                        color: Colors.red,
                      ),
                      onPressed: () {},
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
