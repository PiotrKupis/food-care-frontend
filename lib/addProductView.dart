import 'package:flutter/material.dart';




class AddProductView extends StatefulWidget{

  @override
  State createState() => _AddProductView();


}


class _AddProductView extends State<AddProductView>{

  String dataName;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add product"),
        leading: IconButton(
          icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
          ),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Column(
          children: [
           Text("Add product")
          ],
        ),
      )  
    );
  }
}