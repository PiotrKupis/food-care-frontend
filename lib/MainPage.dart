
import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:food_care/Business.dart';
import 'package:food_care/Product.dart';
import 'package:food_care/SearchRestaurant.dart';
import 'package:food_care/UserProfile.dart';
import 'package:food_care/addProductView.dart';
import 'package:food_care/restaurantView.dart';
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
   /* Text(
      'Index 1: Favourites',
      style: optionStyle,
    ),*/
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
      response = await dio.post(
          "https://food-care2.herokuapp.com/get_nearest_restaurants_list",
          data: {
            "city": "",
            "street": "",
            "streetNumber": "",
            "longitude": position.longitude,
            "latitude": position.latitude
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
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RestaurantView(business: business)));
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

class FavoritesRestaurants extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _FavoritesRestaurants();
  }
  
}

class _FavoritesRestaurants extends State<FavoritesRestaurants>{
  Future<List<Business>> getFavoritesRestaurants() async {
    try {
      var dio = Dio();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");
      dio.options.headers["Authorization"] = '$token';
      Response response = await dio.get(
          "https://food-care2.herokuapp.com/favorite/business",);
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
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RestaurantView(
                              business: business,
                            )));
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
                body:  Container(
                        width: double.infinity,
                        child: Text("Empty products offer",
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
               // resizeToAvoidBottomInset: false,
                body:  Container(
                        width: double.infinity,
                        child: Text("Empty products offer",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey)),
                        alignment: Alignment.center,
                      ));
  
            }
            return Scaffold(
              body: ListView.builder(
              itemBuilder: (context, index) {
                return BusinessRow(business: businesses.elementAt(index));
              },
              itemCount: businesses.length,
            ));
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
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RestaurantView(business: business)));
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
            List<Product> products = snapshot.data as List<Product>;

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
      onTap: () {},
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
                width: 120,
                height: 120,
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

class FavoritesRestaurantsView extends StatelessWidget{
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
                return (Container());
              },
              future: getRole(),
            ),
            businessOfferButton(context),
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
          decoration: new BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(color: Color(0xFF6F6462)),
                BoxShadow(color: Color(0xFFBBAA92))
              ],
              gradient: new LinearGradient(
                colors: [Color(0xFF6F6462), Color(0xFFBBAA92)],
                begin: const FractionalOffset(0.2, 0.2),
                end: const FractionalOffset(1.0, 1.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              )),
          child: MaterialButton(
            highlightColor: Colors.transparent,
            splashColor: Color(0xFFf7418c),
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
                child: Text(
                  "EDIT PROFILE",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
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
          decoration: new BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(color: Color(0xFF6F6462)),
                BoxShadow(color: Color(0xFFBBAA92))
              ],
              gradient: new LinearGradient(
                colors: [Color(0xFF6F6462), Color(0xFFBBAA92)],
                begin: const FractionalOffset(0.2, 0.2),
                end: const FractionalOffset(1.0, 1.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              )),
          child: MaterialButton(
            highlightColor: Colors.transparent,
            splashColor: Color(0xFFf7418c),
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
                child: Text(
                  "ADD PRODUCT",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
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
          decoration: new BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(color: Color(0xFF6F6462)),
                BoxShadow(color: Color(0xFFBBAA92))
              ],
              gradient: new LinearGradient(
                colors: [Color(0xFF6F6462), Color(0xFFBBAA92)],
                begin: const FractionalOffset(0.2, 0.2),
                end: const FractionalOffset(1.0, 1.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              )),
          child: MaterialButton(
            highlightColor: Colors.transparent,
            splashColor: Color(0xFFf7418c),
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
                child: Text(
                  "BUSINESS",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
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
          decoration: new BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(color: Color(0xFF6F6462)),
                BoxShadow(color: Color(0xFFBBAA92))
              ],
              gradient: new LinearGradient(
                colors: [Color(0xFF6F6462), Color(0xFFBBAA92)],
                begin: const FractionalOffset(0.2, 0.2),
                end: const FractionalOffset(1.0, 1.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              )),
          child: MaterialButton(
            highlightColor: Colors.transparent,
            splashColor: Color(0xFFf7418c),
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
                child: Text(
                  "BUSINESS OFFER",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
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
          decoration: new BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(color: Color(0xFF6F6462)),
                BoxShadow(color: Color(0xFFBBAA92))
              ],
              gradient: new LinearGradient(
                colors: [Color(0xFF6F6462), Color(0xFFBBAA92)],
                begin: const FractionalOffset(0.2, 0.2),
                end: const FractionalOffset(1.0, 1.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              )),
          child: MaterialButton(
            highlightColor: Colors.transparent,
            splashColor: Color(0xFFf7418c),
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
                child: Text(
                  "LOG OUT",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
                  ),
                )),
            onPressed: () {},
          ),
        ));
  }
}
