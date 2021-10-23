import 'package:flutter/material.dart';

class SignIn extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignInState(),
    );
  }

}

class SignInState extends StatefulWidget{

  @override
  State createState() {
    return _SignInState();
  }
}

class _SignInState extends State<SignInState>{


  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }

}