import 'package:flutter/material.dart';
import 'package:food_care/opinionView.dart';

class OfferView extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Care',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: OfferInfo(),
      debugShowCheckedModeBanner: false,
    );
  }
}


class OfferInfo extends StatefulWidget{

  @override
  State createState() {
    return _OfferInfo();
  }
}

class _OfferInfo extends State<OfferInfo>{
  @override
  Widget build(BuildContext context) {
     return Scaffold(
       
      body: Center(
        child: Column(
          children: [
            Text("Offer:"),
          ],
        ),
      )  
    );
  }
  
}