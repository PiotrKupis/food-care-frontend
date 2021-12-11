import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:food_care/productView.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Business.dart';
import 'Product.dart';

class OfferView extends StatefulWidget {
  final Business business;

  const OfferView({Key? key, required this.business}) : super(key: key);

  @override
  State createState() {
    return _OfferView();
  }
}

class _OfferView extends State<OfferView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      builder: (builder, snapshot) {
        if (snapshot.hasData) {
          List<Product> products = snapshot.data as List<Product>;
          print(products.length);
          return ListView.builder(
            itemBuilder: (builder, index) {
              return ProductResultsRow(product: products.elementAt(index));
            },
            itemCount: products.length,
          );
        }
        return Container();
      },
      future: getOffers(),
    ));
  }

  Future<List<Product>> getOffers() async {
    try {
      var dio = Dio();
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? token = sharedPreferences.getString("token");
      dio.options.headers["Authorization"] = '$token';
      Response response = await dio.get(
          "https://food-care2.herokuapp.com/product/get_products_list/${widget.business.id}");
      if (response.statusCode == 200) {
        List<dynamic> productList = response.data;
        List<Product> list = [];
        productList.forEach((element) {
          Map<String, dynamic> map = element;
          list.add(Product.fromJson(map));
        });
        return list;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }
}
