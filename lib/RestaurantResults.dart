import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_care/restaurantView.dart';

class RestaurantResult extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Care',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: ShownRestaurants(),
      debugShowCheckedModeBanner: false,
    );
  }
}


class ShownRestaurants extends StatefulWidget{

  @override
  State createState() {
    return _ShownRestaurants();
  }
}

class _ShownRestaurants extends State<ShownRestaurants>{

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