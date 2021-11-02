import 'package:flutter/material.dart';

class EditProductView extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Care',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: EditProductWidget(context: context,),
      debugShowCheckedModeBanner: false,
    );
  }
}


class EditProductWidget extends StatefulWidget{

 
  BuildContext context;

  EditProductWidget({this.context});

  @override
  State createState() => _EditProductWidget(oldContext: context);


}


class _EditProductWidget extends State<EditProductWidget>{

  String dataName;
  BuildContext oldContext;

  _EditProductWidget({this.oldContext});


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
          onPressed: (){
            Navigator.of(oldContext).pop();
          },
        ),
      ),
      body: Center(
        child: Column(
          children: [
           Text("Edit product")
          ],
        ),
      )  
    );
  }
}