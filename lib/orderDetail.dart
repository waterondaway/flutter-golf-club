import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderDetail extends StatefulWidget {
  final String orderId;

  const OrderDetail({super.key, required this.orderId});

  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("Order Detail",
              style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot_auth) {
              final currentUser = FirebaseAuth.instance.currentUser;
              DocumentReference ordersDocument = FirebaseFirestore.instance
                  .collection('users')
                  .doc(currentUser!.uid)
                  .collection('orders')
                  .doc(widget.orderId);
              return StreamBuilder(
                  stream: ordersDocument.snapshots(),
                  builder: (context, snapshot) {
                    var order = snapshot.data!;
                    return ListView.builder(
                      padding: EdgeInsets.only(top: 10),
                      itemCount: order['productId_arr'].length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Container(
                              width: 100,
                              height: 150,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 3,
                                        spreadRadius: 1)
                                  ]),
                              child: StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection('product')
                                      .doc(order['productId_arr'][index])
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    var productDocument = snapshot.data!;
                                    return Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: Container(
                                            width: 120,
                                            height: 120,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    productDocument[
                                                        'image_path']),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Container(
                                          width: 220,
                                          height: 120,
                                          color: Colors.white,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Name : ${productDocument['productName']}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
                                              SizedBox(height: 8),
                                              Text("Price : € ${productDocument['sold']}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                              SizedBox(height: 8),
                                              Text("Gender: ${productDocument['gender']}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                              SizedBox(height: 8),
                                              Text("Brand: ${productDocument['productBrand']}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                            ],
                                          ),
                                        )
                                      ],
                                    );
                                  })),
                        );
                      },
                    );
                  });
            }));
  }
}
