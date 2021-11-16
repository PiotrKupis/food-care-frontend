import 'package:flutter/material.dart';
import 'editProductView.dart';


class BusinessOffer extends StatefulWidget {
  @override
  State createState() => _BusinessOffer();
}

class _BusinessOffer extends State<BusinessOffer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Business offers"),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Center(
          child: Column(
            children: [
              Text("Products list"),
              RaisedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditProductView()));
                },
                child: Text("Edit"),
              )
            ],
          ),
        ));
  }

}