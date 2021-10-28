import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_care/RestaurantResults.dart';

class SearchRestaurant extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SearchRestaurantWidget(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SearchRestaurantWidget extends StatefulWidget{

  @override
  State createState() {
    return _SearchRestaurantWidget();
  }
}


class _SearchRestaurantWidget extends State<SearchRestaurantWidget>{

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RaisedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => RestaurantResult()));
        },
          child: Text("Search"),)
      ],
    );
  }
}