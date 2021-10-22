import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/FoodItemPage.dart';

import 'Restaurant.dart';

class FoodItem extends StatelessWidget{

  String restaurant,ID,img;
  String name;
  double price;

  FoodItem({ @required this.name, @required this.price, @required this.ID,
    @required this.restaurant, @required this.img});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => { Navigator.push(context, MaterialPageRoute(builder: (context) => FoodItemCart(restaurant,name,price,img,ID)))},
      child: Column(
        children: [
          Container(
            child: Card(
              color: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              child:
              Container(
                width: 170,
                height: 170,
                child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              alignment: Alignment.topRight,
                              width: double.infinity,
                              padding: EdgeInsets.only(right: 5, top: 5),
                              child: Container(
                                height: 28,
                                width: 28,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white70,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xFFfae3e2),
                                        blurRadius: 25.0,
                                        offset: Offset(0.0, 0.75),
                                      ),
                                    ]),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left:10,top:10),
                            child: Image.network(img,
                              width: 130,
                              height: 100,),
                          ),

                          Container(
                            alignment: Alignment.bottomLeft,
                            padding: EdgeInsets.only(left: 10, top: 110),
                            child: Text(name +  ", " + price.toString() + " zl",
                                style: TextStyle(
                                    color: Color(0xFF6e6e71),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400)),
                          ),
                        ],
                      ),
                    ]
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FoodRestaurants{

  static List<Restaurant> restaurantsList =[];

}

class FoodItemLists extends StatefulWidget{

  @override
  State createState() => _FoodItemLists();
}


class _FoodItemLists extends State<FoodItemLists>{

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 220,
        width: double.infinity,
        child: Column(
          children: [
            getTitle(),
            Expanded(
              child: FoodItemScroll(),
            )
          ],
        )
    );
  }

  Widget getTitle() {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Popular food",
            style: TextStyle(
                fontSize: 20,
                color: Color(0xFF3a3a3b),
                fontWeight: FontWeight.w300
            )
            ,)
        ],
      ),
    );
  }
}

class FoodItemScroll extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        FoodRestaurants.restaurantsList[0].foodItems[0],
        FoodRestaurants.restaurantsList[1].foodItems[2],
        FoodRestaurants.restaurantsList[2].foodItems[0]
      ],
    );
  }
}