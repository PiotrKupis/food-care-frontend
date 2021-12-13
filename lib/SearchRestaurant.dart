import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_care/Product.dart';
import 'package:food_care/restaurant_results.dart';
import 'package:food_care/productView.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'Business.dart';

class SearchRestaurant extends StatefulWidget {
  @override
  State createState() {
    return _SearchRestaurant();
  }
}

class _SearchRestaurant extends State<SearchRestaurant> {
  final key = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  String option = "Business";

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Form(
          key: key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 80,
                child: getSearchField(nameController),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 80,
                child: chooseSearching(),
              ),
              Container(
                child: getSearchButton(),
                width: MediaQuery.of(context).size.width,
                height: 70,
              )
            ],
          ))
    ]);
  }

  Widget chooseSearching() {
    return Row(
      children: [
        Expanded(
          child: ListTile(
            title: const Text("Business"),
            leading: Radio(
                value: "Business",
                groupValue: option,
                onChanged: (String? choice) {
                  setState(() {
                    option = choice!;
                  });
                }),
          ),
        ),
        Expanded(
          child: ListTile(
            title: const Text("Product"),
            leading: Radio(
                value: "Product",
                groupValue: option,
                onChanged: (String? choice) {
                  setState(() {
                    option = choice!;
                  });
                }),
          ),
        ),
      ],
    );
  }

  Widget getSearchButton() {
    return Padding(
        padding: EdgeInsets.all(10),
        child: ElevatedButton(
          child: Text(
            "Search",
            style: TextStyle(fontSize: 22),
          ),
          onPressed: () async {
            if (key.currentState!.validate()) {
              if (option.compareTo("Business") == 0) {
                try {
                  String name = nameController.value.text;
                  var dio = Dio();
                  SharedPreferences sharedPreferences =
                      await SharedPreferences.getInstance();
                  String? token = sharedPreferences.getString("token");
                  dio.options.headers["Authorization"] = '$token';
                  Response response = await dio.get(
                      "https://food-care2.herokuapp.com/find_business_by_name/" +
                          name);
                  if (response.statusCode == 200) {
                    List<dynamic> businessList = response.data;
                    List<Business> list = [];
                    businessList.forEach((element) {
                      Map<String, dynamic> map = element;
                      list.add(Business.fromJson(map));
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RestaurantResult(
                                  businessList: list,
                                )));
                  }
                } catch (e) {
                  debugPrint(e.toString());
                }
              } else if (option.compareTo("Product") == 0) {
                try {
                  await Geolocator.getCurrentPosition(
                          desiredAccuracy: LocationAccuracy.bestForNavigation)
                      .then((value) async {
                    String name = nameController.value.text;
                    double longitude = value.longitude;
                    double latitude = value.latitude;
                    List<Placemark> placemarks =
                        await placemarkFromCoordinates(latitude, longitude);
                    var dio = Dio();
                    SharedPreferences sharedPreferences =
                        await SharedPreferences.getInstance();
                    String? token = sharedPreferences.getString("token");
                    dio.options.headers["Authorization"] = '$token';
                    Response response = await dio.get(
                        "https://food-care2.herokuapp.com/product/search_product_by_city/$name/${placemarks.first.locality}");
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
                              builder: (builder) =>
                                  ProductResults(products: list)));
                    }
                  });
                } catch (e) {
                  debugPrint(e.toString());
                }
              }
            }
          },
        ));
  }

  Widget getSearchField(TextEditingController controller) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: TextFormField(
            controller: controller,
            validator: (String? text) {
              if (text!.isEmpty) {
                return "Enter business/product name";
              }
              return null;
            },
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(width: 4, style: BorderStyle.none)),
              filled: true,
              prefixIcon: Icon(
                Icons.search,
                size: 24,
                color: Color(0xFF666666),
              ),
              fillColor: Color(0xFFF2F3F5),
              hintStyle: TextStyle(color: Color(0xFF666666), fontSize: 17),
              hintText: "Enter business/product name",
            )));
  }

  Widget getCityField() {
    return Padding(
        padding: EdgeInsets.all(10),
        child: TextFormField(
            decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(width: 4, style: BorderStyle.none)),
          filled: true,
          prefixIcon: Icon(
            Icons.location_city,
            size: 24,
            color: Color(0xFF666666),
          ),
          fillColor: Color(0xFFF2F3F5),
          hintStyle: TextStyle(color: Color(0xFF666666), fontSize: 17),
          hintText: "Enter city",
        )));
  }
}
