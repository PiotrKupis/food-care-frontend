import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_care/Business.dart';
import 'package:food_care/favoritesView.dart';
import 'package:food_care/opinionView.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'RestaurantResults.dart';
import 'offerView.dart';

class RestaurantView extends StatefulWidget {
  late Business business;

  RestaurantView({required this.business});

  @override
  State<RestaurantView> createState() =>
      _RestaurantViewState(business: business);
}

class _RestaurantViewState extends State<RestaurantView> {
  late Business business;

  _RestaurantViewState({required this.business});

  Set<Marker> _markers = {};
  double ratingValue = 0.0;

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _markers.add(Marker(
          markerId: MarkerId('id-1'),
          position: LatLng(51.782423727644456, 19.452753383126257),
          infoWindow: InfoWindow(
            title: '${business.name}',
            snippet: '${business.openHour}-${business.closeHour}',
          )));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          Container(
              width: double.infinity,
              height: 100,
              padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
              decoration: BoxDecoration(
                //  border: Border(bottom: BorderSide(color: Colors.black)) ,
                color: Color(0xFFF2F3F5),
              ),
              child: Center(
                child: Text(
                  business.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40,
                  ),
                ),
              )),
          Container(
              width: double.infinity,
              height: 100,
              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.black)),
                color: Color(0xFFF2F3F5),
              ),
              child: Center(
                  child: business.typeOfBusiness.index == 0
                      ? //tutaj poprawic
                      Image.asset(
                          "images/shop.png",
                          fit: BoxFit.fitHeight,
                          height: 100,
                          width: 180,
                        )
                      : Image.asset(
                          "images/restaurant-.png",
                          fit: BoxFit.fitHeight,
                          height: 100,
                          width: 180,
                        ))),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
              //width: double.infinity,
              padding: EdgeInsets.all(10),
              height: 50,
              decoration: BoxDecoration(
                  //    border: Border(bottom: BorderSide(color: Colors.black))
                  ),
              child: Text(
                "Open hours: " + business.openHour + " - " + business.closeHour,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
            ),
            Container(
              //width: double.infinity,
              padding: EdgeInsets.all(5),
              height: 50,
              decoration: BoxDecoration(
                  //    border: Border(bottom: BorderSide(color: Colors.black))
                  ),
              child: IconButton(
                  onPressed: () async {
                    try {
                      var dio = Dio();
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      String? token = prefs.getString("token");
                      dio.options.headers["Authorization"] = '$token';
                      Response response = await dio.post("https://food-care2.herokuapp.com/favorite/business",
                      data: {
                        "businessId": business.id,
                      });
                      if (response.statusCode == 200) {
                         Fluttertoast.showToast(
                              msg: "Added to favorites",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                      }
                    } catch (e) {
                        debugPrint(e.toString());
                    }
                  },
                  icon: Icon(
                    Icons.favorite,
                    color: Colors.red,
                  )),
            ),
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                //width: double.infinity,
                padding: EdgeInsets.all(10),
                height: 50,
                decoration: BoxDecoration(
                    //     border: Border(bottom: BorderSide(color: Colors.black))
                    ),
                child: Text(
                  "Address: " +
                      business.address.street +
                      " " +
                      business.address.streetNumber +
                      ", " +
                      business.address.city,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
              ),
              Container(
                //width: double.infinity,
                padding: EdgeInsets.all(5),
                height: 50,
                decoration: BoxDecoration(
                    //     border: Border(bottom: BorderSide(color: Colors.black))
                    ),
                child: IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                                actions: [
                                  FlatButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Cancel")),
                                  FlatButton(
                                      onPressed: () async {
                                        try {
                                          var dio = Dio();
                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          String? token =
                                              prefs.getString("token");
                                          dio.options.headers["Authorization"] =
                                              '$token';
                                          Response response = await dio.post(
                                              "https://food-care2.herokuapp.com/rating/business",
                                              data: {
                                                "businessId": business.id,
                                                "rating": ratingValue,
                                              });
                                          if (response.statusCode == 200) {
                                            Navigator.of(context).pop();
                                          }
                                        } catch (e) {
                                          debugPrint(e.toString());
                                        }
                                      },
                                      child: Text("Confirm"))
                                ],
                                content: Container(
                                  height: 50,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          RatingBar.builder(
                                            itemBuilder: (context, _) => Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            onRatingUpdate: (value) {
                                              ratingValue = value;
                                            },
                                            itemCount: 5,
                                            itemPadding: EdgeInsets.symmetric(
                                                horizontal: 2.0),
                                            allowHalfRating: true,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ));
                          });
                    },
                    icon: Icon(
                      Icons.star,
                      color: Colors.yellow,
                    )),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                //width: double.infinity,
                padding: EdgeInsets.all(10),
                height: 50,
                decoration: BoxDecoration(
                    //   border: Border(bottom: BorderSide(color: Colors.black))
                    ),
                child: Text(
                  "Country: " + business.address.country,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
              ),
              Container(
                //width: double.infinity,
                padding: EdgeInsets.all(5),
                height: 50,
                decoration: BoxDecoration(
                    //   border: Border(bottom: BorderSide(color: Colors.black))
                    ),
                child: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OfferView(),
                          ));
                    },
                    icon: Icon(
                      Icons.restaurant,
                      color: Colors.black,
                    )),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            height: 50,
            decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.black))),
            child: Text(
              "Opinion: ",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
              ),
            ),
          ),
          Container(
              width: double.infinity,
              //padding: EdgeInsets.all(10),
              height: 350,
              decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.black))),
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                markers: _markers,
                initialCameraPosition: CameraPosition(
                  target: LatLng(51.782423727644456, 19.452753383126257),
                  zoom: 15,
                ),
              )),
        ],
      ),
    ));
  }
}



/*class RestaurantInfo extends StatefulWidget {
  @override
  State createState() {
    return _RestaurantInfo();
  }
}

class _RestaurantInfo extends State<RestaurantInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        children: [
          Text("Restaurant info: "),
          RaisedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => OfferView()));
            },
            child: Text("Offer"),
          ),
          RaisedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => OpinionView()));
            },
            child: Text("Opinion"),
          )
        ],
      ),
    ));
  }
}*/
