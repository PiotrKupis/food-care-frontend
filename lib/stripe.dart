import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'Product.dart';

class StripePayment {
  static const String key =
      "pk_test_51J3kMGG5cd9OKvLgVETRfnACB1TK6FLWgthgE8vayoJzKH7LAxoXh4LTPUBSXQB6F7p2oMSQN9l9TChD7op8VH8f00AJSkC6fo";
  static const String hidden_key =
      "sk_test_51J3kMGG5cd9OKvLgxw6DSr1QvNORGZtX8TzHSni9hCDYrQiKMd1yRcRtTC9lqD6I301WsRVIsmGog43RR18LuL9h00tkimMNuV";
}

class ItemPayView extends StatefulWidget {
  final Product product;
  ItemPayView({required this.product});

  @override
  State<StatefulWidget> createState() {
    return _ItemPayView();
  }
}

class _ItemPayView extends State<ItemPayView> {
  Map<String, dynamic>? paymentIntentData;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await makePayment();
      },
      style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 60)),
      child: Text(
        "Buy",
        style: TextStyle(fontSize: 32),
      ),
    );
  }

  Future<bool> addOrder() async {
    try {
      var dio = Dio();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");
      int? id = prefs.getInt("id");
      dio.options.headers["Authorization"] = '$token';
      Response response = await dio
          .post("https://food-care2.herokuapp.com/order/add_order", data: {
        "userId": id!,
        "productId": widget.product.id,
        "businessId": widget.product.ownerId
      });
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  createPaymentIntent(String amount) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': 'PLN',
        'payment_method_types[]': 'card'
      };
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'Bearer ${StripePayment.hidden_key}',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      if (response.statusCode == 200) {
        return jsonDecode(response.body.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> makePayment() async {
    try {
      paymentIntentData =
          await createPaymentIntent(widget.product.discountedPrice.toString());
      print(paymentIntentData == null);
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntentData!["client_secret"],
              applePay: true,
              googlePay: true,
              style: ThemeMode.dark,
              merchantCountryCode: 'PL',
              merchantDisplayName: 'Food_Care'));
      await addOrder();
      displayPaymentSheet();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  displayPaymentSheet() async {
    try {
      Stripe.instance
          .presentPaymentSheet(
              parameters: PresentPaymentSheetParameters(
                  clientSecret: paymentIntentData!["client_secret"],
                  confirmPayment: true))
          .then((value) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("paid successfully")));

        paymentIntentData = null;
      });
    } on StripeException catch (e) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                content: Text("Cancelled "),
              ));
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

calculateAmount(String amount) {
  final a = double.parse(amount) * 100;
  print(a);
  return a.round().toString();
}
