import 'package:flutter/material.dart';

class OpinionView extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Care',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: OpinionInfo(),
      debugShowCheckedModeBanner: false,
    );
  }
}


class OpinionInfo extends StatefulWidget {

  @override
  State createState() {
    return _OpinionInfoState();
  }
}

class _OpinionInfoState extends State<OpinionInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text("Opinion"),
          ],
        ),
      )  
    );
  }
}