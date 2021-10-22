import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/FoodItem.dart';
import 'Restaurant.dart';
import 'User.dart';
import 'drawer.dart';


class MainPage extends StatelessWidget {

  static User user;
  MainPage(User u) {
    user = u;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MainPageWidget()
    );
  }


}

class MainPageWidget extends StatefulWidget{


  @override
  _MainPageWidget createState() => _MainPageWidget();
}

class _MainPageWidget extends State<MainPageWidget>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      drawer: Drawer(
        child: SideDrawer(),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              RestaurantsList(RestaurantsList.restaurants),
              FoodItemLists(),
            ],
          )
        ],
      ),
    );
  }


}
