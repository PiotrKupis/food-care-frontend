import 'package:flutter/material.dart';
import 'package:food_care/model/Product.dart';
import 'package:food_care/model/stripe.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/Business.dart';

class ProductView extends StatefulWidget {
  late Product product;
  late Business business;

  ProductView({required this.product});

  @override
  State<ProductView> createState() => _ProductView(product: product);
}

class _ProductView extends State<ProductView> {
  late Product product;
  late Business business;
  _ProductView({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          Container(
              width: double.infinity,
              height: 100,
              padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
              child: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Text(
                    product.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                    ),
                  ),
                ],
              )),
          Container(
            child: Card(
              color: Colors.transparent,
              elevation: 0,
              child: Container(
                width: 140,
                height: 140,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Image.network(
                        product.image,
                        width: 140,
                        height: 140,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Card(
              color: Colors.transparent,
              elevation: 0,
              child: Container(
                width: 140,
                height: 100,
                child: Column(
                  children: <Widget>[
                    product.regularPrice != product.discountedPrice
                        ? Container(
                            child: Text(
                              product.regularPrice.toString() + " zł",
                              style: TextStyle(
                                  fontSize: 32,
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        : SizedBox(),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: Text(product.discountedPrice.toString() + " zł",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 40,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
              width: double.infinity,
              height: 50,
              child: Center(
                child: Text(
                  "Expiration date: " + product.expirationDate,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              )),
          Container(
              width: double.infinity,
              height: 50,
              child: Center(
                child: Text(
                  "Vegan : " + (product.isVegan ? "Yes" : "No"),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              )),
          FutureBuilder(
            builder: (builder, snapshot) {
              if (snapshot.hasData) {
                String? user = snapshot.data.toString();
                if (user.compareTo("BUSINESS") != 0) {
                  return buyButton(context);
                }
              }
              return Container();
            },
            future: getRole(),
          )
        ],
      ),
    ));
  }

  Future<String?> getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("role");
  }

  Widget buyButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 27, right: 15, left: 15, bottom: 10),
      child: ItemPayView(
        product: product,
      ),
    );
  }
}

class ProductResults extends StatelessWidget {
  final List<Product> products;

  ProductResults({required this.products});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: products.length != 0
            ? ListView.builder(
                itemBuilder: (builder, index) {
                  return ProductResultsRow(product: products.elementAt(index));
                },
                itemCount: products.length,
              )
            : Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                child: Text(
                  "Empty list",
                  style: TextStyle(fontSize: 28),
                ),
                alignment: Alignment.center,
              ));
  }
}

class ProductResultsRow extends StatelessWidget {
  final Product product;

  ProductResultsRow({required this.product});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 130,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Color(0xFFfae3e2).withOpacity(0.3),
          spreadRadius: 1,
          blurRadius: 1,
          offset: Offset(0, 1),
        )
      ]),
      child: Card(
        borderOnForeground: false,
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            side: BorderSide(color: Colors.black.withOpacity(0.3))),
        child: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
            child: InkWell(
              onTap: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => ProductView(product: product)));
              },
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(5),
                    child: Image.network(
                      product.image,
                      fit: BoxFit.fitHeight,
                    ),
                    height: 100,
                    width: 110,
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 100,
                    padding: EdgeInsets.all(5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            "${product.name}",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}

class ProductRow extends StatelessWidget {
  final Product product;

  ProductRow({required this.product});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 130,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Color(0xFFfae3e2).withOpacity(0.3),
          spreadRadius: 1,
          blurRadius: 1,
          offset: Offset(0, 1),
        )
      ]),
      child: Card(
        borderOnForeground: false,
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            side: BorderSide(color: Colors.black.withOpacity(0.3))),
        child: Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
          child: Row(
            children: [
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(5),
                child: Image.network(
                  product.image,
                  fit: BoxFit.fitHeight,
                ),
                height: 100,
                width: 110,
              ),
              Container(
                alignment: Alignment.center,
                height: 100,
                padding: EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        "${product.name}",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
