import 'package:flutter/material.dart';
import 'package:food_care/Business.dart';
import 'package:food_care/Offer.dart';
import 'package:food_care/SearchRestaurant.dart';
import 'package:food_care/UserProfile.dart';
import 'package:food_care/addProductView.dart';

class MainPage extends StatefulWidget {
  @override
  State createState() {
    return _MainPage();
  }
}

class _MainPage extends State<MainPage> {
  int selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  final List<Widget> widgetOptions = <Widget>[
    MainPageContent(),
    Text(
      'Index 1: Favourites',
      style: optionStyle,
    ),
    SearchRestaurant(),
    LastPageContent(),
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: widgetOptions.elementAt(selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: "Favourites"),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz_outlined), label: "More"),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: onItemTapped,
      ),
    );
  }
}

class ScrollerTitle extends StatelessWidget {
  late String title;

  ScrollerTitle(String title) {
    this.title = title;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8, left: 15, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF3a3a3b),
                  fontWeight: FontWeight.w300))
        ],
      ),
    );
  }
}

class ScrollItems extends StatefulWidget {
  @override
  State createState() {
    return _ScrollItems();
  }
}

class _ScrollItems extends State<ScrollItems> {
  List<Business> businessList = [];
  List<Offer> offersList = [];

  @override
  Widget build(BuildContext context) {
    if (businessList.length != 0) {
      return ListView(
        scrollDirection: Axis.horizontal,
        children: [],
      );
    } else if (offersList.length != 0) {
      return ListView(
        scrollDirection: Axis.horizontal,
        children: [],
      );
    }
    return Container(
      height: 80,
      child: Center(
        child: Text(
          "No options available",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(5))),
    );
  }
}

class MainPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Column(
          children: [
            ScrollerTitle("Latest offers"),
            ScrollItems(),
            ScrollerTitle("Nearest restaurants"),
            ScrollItems(),
            ScrollerTitle("Best restaurants"),
            ScrollItems(),
          ],
        )
      ],
    );
  }
}

class LastPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Column(
          children: [
            UserProfileButton(context),
            addProductButton(context),
          ],
        )
      ],
    );
  }

  Widget UserProfileButton(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 40, left: 25, right: 25),
        child: Container(
          width: double.infinity,
          decoration: new BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(color: Color(0xFF6F6462)),
                BoxShadow(color: Color(0xFFBBAA92))
              ],
              gradient: new LinearGradient(
                colors: [Color(0xFF6F6462), Color(0xFFBBAA92)],
                begin: const FractionalOffset(0.2, 0.2),
                end: const FractionalOffset(1.0, 1.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              )),
          child: MaterialButton(
            highlightColor: Colors.transparent,
            splashColor: Color(0xFFf7418c),
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
                child: Text(
                  "PROFILE",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
                  ),
                )),
            onPressed: () => {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UserProfile()))
            },
          ),
        ));
  }

  Widget addProductButton(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 40, left: 25, right: 25),
        child: Container(
          width: double.infinity,
          decoration: new BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(color: Color(0xFF6F6462)),
                BoxShadow(color: Color(0xFFBBAA92))
              ],
              gradient: new LinearGradient(
                colors: [Color(0xFF6F6462), Color(0xFFBBAA92)],
                begin: const FractionalOffset(0.2, 0.2),
                end: const FractionalOffset(1.0, 1.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              )),
          child: MaterialButton(
            highlightColor: Colors.transparent,
            splashColor: Color(0xFFf7418c),
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
                child: Text(
                  "ADD PRODUCT",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
                  ),
                )),
            onPressed: () => {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddProductView()))
            },
          ),
        ));
  }
}
