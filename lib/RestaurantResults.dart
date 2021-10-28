import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RestaurantResult extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      body: Text("Elo"),
    );
  }
}