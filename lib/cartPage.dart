import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Row(
					children: [
						Container(
							padding: EdgeInsets.only(left: 20),
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									Text("Your Carts", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
									Text("Browse our products", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600))
								],
							),
						)
					],
				),
        ),
        body: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot_auth) {
              if (snapshot_auth.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Stack(children: [
                    CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.transparent)),
                    Image.asset('assets/images/golf.png', width: 80, height: 80)
                  ]),
                );
              }
              if (snapshot_auth.hasData) {
                final currentUser = FirebaseAuth.instance.currentUser;
                CollectionReference cartsCollection = FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser!.uid)
                    .collection('carts');
                return StreamBuilder(
                    stream: cartsCollection.snapshots(),
                    builder: (context, snapshot_cart) {
                      if (snapshot_cart.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: Stack(children: [
                            CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.transparent)),
                            Image.asset('assets/images/golf.png',
                                width: 80, height: 80)
                          ]),
                        );
                      }
                      if (snapshot_cart.hasData) {
                        var cartsDocument =  snapshot_cart.data!.docs;
                        return Column(
                          children: [
                            // ListView.builder(
                            //   itemCount: cartsDocument.length,
                            //   itemBuilder: (context, index) {
                            //     return ListTile(
                            //       leading: Image.network('https://static.golfonline.uk/media/img/tc665_zoom_d.300x300@2.jpg.webp'),
                            //       title: Text('name'),
                            //       subtitle: Column(
                            //         children: [
                                      
                            //         ],
                            //       ),
                            //     );
                            //   },
                            // )
                          ],
                        );
                      } else {
                        return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                          
                          Text('You have no items in your cart.',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                                  Text("Browse our products and add them to your cart!",
                              style: TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 14)),
                        ]));
                      }
                    });
              } else {
                return Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("To view your order details, please log in.",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        Text("This ensures the best experience for you.",
                            style: TextStyle(
                                fontWeight: FontWeight.w300, fontSize: 14)),
                      ],
                    ),
                  ),
                );
              }
            }));
  }
}
