import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:http/http.dart' as http;

class StripePayment {
  static const String key =
      "pk_test_51J3kMGG5cd9OKvLgVETRfnACB1TK6FLWgthgE8vayoJzKH7LAxoXh4LTPUBSXQB6F7p2oMSQN9l9TChD7op8VH8f00AJSkC6fo";
  static const String hidden_key =
      "sk_test_51J3kMGG5cd9OKvLgxw6DSr1QvNORGZtX8TzHSni9hCDYrQiKMd1yRcRtTC9lqD6I301WsRVIsmGog43RR18LuL9h00tkimMNuV";
}

class ItemPayView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ItemPayView();
  }
}

class _ItemPayView extends State<ItemPayView> {
  Map<String, dynamic>? paymentIntentData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () async {
                await makePayment();
              },
              child: Text("Kk")),
        ],
      ),
    );
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
      print("WWw");
    }
  }

  Future<void> makePayment() async {
    try {
      paymentIntentData = await createPaymentIntent("20");
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntentData!["client_secret"],
              applePay: true,
              googlePay: true,
              style: ThemeMode.dark,
              merchantCountryCode: 'PL',
              merchantDisplayName: 'Food_Care'));
      displayPaymentSheet();
    } catch (e) {
      debugPrint(e.toString());
      print("OK");
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
  final a = (int.parse(amount)) * 100;
  return a.toString();
}
