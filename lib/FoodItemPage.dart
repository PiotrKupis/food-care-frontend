import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/FoodOrderPage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FoodItemCart extends StatefulWidget{

  CartItem card;

  FoodItemCart(String restaurantName,String productName, double price,
      String img,String ID){
    card = new CartItem(productName: productName, restaurantName: restaurantName,
    productImage: img, productPrice: price,ID: ID);
  }


  @override
  State createState() {
    return _FoodItemCart(card);
  }
}

class _FoodItemCart extends State<FoodItemCart>{

  CartItem cart;
  _FoodItemCart(CartItem cart){this.cart = cart;}

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Color(0xFF3a3737),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          brightness: Brightness.light,
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.shopping_basket_outlined,
                  color: Color(0xFF3a3737),
                ),
                onPressed: () {
                  Navigator.push(context, new MaterialPageRoute(builder: (context) => FoodOrderPage()));
                })
          ],
        ),
        body: Container(
          padding: EdgeInsets.only(
            left: 10,
            right: 10,
          ),
          child: Column(
            children: <Widget>[
              SizedBox(height: 10,),
              getText(cart.productName),
              SizedBox(height: 5,),
              Container(
                child: Card(
                  semanticContainer: true,
                  clipBehavior: Clip.none,
                  child: Image.network(
                    cart.productImage,
                    fit: BoxFit.fitHeight,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                  elevation: 1,
                  margin: EdgeInsets.all(5),
                ),
                height: 300,
                width: 300,
              ),
              SizedBox(height: 5,),
              Row(
                children: [
                  getText("from: "),
                  getText(cart.restaurantName),
                  SizedBox(width: 165,),
                  getText(cart.productPrice.toString() + " zł"),
                ],
              ),
              SizedBox(height: 5,),
              AddToCartMenu(cart),
            ],
          ),
        ),
      ),
    );
  }


  Widget getText(String text){
    return Text(
      text,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
    );
  }

}

class CartItem{

  String productName;
  double productPrice;
  String productImage;
  String restaurantName;
  String ID;

  CartItem({@required this.productName, @required this.productPrice,
    @required this.productImage,@required this.restaurantName,@required this.ID});

}

class AddToCartMenu extends StatelessWidget{

  CartItem item;

  AddToCartMenu(CartItem item){
    this.item = item;
  }

  void _showToast(BuildContext context) {
    Fluttertoast.showToast(
        msg: "You have added " + item.productName,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _showToast(context);
        bool flag = false;
        FoodOrderPage.items.forEach((key, value) {
          if(key.productName.compareTo(item.productName) == 0 && key.restaurantName.compareTo(item.restaurantName) == 0){
            FoodOrderPage.items.update(key, (v) => v = ++value);
            flag = true;
          }
        });
        if(flag == false){
          FoodOrderPage.items.putIfAbsent(item, () => 1);
        }
      },
      child: Container(
        width: 220.0,
        height: 50.0,
        decoration: new BoxDecoration(
          color: Color(0xFFfd2c2c),
          border: Border.all(color: Colors.white, width: 2.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: Text(
            'Add To Bag',
            style: new TextStyle(
                fontSize: 18.0,
                color: Colors.white,
                fontWeight: FontWeight.w400),
          ),
        ),
      ),
    );
  }
}