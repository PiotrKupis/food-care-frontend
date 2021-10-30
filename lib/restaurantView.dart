import 'package:flutter/material.dart';
import 'package:food_care/opinionView.dart';

class RestaurantView extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Care',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: RestaurantInfo(),
      debugShowCheckedModeBanner: false,
    );
  }
}


class RestaurantInfo extends StatefulWidget{

  @override
  State createState() {
    return _RestaurantInfo();
  }
}

class _RestaurantInfo extends State<RestaurantInfo>{
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text("Restaurant info:"),
            RaisedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => RestaurantInfo()));
            },
              child: Text("Offer"),),
            RaisedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => OpinionInfo()));
              },
              child: Text("Opinion"),
            )
          ],
        ),
      )  
    );
  }
  
}
