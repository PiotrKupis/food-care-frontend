import 'package:flutter/material.dart';
import 'package:food_care/opinionView.dart';



class OfferView extends StatefulWidget{

  @override
  State createState() {
    return _OfferView();
  }
}

class _OfferView extends State<OfferView>{
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