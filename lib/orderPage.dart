import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/authPage.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(), 
      builder: (context, snapshot){
        if (snapshot.hasData) {
          final currentUser = FirebaseAuth.instance.currentUser;
          CollectionReference ordersCollection = FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).collection('orders');
          return StreamBuilder(
            stream: ordersCollection.snapshots(), 
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var ordersDocument =  snapshot.data!.docs;
                return ListView.builder(
                  padding: EdgeInsets.only(top: 10),
                  itemCount: ordersDocument.length,
                  itemBuilder: (context, index) {
                    var eachOrderDocument = ordersDocument[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Container(
                        padding: EdgeInsets.only(left: 20),
                        height: 180,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 3, spreadRadius: 1)
                          ]
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [ 
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: 20),
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(image: NetworkImage(eachOrderDocument['image_arr'][0]))
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 15),
                                  width: 200,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    // color: Colors.orange
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('OrderID : ${eachOrderDocument.id}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
                                      Text('Order Date : ${eachOrderDocument['order_date']}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
                                      Text('Total : ${eachOrderDocument['total']}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
                                      SizedBox(height: 10),
                                      GestureDetector(
                                          child: Container(
                                            width: 120,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Colors.black
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.save, color: Colors.white),
                                                SizedBox(width: 10),
                                                Text("Received", style: TextStyle(color: Colors.white))
                                              ]
                                            ),
                                          ),
                                          onTap: () {
                                            ordersCollection.doc(eachOrderDocument.id).delete();
                                          },
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ]
                        )
                      ),
                    );
                  },
                );
              } else {
                return Center(
                  child: Text('You do not have any order!')
                );
              }
            }
          );
        } else {
          return Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("To view your order details, please log in.", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text("This ensures the best experience for you.", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14)),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AuthPage()));
                    }, 
                    child: Container(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.login, color: Colors.white),
                          SizedBox(width: 20),
                          Text('Login', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))
                        ],
                      ),
                    )
                  )
                ],
              ),
            ),
          );
        }
      },
    );
  }
}