import 'package:flutter/material.dart';


class OpinionView extends StatefulWidget {

  @override
  State createState() {
    return _OpinionView();
  }
}

class _OpinionView extends State<OpinionView> {
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