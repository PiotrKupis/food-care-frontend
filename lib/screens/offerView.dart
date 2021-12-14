import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:food_care/screens/productView.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/Business.dart';
import '../model/Product.dart';

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
          if (products.length != 0) {
            return ListView.builder(
              itemBuilder: (builder, index) {
                return ProductResultsRow(product: products.elementAt(index));
              },
              itemCount: products.length,
            );
          }
          return Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Text(
              "Empty list",
              style: TextStyle(fontSize: 32),
            ),
            alignment: Alignment.center,
          );
        }
        return Container(
          child: watingAnimation(),
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
        );
      },
      future: getOffers(),
    ));
  }

  Widget watingAnimation() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          "Please wait...",
          style: TextStyle(
            fontSize: 18,
            color: Colors.purple,
            fontWeight: FontWeight.w300,
          ),
        )
      ],
    );
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
