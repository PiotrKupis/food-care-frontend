import 'package:flutter/material.dart';

class EditProductView extends StatefulWidget {
  @override
  State createState() => _EditProductView();
}

class _EditProductView extends State<EditProductView> {
  late String dataName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Edit product"),
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
            children: [Text("Edit product")],
          ),
        ));
  }
}
