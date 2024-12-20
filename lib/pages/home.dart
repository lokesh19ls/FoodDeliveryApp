// import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_app/pages/details.dart';
import 'package:food_app/service/database.dart';
import 'package:food_app/widgets/widget_support.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool icecream = false, pizza = false, salad = false, burger = false;

  Stream? fooditemStream;

  ontheload() async {
    fooditemStream = await DatabaseMethods().getFoodItem("Pizza");
    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    super.initState();
  }

  Widget allItemsVertically() {
    return StreamBuilder(
        stream: fooditemStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: snapshot.data.docs.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Details()));
                      },
                      child: Container(
              margin: const EdgeInsets.only(right: 20),
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        ds["Image"],
                        
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            child: Text(
                              ds["Name"],
                              style: AppWidget.SemiboldTextFieldStyle(),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            child: Text(
                              "Honey goot cheese",
                              style: AppWidget.LightTextFieldStyle(),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            child: Text(
                              "\$"+ds["Price"],
                              style: AppWidget.SemiboldTextFieldStyle(),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
                    );
                  })
              : CircularProgressIndicator();
        });
  }

  Widget allItems() {
    return StreamBuilder(
        stream: fooditemStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: snapshot.data.docs.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Details()));
                      },
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        child: Material(
                          elevation: 5,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    ds["Image"],
                                    height: 150,
                                    width: 150,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Text(
                                  ds["Name"],
                                  style: AppWidget.SemiboldTextFieldStyle(),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Fresh and Healthy",
                                  style: AppWidget.LightTextFieldStyle(),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "\$"+ds["Price"],
                                  style: AppWidget.SemiboldTextFieldStyle(),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  })
              : CircularProgressIndicator();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 60, left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Hello Lokesh,",
                  style: AppWidget.boldText(),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 20),
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8)),
                  child: const Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Delicious Food",
              style: AppWidget.HeaderTextFieldStyle(),
            ),
            Text(
              "Discover and Get Great food",
              style: AppWidget.LightTextFieldStyle(),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
                margin: const EdgeInsets.only(right: 20), child: showItem()),
            const SizedBox(
              height: 30,
            ),
            Container(
              height: 270,
              child: allItems()),
            // SingleChildScrollView(
            //   scrollDirection: Axis.horizontal,
            //   child: Row(
            //     children: [
            //       GestureDetector(
            //         onTap: () {
            //           Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                   builder: (context) => const Details()));
            //         },
            //         child: Container(
            //           margin: const EdgeInsets.all(5),
            //           child: Material(
            //             elevation: 5,
            //             borderRadius: BorderRadius.circular(20),
            //             child: Container(
            //               padding: const EdgeInsets.all(14),
            //               child: Column(
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: [
            //                   Image.asset(
            //                     "images/salad2.png",
            //                     height: 150,
            //                     width: 150,
            //                     fit: BoxFit.cover,
            //                   ),
            //                   Text(
            //                     "Veggie Taco Hash",
            //                     style: AppWidget.SemiboldTextFieldStyle(),
            //                   ),
            //                   const SizedBox(
            //                     height: 5,
            //                   ),
            //                   Text(
            //                     "Fresh and Healthy",
            //                     style: AppWidget.LightTextFieldStyle(),
            //                   ),
            //                   const SizedBox(
            //                     height: 5,
            //                   ),
            //                   Text(
            //                     "\$25",
            //                     style: AppWidget.SemiboldTextFieldStyle(),
            //                   )
            //                 ],
            //               ),
            //             ),
            //           ),
            //         ),
            //       ),
            //       const SizedBox(
            //         width: 15,
            //       ),
            //       Container(
            //         margin: const EdgeInsets.all(4),
            //         child: Material(
            //           elevation: 5,
            //           borderRadius: BorderRadius.circular(20),
            //           child: Container(
            //             padding: const EdgeInsets.all(14),
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 Image.asset(
            //                   "images/salad4.png",
            //                   height: 150,
            //                   width: 150,
            //                   fit: BoxFit.cover,
            //                 ),
            //                 Text(
            //                   "Min Veg Salad",
            //                   style: AppWidget.SemiboldTextFieldStyle(),
            //                 ),
            //                 const SizedBox(
            //                   height: 5,
            //                 ),
            //                 Text(
            //                   "Spicy with Onion",
            //                   style: AppWidget.LightTextFieldStyle(),
            //                 ),
            //                 const SizedBox(
            //                   height: 5,
            //                 ),
            //                 Text(
            //                   "\$28",
            //                   style: AppWidget.SemiboldTextFieldStyle(),
            //                 )
            //               ],
            //             ),
            //           ),
            //         ),
            //       )
            //     ],
            //   ),
            // ),
            const SizedBox(
              height: 30,
            ),
            Container(
              margin: const EdgeInsets.only(right: 20),
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "images/salad2.png",
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            child: Text(
                              "Veggie Taco Hash",
                              style: AppWidget.SemiboldTextFieldStyle(),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            child: Text(
                              "Honey goot cheese",
                              style: AppWidget.LightTextFieldStyle(),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            child: Text(
                              "\$28",
                              style: AppWidget.SemiboldTextFieldStyle(),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.only(right: 20),
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "images/salad4.png",
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            child: Text(
                              "Mediterranean Chickpea Salad",
                              style: AppWidget.SemiboldTextFieldStyle(),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            child: Text(
                              "Honey goot cheese",
                              style: AppWidget.LightTextFieldStyle(),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            child: Text(
                              "\$28",
                              style: AppWidget.SemiboldTextFieldStyle(),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget showItem() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            icecream = true;
            pizza = false;
            salad = false;
            burger = false;
            setState(() {});
          },
          child: Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                  color: icecream ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.all(8),
              child: Image.asset(
                "images/ice-cream.png",
                height: 50,
                width: 50,
                fit: BoxFit.cover,
                color: icecream ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            icecream = false;
            pizza = true;
            salad = false;
            burger = false;
            setState(() {});
          },
          child: Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                  color: pizza ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.all(8),
              child: Image.asset(
                "images/pizza.png",
                height: 50,
                width: 50,
                fit: BoxFit.cover,
                color: pizza ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            icecream = false;
            pizza = false;
            salad = false;
            burger = true;
            setState(() {});
          },
          child: Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                  color: burger ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.all(8),
              child: Image.asset(
                "images/burger.png",
                height: 50,
                width: 50,
                fit: BoxFit.cover,
                color: burger ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            icecream = false;
            pizza = false;
            salad = true;
            burger = false;
            setState(() {});
          },
          child: Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                  color: salad ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.all(8),
              child: Image.asset(
                "images/salad.png",
                height: 50,
                width: 50,
                fit: BoxFit.cover,
                color: salad ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
