import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/FoodItemPage.dart';
import 'package:flutter_app/MainPage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FoodOrderPage extends StatefulWidget{

  static Map<CartItem,int> items = Map();
  @override
  State createState() {
    return _FoodOrderPage();
  }
}


class _FoodOrderPage extends State<FoodOrderPage>{

  static List<CartItemDetails> list = [];
  static List<int> itemCount = [];

  _FoodOrderPage(){
    init();
  }

  static void init(){
    list.clear();
    itemCount.clear();
    for(int i = 0 ; i < FoodOrderPage.items.length; i++){
      itemCount.add(FoodOrderPage.items.values.toList().elementAt(i));
      CartItemDetails item = new CartItemDetails(productName: FoodOrderPage.items.keys.toList().elementAt(i).productName,
          productPrice: FoodOrderPage.items.keys.toList().elementAt(i).productPrice,
          productImage:FoodOrderPage.items.keys.toList().elementAt(i).productImage,
          restaurantName: FoodOrderPage.items.keys.toList().elementAt(i).restaurantName,
          ID: FoodOrderPage.items.keys.toList().elementAt(i).ID,number: itemCount.elementAt(i));
      list.add(item);
    }
  }

  Future<void> _displayTextInputDialog(BuildContext context,String price) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Pay $price zł for food'),
            content: ListView(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: InputDecoration(hintText: "Cart number"),
                    ),
                    TextField(
                      decoration: InputDecoration(hintText: "Expiration date"),
                    ),
                    TextField(
                      decoration: InputDecoration(hintText: "CVV"),
                    ),
                  ],
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                textColor: Colors.white,
                child: Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                child: Text('OK'),
                onPressed: () {
                  setState(() {
                    FoodOrderPage.items.clear();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage(MainPage.user)));

                  });
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: Text("Shopping cart"),
        actions: [
          Padding(
            padding: EdgeInsets.only(right:10),
              child: IconButton(
                  icon : Icon(
                      Icons.payments_outlined
                  ),
                onPressed: (){
                    if(list.isEmpty){
                      Fluttertoast.showToast(
                          msg: "Your list is empty",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                    }
                    else{
                      double sum = 0;
                      FoodOrderPage.items.forEach((key, value) {
                        sum += key.productPrice * value;
                      });
                      _displayTextInputDialog(context,sum.toString());
                    }
                },
              )
          )
        ],
      ),
      body: list.length == 0 ? Container(
        height: double.infinity,
        width: double.infinity,
        child: Text("Empty basket",
            style:TextStyle(fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Colors.grey
            )),
        alignment: Alignment.center,
      ) : ListView(
        children: [
          Column(
              children:
              list.length != 0? list: [Container(
                height: double.infinity,
                width: double.infinity,
                child: Text("Empty basket",
                    style:TextStyle(fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey
                    )),
                alignment: Alignment.center,
                color: Colors.white,
              )],
          ),
        ],
      ),
    );
  }



}

class CartItemDetails extends StatefulWidget{

  String productName;
  double productPrice;
  String productImage;
  String restaurantName;
  String ID;
  int number;

  CartItemDetails({@required this.productName, @required this.productPrice,
    @required this.productImage,@required this.restaurantName,@required this.ID, @required this.number});


  @override
  State<StatefulWidget> createState() {
    return _CartItemDetails(productName: productName, productPrice: productPrice,
        productImage: productImage, restaurantName: restaurantName, ID: ID, number: number);
  }



}

class _CartItemDetails extends State<CartItemDetails>{

  String productName;
  double productPrice;
  String productImage;
  String restaurantName;
  String ID;
  int number;

  _CartItemDetails({@required this.productName, @required this.productPrice,
    @required this.productImage,@required this.restaurantName,@required this.ID, @required this.number});

  bool checkIfSame(CartItem item){
    return productName == item.productName && productPrice == item.productPrice
        && restaurantName == item.restaurantName;
  }

  bool checkIfSameItems(CartItemDetails item){
    return productName == item.productName && productPrice == item.productPrice
        && restaurantName == item.restaurantName;
  }

  @override
  Widget build(BuildContext context) {
    return  number != 0 ? Container(
      width: double.infinity,
      height: 130,
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(
          color: Color(0xFFfae3e2).withOpacity(0.3),
          spreadRadius: 1,
          blurRadius: 1,
          offset: Offset(0, 1),
        ),
        ],
      ),
      child: number != 0 ? Card(
        borderOnForeground: false,
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(5))
        ),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(left: 5,right: 5,top: 10,bottom: 10),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Center(
                    child: Image.network(productImage,
                      width: 100,
                      height: 100,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child:Text(
                              productName,
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF3a3a3b),
                              ),
                              textAlign: TextAlign.left,
                            ) ,
                            width: 200,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            child: Text(
                              productPrice.toString() + " zł (" + number.toString() + ")",
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFF3a3a3b),
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            child: Text(
                              restaurantName,
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFF3a3a3b),
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          )
                        ],
                      ),
                      Container(
                        child:InkWell(
                          child: Image.asset("images/ic_delete.png",
                            width: 25,
                            height: 25,),
                          onTap: () {
                            if(number >= 1)
                              setState(() {
                                var elem = null;
                                FoodOrderPage.items.forEach((key, value) {
                                  if(checkIfSame(key)){
                                    if(number != 1) {
                                      FoodOrderPage.items.update(
                                          key, (value) => --value);
                                      number--;
                                      return;
                                    }
                                    else{
                                      elem = key;
                                      number = 0;
                                    }
                                  }
                                });
                                if(elem != null){
                                  FoodOrderPage.items.remove(elem);
                                  if(FoodOrderPage.items.length == 0){
                                    _FoodOrderPage.init();
                                  }
                                }

                              });
                          },
                        ),
                        alignment: Alignment.centerRight,
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ) : Container(
        height: double.infinity,
        width: double.infinity,
        child: Text("Empty basket",
            style:TextStyle(fontSize: 20,
                fontWeight: FontWeight.w400,
                color: Colors.grey
            )),
        alignment: Alignment.center,
      )
    ) : Container(

    );
  }

}