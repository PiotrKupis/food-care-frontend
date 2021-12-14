import 'package:food_care/main.dart';
import 'package:food_care/screens/productView.dart';
import 'package:food_care/screens/restaurantView.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:food_care/model/Business.dart';
import 'package:food_care/model/Product.dart';
import 'package:food_care/model/SearchRestaurant.dart';
import 'package:food_care/screens/UserProfile.dart';
import 'package:food_care/screens/addProductView.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'businessOffer.dart';
import 'favoritesView.dart';

class MainPage extends StatefulWidget {
  @override
  State createState() {
    return _MainPage();
  }
}

class _MainPage extends State<MainPage> {
  int selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  final List<Widget> widgetOptions = <Widget>[
    MainPageContent(),
    FavoritesRestaurants(),
    SearchRestaurant(),
    LastPageContent(),
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: widgetOptions.elementAt(selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: "Favourites"),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz_outlined), label: "More"),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: onItemTapped,
      ),
    );
  }
}

class ScrollerTitle extends StatelessWidget {
  late String title;

  ScrollerTitle(String title) {
    this.title = title;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8, left: 15, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF3a3a3b),
                  fontWeight: FontWeight.w300))
        ],
      ),
    );
  }
}

class ScrollItems extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ScrollItems();
  }
}

class _ScrollItems extends State<ScrollItems> {
  Future<List<Business>> getNearestCities() async {
    Response? response;
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      var dio = Dio();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");
      dio.options.headers["Authorization"] = '$token';
      double longitude = position.longitude;
      double latitude = position.latitude;
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      List<String> street = placemarks.first.street!.split(" ");
      response = await dio.post(
          "https://food-care2.herokuapp.com/get_nearest_restaurants_list",
          data: {
            "city": placemarks.first.locality,
            "street": street.first,
            "streetNumber": street.last,
            "longitude": longitude,
            "latitude": latitude
          });
      if (response.statusCode == 200) {
        List<dynamic> products = response.data;
        List<Business> list = [];
        products.forEach((element) {
          Map<String, dynamic> map = element;
          list.add(Business.fromJson(map));
        });
        return list;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Widget getBusinessContainer(Business business) {
    return InkWell(
      onTap: () async {
        try {
          var dio = Dio();
          SharedPreferences prefs = await SharedPreferences.getInstance();
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Card(
              color: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                  side: BorderSide(color: Colors.black)),
              child: Container(
                width: 120,
                height: 120,
                margin: EdgeInsets.only(left: 5, right: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 0),
                      child: Image.asset(
                        business.typeOfBusiness == BusinessType.SHOP
                            ? "images/shop.png"
                            : "images/restaurant-.png",
                        width: 50,
                        height: 50,
                      ),
                    ),
                    Text(
                      business.name,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    Text(business.address.street +
                        " " +
                        business.address.streetNumber),
                    Text(
                        business.address.city + " " + business.address.zipCode),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getNearestCities(),
        builder: (context, snapshot) {
          if (snapshot.hasData == false) {
            return Container(
              height: 130,
              child: Center(
                child: Text(
                  "No options available",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(5))),
            );
          } else {
            List<Business> businesses = snapshot.data as List<Business>;
            if (businesses.isEmpty) {
              return Container(
                height: 130,
                child: Center(
                  child: Text(
                    "No options available",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                margin: const EdgeInsets.all(10.0),
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
              );
            }
            return Container(
                height: 140,
                margin: const EdgeInsets.all(10.0),
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Container(
                      height: 125,
                      color: Colors.white,
                      child: getBusinessContainer(businesses.elementAt(index)),
                    );
                  },
                  itemCount: businesses.length,
                  scrollDirection: Axis.horizontal,
                ));
          }
        });
  }
}

class FavoritesRestaurants extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FavoritesRestaurants();
  }
}

class _FavoritesRestaurants extends State<FavoritesRestaurants> {
  Future<List<Business>> getFavoritesRestaurants() async {
    try {
      var dio = Dio();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");
      dio.options.headers["Authorization"] = '$token';
      Response response = await dio.get(
        "https://food-care2.herokuapp.com/favorite/business",
      );
      if (response.statusCode == 200) {
        List<dynamic> business = response.data;
        List<Business> list = [];
        business.forEach((element) {
          Map<String, dynamic> map = element;
          list.add(Business.fromJson(map));
        });
        return list;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Widget getBusinessContainer(Business business) {
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
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(5),
                    child: business.typeOfBusiness == BusinessType.RESTAURANT
                        ? Icon(Icons.restaurant)
                        : Icon(
                            Icons.shopping_basket,
                            size: 40,
                            color: Colors.amber,
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
                            "${business.name}",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Center(
                          child: Text(
                            "${business.address.country}, ${business.address.city} ${business.address.zipCode}",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Center(
                          child: Text(
                            " ${business.address.street} ${business.address.streetNumber}",
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getFavoritesRestaurants(),
        builder: (context, snapshot) {
          if (snapshot.hasData == false) {
            return Scaffold(
                // resizeToAvoidBottomInset: false,
                body: Container(
              width: double.infinity,
              child: Text(" ",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey)),
              alignment: Alignment.center,
            ));
          } else {
            List<Business> businesses = snapshot.data as List<Business>;

            if (businesses.isEmpty) {
              return Scaffold(
                  body: Container(
                width: double.infinity,
                child: Text("Empty Favorites",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey)),
                alignment: Alignment.center,
              ));
            }
            return FavoritesView(businessList: businesses);
          }
        });
  }
}

class ScrollBestRestaurant extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ScrollBestRestaurant();
  }
}

class _ScrollBestRestaurant extends State<ScrollBestRestaurant> {
  Future<List<Business>> getOffers(int num) async {
    try {
      var dio = Dio();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");
      dio.options.headers["Authorization"] = '$token';
      Response response = await dio.get(
          "https://food-care2.herokuapp.com/business/top_rated",
          queryParameters: {"quantity": num});
      if (response.statusCode == 200) {
        List<dynamic> products = response.data;
        List<Business> list = [];
        products.forEach((element) {
          Map<String, dynamic> map = element;
          list.add(Business.fromJson(map));
        });
        return list;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Widget getBusinessContainer(Business business) {
    return InkWell(
      onTap: () async {
        try {
          var dio = Dio();
          SharedPreferences prefs = await SharedPreferences.getInstance();
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Card(
              color: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                  side: BorderSide(color: Colors.black)),
              child: Container(
                width: 120,
                height: 120,
                margin: EdgeInsets.only(left: 5, right: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 0),
                      child: Image.asset(
                        business.typeOfBusiness == BusinessType.SHOP
                            ? "images/shop.png"
                            : "images/restaurant-.png",
                        width: 50,
                        height: 50,
                      ),
                    ),
                    Text(
                      business.name,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    Text(business.address.street +
                        " " +
                        business.address.streetNumber),
                    Text(
                        business.address.city + " " + business.address.zipCode),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getOffers(6),
        builder: (context, snapshot) {
          if (snapshot.hasData == false) {
            return Container(
              height: 130,
              child: Center(
                child: Text(
                  "No options available",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(5))),
            );
          } else {
            List<Business> businesses = snapshot.data as List<Business>;

            if (businesses.isEmpty) {
              return Container(
                height: 130,
                child: Center(
                  child: Text(
                    "No options available",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                margin: const EdgeInsets.all(10.0),
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
              );
            }
            return Container(
                height: 140,
                margin: const EdgeInsets.all(10.0),
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Container(
                      height: 125,
                      color: Colors.white,
                      child: getBusinessContainer(businesses.elementAt(index)),
                    );
                  },
                  itemCount: businesses.length,
                  scrollDirection: Axis.horizontal,
                ));
          }
        });
  }
}

class ScrollLatestFoodItems extends StatefulWidget {
  @override
  State createState() {
    return _ScrollLatestFoodItems();
  }
}

class _ScrollLatestFoodItems extends State<ScrollLatestFoodItems> {
  Future<List<Product>> getOffers(int num) async {
    try {
      var dio = Dio();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");
      dio.options.headers["Authorization"] = '$token';
      Response response = await dio.get(
          "https://food-care2.herokuapp.com/product/search_latest",
          queryParameters: {"quantity": num});
      if (response.statusCode == 200) {
        List<dynamic> products = response.data;
        List<Product> list = [];
        products.forEach((element) {
          Map<String, dynamic> map = element;
          list.add(Product.fromJson(map));
        });
        return list;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getOffers(6),
        builder: (context, snapshot) {
          if (snapshot.hasData == false) {
            return Container(
              height: 140,
              child: Center(
                child: Text(
                  "No options available",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(5))),
            );
          } else {
            List<Product> products = snapshot.data as List<Product>;
            if (products.length == 0) {
              return Container(
                height: 140,
                child: Center(
                  child: Text(
                    "No options available",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                margin: const EdgeInsets.all(10.0),
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
              );
            }
            return Container(
                height: 150,
                margin: const EdgeInsets.all(10.0),
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Container(
                      height: 135,
                      color: Colors.white,
                      child: getProductContainer(products.elementAt(index)),
                    );
                  },
                  itemCount: products.length,
                  scrollDirection: Axis.horizontal,
                ));
          }
        });
  }

  Widget getProductContainer(Product product) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductView(
                      product: product,
                    )));
      },
      child: Column(
        children: [
          Container(
            child: Card(
              color: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                  side: BorderSide(color: Colors.black)),
              child: Container(
                width: 130,
                height: 130,
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      child: Image.network(
                        product.image,
                        width: 80,
                        height: 80,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      alignment: Alignment.bottomCenter,
                      child: Text(product.name,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FavoritesRestaurantsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        FavoritesRestaurants(),
      ],
    );
  }
}

class MainPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Column(
          children: [
            ScrollerTitle("Latest offers"),
            ScrollLatestFoodItems(),
            ScrollerTitle("Nearest restaurants"),
            ScrollItems(),
            ScrollerTitle("Best restaurants"),
            ScrollBestRestaurant(),
          ],
        )
      ],
    );
  }
}

class LastPageContent extends StatelessWidget {
  Future<String?> getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("role");
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Column(
          children: [
            userProfileButton(context),
            FutureBuilder(
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  String role = snapshot.data as String;
                  if (role.compareTo("USER") == 0) {
                    return Container();
                  }
                  return addProductButton(context);
                }
                return (Container());
              },
              future: getRole(),
            ),
            FutureBuilder(
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  String role = snapshot.data as String;
                  if (role.compareTo("BUSINESS") == 0) {
                    return Container();
                  }
                  return businessButton(context);
                }
                return Container();
              },
              future: getRole(),
            ),
            FutureBuilder(
              builder: (builder, snapshot) {
                if (snapshot.hasData) {
                  String role = snapshot.data as String;
                  if (role.compareTo("BUSINESS") == 0) {
                    return Container();
                  }
                  return getUserOrders(context);
                }
                return Container();
              },
              future: getRole(),
            ),
            FutureBuilder(
              builder: (builder, snapshot) {
                if (snapshot.hasData) {
                  String role = snapshot.data as String;
                  if (role.compareTo("BUSINESS") == 0) {
                    return getBusinessOrders(context);
                  }
                  return Container();
                }
                return Container();
              },
              future: getRole(),
            ),
            FutureBuilder(
              builder: (builder, snapshot) {
                if (snapshot.hasData) {
                  String role = snapshot.data as String;
                  if (role.compareTo("BUSINESS") == 0) {
                    return businessOfferButton(context);
                  }
                  return Container();
                }
                return Container();
              },
              future: getRole(),
            ),
            logoutButton(context),
          ],
        )
      ],
    );
  }

  Widget userProfileButton(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 40, left: 25, right: 25),
        child: Container(
          width: double.infinity,
          child: ElevatedButton(
            style:
                ElevatedButton.styleFrom(elevation: 5, primary: Colors.orange),
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 22.0),
                child: Text(
                  "EDIT PROFILE",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                  ),
                )),
            onPressed: () => {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UserProfile()))
            },
          ),
        ));
  }

  Widget addProductButton(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 40, left: 25, right: 25),
        child: Container(
          width: double.infinity,
          child: ElevatedButton(
            style:
                ElevatedButton.styleFrom(elevation: 5, primary: Colors.orange),
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 22.0),
                child: Text(
                  "ADD PRODUCT",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                  ),
                )),
            onPressed: () => {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddProductView()))
            },
          ),
        ));
  }

  Widget businessButton(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 40, left: 25, right: 25),
        child: Container(
          width: double.infinity,
          child: ElevatedButton(
            style:
                ElevatedButton.styleFrom(elevation: 5, primary: Colors.orange),
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 22.0),
                child: Text(
                  "BUSINESS",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                  ),
                )),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BusinessAdd()));
            },
          ),
        ));
  }

  Widget businessOfferButton(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 40, left: 25, right: 25),
        child: Container(
          width: double.infinity,
          child: ElevatedButton(
            style:
                ElevatedButton.styleFrom(elevation: 5, primary: Colors.orange),
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 22.0),
                child: Text(
                  "BUSINESS OFFER",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                  ),
                )),
            onPressed: () async {
              List<Product> products = await getBusinessProducts();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BusinessOffer(
                            products: products,
                          )));
            },
          ),
        ));
  }

  Future<List<Product>> getBusinessProducts() async {
    try {
      var dio = Dio();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");
      int? id = prefs.getInt("id");
      dio.options.headers["Authorization"] = token;
      Response response = await dio.get(
          "https://food-care2.herokuapp.com/product/get_products_list/" +
              id.toString());
      List<dynamic> list = response.data;
      List<Product> products = [];
      list.forEach((element) {
        Map<String, dynamic> map = element;
        Product product = Product.fromJson(map);
        products.add(product);
      });
      return products;
    } catch (e) {
      debugPrint(e.toString());
    }
    throw Exception("");
  }

  Widget logoutButton(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 40, left: 25, right: 25),
        child: Container(
          width: double.infinity,
          child: ElevatedButton(
            style:
                ElevatedButton.styleFrom(elevation: 5, primary: Colors.orange),
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 22.0),
                child: Text(
                  "LOG OUT",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
                  ),
                )),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => MyHomePage(title: "Food Care")),
                  (route) => false);
            },
          ),
        ));
  }

  Widget getUserOrders(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 40, left: 25, right: 25),
        child: Container(
          width: double.infinity,
          child: ElevatedButton(
            style:
                ElevatedButton.styleFrom(elevation: 5, primary: Colors.orange),
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 22.0),
                child: Text(
                  "CHECK MY ORDERS",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
                  ),
                )),
            onPressed: () async {
              try {
                var dio = Dio();
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String? token = prefs.getString("token");
                int? id = prefs.getInt("id");
                dio.options.headers["Authorization"] = token;
                Response response = await dio.get(
                    "https://food-care2.herokuapp.com/product/get_products_from_orders_by_userId/$id");
                if (response.statusCode == 200) {
                  List<dynamic> productList = response.data;
                  List<Product> list = [];
                  productList.forEach((element) {
                    Map<String, dynamic> map = element;
                    list.add(Product.fromJson(map));
                  });
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => UserBoughtItems(
                                products: list,
                              )));
                }
              } catch (e) {
                debugPrint(e.toString());
              }
            },
          ),
        ));
  }

  Widget getBusinessOrders(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 40, left: 25, right: 25),
        child: Container(
          width: double.infinity,
          child: ElevatedButton(
            style:
                ElevatedButton.styleFrom(elevation: 5, primary: Colors.orange),
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 22.0),
                child: Text(
                  "MY SALED ORDERS",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
                  ),
                )),
            onPressed: () async {
              try {
                var dio = Dio();
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String? token = prefs.getString("token");
                int? id = prefs.getInt("id");
                dio.options.headers["Authorization"] = token;
                Response response = await dio.get(
                    "https://food-care2.herokuapp.com/product/get_products_from_orders_by_businessId/" +
                        id.toString());
                if (response.statusCode == 200) {
                  List<dynamic> productList = response.data;
                  List<Product> list = [];
                  productList.forEach((element) {
                    Map<String, dynamic> map = element;
                    list.add(Product.fromJson(map));
                  });
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => BusinessSales(
                                products: list,
                              )));
                }
              } catch (e) {
                debugPrint(e.toString());
              }
            },
          ),
        ));
  }
}
