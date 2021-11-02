import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_care/RestaurantResults.dart';

class SearchRestaurant extends StatefulWidget {
  @override
  State createState() {
    return _SearchRestaurant();
  }
}

class _SearchRestaurant extends State<SearchRestaurant> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RaisedButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => RestaurantResult()));
          },
          child: Text("Search"),
        )
      ],
    );
  }
}
