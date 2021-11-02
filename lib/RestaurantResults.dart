import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_care/restaurantView.dart';

class RestaurantResult extends StatefulWidget{

  @override
  State createState() {
    return _RestaurantResult();
  }
}

class _RestaurantResult extends State<RestaurantResult>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text("Restaurants list:"),
            RaisedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => RestaurantInfo()));
            },
              child: Text("Restaurant"),)
          ],
        ),
      )  
    );
  }
}