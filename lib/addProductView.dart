import 'package:flutter/material.dart';

class AddProductView extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Care',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: AddProductWidget(context: context,),
      debugShowCheckedModeBanner: false,
    );
  }
}


class AddProductWidget extends StatefulWidget{

 
  BuildContext context;

  AddProductWidget({this.context});

  @override
  State createState() => _AddProductWidget(oldContext: context);


}


class _AddProductWidget extends State<AddProductWidget>{

  String dataName;
  BuildContext oldContext;

  _AddProductWidget({this.oldContext});


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
            Navigator.of(oldContext).pop();
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