import 'package:flutter/material.dart';
import 'package:food_care/Product.dart';
import 'package:food_care/stripe.dart';
import 'package:intl/intl.dart';

import 'Business.dart';

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
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.black)),
                color: Color(0xFFF2F3F5),
              ),
              child: Center(
                child: Text(
                  product.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40,
                  ),
                ),
              )),
          Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Card(
              color: Colors.white,
              elevation: 0,
              child: Container(
                width: 120,
                height: 120,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Image.network(
                        product.image,
                        width: 120,
                        height: 120,
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
              color: Colors.black12,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                  side: BorderSide(color: Colors.black)),
              child: Container(
                width: 200,
                height: 120,
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        product.regularPrice.toString() + " zł",
                        style: TextStyle(
                            fontSize: 25,
                            decoration: TextDecoration.lineThrough),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: Text(product.discountedPrice.toString() + " zł",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 33,
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
              width: double.infinity,
              height: 80,
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.black)),
                //  color: Color(0xFFF2F3F5),
              ),
              child: Center(
                child: Text(
                  "Expiration date: " + product.expirationDate,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              )),
          buyButton(context)
        ],
      ),
    ));
  }

  Widget buyButton(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 27, right: 15, left: 15, bottom: 10),
        child: Container(
          width: double.infinity,
          decoration: new BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(color: Color(0xFFF44336)),
                BoxShadow(color: Color(0xFFFFA726))
              ],
              gradient: new LinearGradient(
                colors: [Color(0xFFF44336), Color(0xFFFFA726)],
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
                  "BUY NOW",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
                  ),
                )),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (builder) => ItemPayView()));
            },
          ),
        ));
  }
}

class ProductResults extends StatelessWidget {
  final List<Product> products;

  ProductResults({required this.products});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
      itemBuilder: (builder, index) {
        return ProductResultsRow(product: products.elementAt(index));
      },
      itemCount: products.length,
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
                        SizedBox(
                          height: 5,
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
