import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Product.dart';
import 'editProductView.dart';

class BusinessOffer extends StatefulWidget {
  late List<Product> products;

  BusinessOffer({required this.products});

  @override
  State createState() => _BusinessOffer(products);
}

class _BusinessOffer extends State<BusinessOffer> {
  late List<Product> products;
  _BusinessOffer(this.products) {}

  @override
  Widget build(BuildContext context) {
    debugPrint(products.length.toString());
    return Scaffold(
        appBar: AppBar(
          title: Text("Business offers"),
          automaticallyImplyLeading: false,
        ),
        resizeToAvoidBottomInset: false,
        body: products.length != 0
            ? ListView.builder(
                itemBuilder: (context, index) {
                  return getItem(products.elementAt(index));
                },
                itemCount: products.length,
              )
            : Container(
                width: double.infinity,
                child: Text("Empty products offer",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey)),
                alignment: Alignment.center,
              ));
  }

  Widget getItem(Product product) {
    return Container(
      width: double.infinity,
      height: 140,
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
          alignment: Alignment.center,
          padding: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                alignment: Alignment.center,
                child: Image.network(
                  product.image,
                  width: 100,
                  height: 100,
                  fit: BoxFit.fitHeight,
                ),
                width: MediaQuery.of(context).size.width * 2 / 6,
                height: 130,
              ),
              Container(
                height: 130,
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 2 / 6,
                child: Wrap(
                  children: [
                    Container(
                      child: Center(
                        child: Text(
                          "${product.name}",
                          style: TextStyle(fontSize: 22),
                        ),
                      ),
                      width: 180,
                    ),
                    product.discountedPrice != product.regularPrice
                        ? Center(
                            child: Text(
                              "Price: ${product.regularPrice} zł",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                  decoration: TextDecoration.lineThrough),
                            ),
                          )
                        : Center(
                            child: Text(
                              "Price: ${product.regularPrice} zł",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                    product.discountedPrice != product.regularPrice
                        ? Center(
                            child: Text(
                              "Price: ${product.discountedPrice} zł",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
              Container(
                height: 130,
                alignment: Alignment.centerRight,
                width: MediaQuery.of(context).size.width * 2 / 8,
                child: IconButton(
                    onPressed: () async {
                      int id = product.id;
                      try {
                        var dio = Dio();
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        String? token = prefs.getString("token");
                        dio.options.headers["Authorization"] = '$token';
                        Response response;
                        response = await dio.delete(
                            "https://food-care2.herokuapp.com/product/delete_product/${product.id}");

                        if (response.statusCode == 200) {
                          setState(() {
                            products.removeWhere((element) => element.id == id);
                          });
                        }
                      } catch (e) {
                        debugPrint(e.toString());
                      }
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
