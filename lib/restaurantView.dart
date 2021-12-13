import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_care/Business.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'offerView.dart';

class RestaurantView extends StatefulWidget {
  late Business business;
  late double lat;
  late double long;
  late double rating;

  RestaurantView(
      {required this.business,
      required this.lat,
      required this.long,
      required this.rating});

  @override
  State<RestaurantView> createState() => _RestaurantViewState(
      business: business, lat: lat, long: long, rating: rating);
}

class _RestaurantViewState extends State<RestaurantView> {
  late Business business;
  late double lat;
  late double long;
  late double rating;

  _RestaurantViewState(
      {required this.business,
      required this.lat,
      required this.long,
      required this.rating});

  Set<Marker> _markers = {};
  double ratingValue = 0.0;

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _markers.add(Marker(
          markerId: MarkerId('id-1'),
          position: LatLng(lat, long),
          infoWindow: InfoWindow(
            title: '${business.name}',
            snippet: '${business.openHour}-${business.closeHour}',
          )));
    });
  }

  Future<String?> getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("role");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 40,
          ),
          Wrap(
            children: [
              Text(business.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                  ))
            ],
          ),
          Container(
              width: double.infinity,
              height: 100,
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.black)),
                color: Color(0xFFF2F3F5),
              ),
              child: Center(
                  child: business.typeOfBusiness == BusinessType.SHOP
                      ? Image.asset(
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
          Container(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
                    height: 50,
                    width: MediaQuery.of(context).size.width * 4 / 5,
                    decoration: BoxDecoration(),
                    child: Wrap(children: [
                      Text(
                        "Open hours: " +
                            business.openHour +
                            " - " +
                            business.closeHour,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ]),
                  ),
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 1 / 5,
                    child: IconButton(
                        onPressed: () async {
                          try {
                            var dio = Dio();
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            String? token = prefs.getString("token");
                            dio.options.headers["Authorization"] = '$token';
                            Response response = await dio.post(
                                "https://food-care2.herokuapp.com/favorite/business",
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
            height: 50,
            width: MediaQuery.of(context).size.width,
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
                  height: 50,
                  width: MediaQuery.of(context).size.width * 4 / 5,
                  child: Wrap(children: [
                    Text(
                      "Address: " +
                          business.address.street +
                          " " +
                          business.address.streetNumber +
                          ", " +
                          business.address.city,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ]),
                ),
                FutureBuilder(
                  builder: (builder, snapshot) {
                    if (snapshot.hasData) {
                      String role = snapshot.data as String;
                      if (role.compareTo("BUSINESS") != 0) {
                        return Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width * 1 / 5,
                          decoration: BoxDecoration(),
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
                                                    String? token = prefs
                                                        .getString("token");
                                                    dio.options.headers[
                                                            "Authorization"] =
                                                        '$token';
                                                    Response response =
                                                        await dio.post(
                                                            "https://food-care2.herokuapp.com/rating/business",
                                                            data: {
                                                          "businessId":
                                                              business.id,
                                                          "rating": ratingValue,
                                                        });
                                                    if (response.statusCode ==
                                                        200) {
                                                      response = await dio.get(
                                                          "https://food-care2.herokuapp.com/rating/business/${business.id}");
                                                      if (response.statusCode ==
                                                          200) {
                                                        Map<String, dynamic>
                                                            map = response.data;
                                                        double newRating = map
                                                            .values
                                                            .elementAt(1);
                                                        setState(() {
                                                          rating = newRating;
                                                        });
                                                      }

                                                      Navigator.of(context)
                                                          .pop();
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
                                                      itemBuilder:
                                                          (context, _) => Icon(
                                                        Icons.star,
                                                        color: Colors.amber,
                                                      ),
                                                      onRatingUpdate: (value) {
                                                        ratingValue = value;
                                                      },
                                                      itemCount: 5,
                                                      minRating: 0,
                                                      maxRating: 5,
                                                      itemPadding:
                                                          EdgeInsets.symmetric(
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
                                size: 32,
                              )),
                        );
                      }
                    }
                    return Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 1 / 5,
                    );
                  },
                  future: getRole(),
                ),
              ],
            ),
            height: 50,
            width: MediaQuery.of(context).size.width,
          ),
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    width: MediaQuery.of(context).size.width * 4 / 5,
                    padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
                    height: 50,
                    child: Wrap(
                      children: [
                        Text(
                          "Country: " + business.address.country,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    )),
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 1 / 5,
                  child: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OfferView(
                                business: business,
                              ),
                            ));
                      },
                      icon: Icon(
                        Icons.restaurant,
                        color: Colors.black,
                      )),
                ),
              ],
            ),
          ),
          Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              height: 50,
              decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.black))),
              child: rating == 0.0
                  ? Text(
                      "No opinion",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                          Text(
                            "Opinion: " + rating.toString() + "/5",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                            ),
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 25,
                          ),
                        ])),
          Container(
              width: double.infinity,
              height: 350,
              decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.black))),
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                markers: _markers,
                initialCameraPosition: CameraPosition(
                  target: LatLng(lat, long),
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
