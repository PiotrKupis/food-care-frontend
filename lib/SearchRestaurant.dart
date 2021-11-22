import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_care/RestaurantResults.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Business.dart';

class SearchRestaurant extends StatefulWidget {
  @override
  State createState() {
    return _SearchRestaurant();
  }
}

class _SearchRestaurant extends State<SearchRestaurant> {
  final key = GlobalKey<FormState>();
  String _veganValue = "NO";
  String _businessType = "SHOP";
  TextEditingController nameController = TextEditingController(),
      cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Form(
              key: key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    child: getSearchField(nameController),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    child: getCityField(),
                  ),
                  Container(
                    height: 100,
                    child: getBusinessTypeInput(),
                    width: MediaQuery.of(context).size.width,
                  ),
                  Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    child: getHasVeganProductButton(),
                  ),
                  Container(
                    child: getSearchButton(),
                    width: MediaQuery.of(context).size.width,
                    height: 70,
                  )
                ],
              ))
        ])
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
            }
          },
        ));
  }

  Widget getHasVeganProductButton() {
    return Padding(
        padding: EdgeInsets.only(top: 5, left: 10, right: 10),
        child: Column(
          children: [
            Text(
              "Has Vegan Products?",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 5,
            ),
            InputDecorator(
              decoration: InputDecoration(
                errorStyle: TextStyle(color: Colors.red, fontSize: 12.0),
                hintText: 'Please select option',
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(width: 4, style: BorderStyle.none),
                ),
              ),
              child: DropdownButton<String>(
                isExpanded: true,
                value: _veganValue,
                onChanged: (String? text) {
                  setState(() {
                    _veganValue = text!;
                  });
                },
                items: <String>["NO", "YES"]
                    .map<DropdownMenuItem<String>>(
                        (e) => DropdownMenuItem<String>(
                              child: Text(e),
                              value: e,
                            ))
                    .toList(),
              ),
            )
          ],
        ));
  }

  Widget getSearchField(TextEditingController controller) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: TextFormField(
            controller: controller,
            validator: (String? text) {
              if (text!.isEmpty) {
                return "Enter business name";
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
                Icons.business,
                size: 24,
                color: Color(0xFF666666),
              ),
              fillColor: Color(0xFFF2F3F5),
              hintStyle: TextStyle(color: Color(0xFF666666), fontSize: 17),
              hintText: "Enter business name",
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

  Widget getBusinessTypeInput() {
    return Padding(
        padding: EdgeInsets.only(
          left: 10,
          right: 10,
          top: 5,
        ),
        child: Column(
          children: [
            Text("Type of business?",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            SizedBox(
              height: 5,
            ),
            InputDecorator(
              decoration: InputDecoration(
                errorStyle: TextStyle(color: Colors.red, fontSize: 12.0),
                hintText: 'Please select option',
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(width: 4, style: BorderStyle.none),
                ),
              ),
              child: DropdownButtonFormField(
                items: <String>["SHOP", "RESTAURANT"]
                    .map<DropdownMenuItem<String>>(
                        (e) => DropdownMenuItem<String>(
                              child: Text(e),
                              value: e,
                            ))
                    .toList(),
                isExpanded: true,
                value: _businessType,
                hint: Text("Choose"),
                onChanged: (value) {
                  setState(() {
                    _businessType = value as String;
                  });
                },
                onSaved: (value) {
                  setState(() {
                    _businessType = value as String;
                  });
                },
              ),
            ),
          ],
        ));
  }
}
