import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:food_app/service/database.dart';
import 'package:food_app/service/shared_pref.dart';
import 'package:food_app/widgets/app_constant.dart';
import 'package:food_app/widgets/widget_support.dart';
import 'package:http/http.dart' as http;

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  String? wallet, id;
  int? add;
  TextEditingController amountcontoller = new TextEditingController();

  getthesharedprefs() async {
    wallet = await SharedPreferenceHelper().getUserWallet();
    id = await SharedPreferenceHelper().getUserId();
    setState(() {});
  }

  ontheload() async {
    await getthesharedprefs();
    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    super.initState();
  }

  Map<String, dynamic>? paymentIntent;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              elevation: 2,
              child: Container(
                padding: const EdgeInsets.only(bottom: 10),
                child: Center(
                    child: Text(
                  "Wallet",
                  style: AppWidget.HeaderTextFieldStyle(),
                )),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(color: Color(0xFFF2F2F2)),
              child: Row(
                children: [
                  Image.asset(
                    "images/wallet.png",
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    width: 40,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your Wallet",
                        style: AppWidget.LightTextFieldStyle(),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "\$" + "0",
                        style: AppWidget.boldText(),
                      )
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                "Add money",
                style: AppWidget.SemiboldTextFieldStyle(),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFF9E2E2)),
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    "\$" + "100",
                    style: AppWidget.SemiboldTextFieldStyle(),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    makePayment('500');
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFF9E2E2)),
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      "\$" + "500",
                      style: AppWidget.SemiboldTextFieldStyle(),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    makePayment('1000');
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFF9E2E2)),
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      "\$" + "1000",
                      style: AppWidget.SemiboldTextFieldStyle(),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    makePayment('2000');
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFF9E2E2)),
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      "\$" + "2000",
                      style: AppWidget.SemiboldTextFieldStyle(),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            GestureDetector(
              onTap: (){
                openEdit();
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.symmetric(vertical: 12),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: const Color(0xFF008080),
                    borderRadius: BorderRadius.circular(8)),
                child: const Center(
                  child: Text(
                    "Add Money",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> makePayment(String amount) async {
    try {
      paymentIntent = await createPaymentIntent(amount, 'INR');
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent!['client_secret'],
                  style: ThemeMode.dark,
                  merchantDisplayName: 'Adnan'))
          .then((value) {});

      displayPaymentSheet(amount);
    } catch (e, s) {
      print('exception: $e$s');
    }
  }

  displayPaymentSheet(String amount) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) async {
        add = int.parse(wallet!) + int.parse(amount);
        await SharedPreferenceHelper().saveUserWallet(add.toString());
        await DatabaseMethods().UpdateUserwallet(id!, add.toString());
        showDialog(
            context: context,
            builder: (_) => const AlertDialog(
                  content: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                          Text("Payment Successful")
                        ],
                      )
                    ],
                  ),
                ));
        await getthesharedprefs();

        paymentIntent = null;
      }).onError((error, stackTrace) {
        print('Error is:----> $error $stackTrace');
      });
    } on StripeException catch (e) {
      print('Error is:----> $e');
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: Text("Cancelled"),
              ));
    } catch (e) {
      print('$e');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card',
      };

      var response = await http.post(
        Uri.parse('http://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      print('Payment Intent Body->>> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final calculatedAmount = (int.parse(amount) * 100);

    return calculatedAmount.toString();
  }

  Future openEdit() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child:const Icon(Icons.cancel)),
                        const SizedBox(
                          width: 60,
                        ),
                        const Center(
                          child: Text(
                            "Add Money",
                            style: TextStyle(
                              color: Color(0xFF008080),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text("Amount"),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding:const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black38, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: amountcontoller,
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: 'Enter Amount'),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                        makePayment(amountcontoller.text);
                      },
                      child: Container(
                        width: 100,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Color(0xFF008080),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text(
                            'Pay',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ));
}
