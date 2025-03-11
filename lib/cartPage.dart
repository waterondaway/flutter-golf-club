import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/orderPage.dart';
// import 'package:flutter_application_1/checkoutPage.dart'; // อย่าลืมตรวจสอบ path ของ checkoutPage.dart

class CartPage extends StatefulWidget {
  CartPage({super.key});

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
                  Text(
                    "Your Carts",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Browse our products",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot_auth) {
                if (snapshot_auth.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot_auth.hasData) {
                  final currentUser = FirebaseAuth.instance.currentUser;
                  CollectionReference usersCollection = FirebaseFirestore
                      .instance
                      .collection('users')
                      .doc(currentUser!.uid)
                      .collection('carts');
                  CollectionReference productRef =
                      FirebaseFirestore.instance.collection('product');

                  return StreamBuilder(
                    stream: usersCollection.snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var userCartData = snapshot.data!.docs;
                        List<String> productIds = [];
                        Map<String, int> productQuantities = {};

                        // สร้าง Map เพื่อเก็บ productId และจำนวนที่ซื้อ
                        for (var doc in userCartData) {
                          String productId = doc['productId'];
                          int qty = doc['quantity'];
                          productQuantities[productId] = qty;
                          productIds.add(productId);
                        }

                        // ตรวจสอบว่า productIds ไม่ว่างเปล่าก่อน query Firestore
                        return StreamBuilder(
                          stream: productIds.isNotEmpty
                              ? productRef
                                  .where(FieldPath.documentId,
                                      whereIn: productIds)
                                  .snapshots()
                              : Stream.empty(),
                          builder: (context, snapshot_cart) {
                            if (snapshot_cart.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }

                            if (snapshot_cart.hasData) {
                              var cartsDocument = snapshot_cart.data!.docs;

                              // ถ้าไม่มีสินค้าในตะกร้า
                              if (cartsDocument.isEmpty) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'You have no items in your cart.',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      Text(
                                        "Browse our products and add them to your cart!",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 14),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              // คำนวณราคารวมของสินค้าทั้งหมด
                              double totalSum =
                                  cartsDocument.fold(0, (sum, doc) {
                                String productId = doc.id;
                                int quantity =
                                    productQuantities[productId] ?? 0;
                                double price = (doc['price'] as num).toDouble();
                                return sum + (price * quantity);
                              });

                              return Column(
                                children: [
                                  SizedBox(height: 10),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: cartsDocument.length,
                                      itemBuilder: (context, index) {
                                        var cartsDocumentIndex =
                                            cartsDocument[index];
                                        print(cartsDocumentIndex);
                                        String productId =
                                            cartsDocumentIndex.id;
                                        int quantity =
                                            productQuantities[productId] ?? 0;
                                        double price =
                                            (cartsDocumentIndex['price'] as num)
                                                .toDouble();

                                        return ListTile(
                                          leading: Image.network(
                                            cartsDocumentIndex["image_path"][0],
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.contain,
                                          ),
                                          title: Text(
                                            cartsDocumentIndex["productName"],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  "Price: £$price | Amount: $quantity"),
                                              SizedBox(height: 10),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    width: 120,
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.grey),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        "Total: £${(price * quantity).toStringAsFixed(2)}",
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        CollectionReference
                                                            userDelete =
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'users')
                                                                .doc(
                                                                    currentUser!
                                                                        .uid)
                                                                .collection(
                                                                    'carts');
                                                        userDelete
                                                            .doc(productId)
                                                            .delete();
                                                        setState(() {});
                                                      },
                                                      child: Icon(
                                                        Icons.delete,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          "Total: ฿${totalSum.toStringAsFixed(2)}",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            CollectionReference orderAdd =
                                                FirebaseFirestore.instance
                                                    .collection('users')
                                                    .doc(currentUser!.uid)
                                                    .collection('orders');

                                            CollectionReference cartRef =
                                                FirebaseFirestore.instance
                                                    .collection('users')
                                                    .doc(currentUser!.uid)
                                                    .collection('carts');

                                            CollectionReference productRef =
                                                FirebaseFirestore.instance
                                                    .collection('product');

                                            // ดึงข้อมูลจาก carts
                                            QuerySnapshot cartSnapshot =
                                                await cartRef.get();

                                            // ดึง productId_arr จาก doc.id ของ carts
                                            List<String> productIdArr =
                                                cartSnapshot.docs
                                                    .map((doc) => doc.id)
                                                    .toList();

                                            List<String> imagePaths = [];

                                            // ดึงข้อมูล image_path ของแต่ละ product ที่มีใน cart
                                            for (var productId
                                                in productIdArr) {
                                              DocumentSnapshot productDoc =
                                                  await productRef
                                                      .doc(productId)
                                                      .get();

                                              // ตรวจสอบว่ามีข้อมูล image_path และดึงเฉพาะ index 0
                                              if (productDoc.exists &&
                                                  productDoc.data() != null) {
                                                var productData =
                                                    productDoc.data()
                                                        as Map<String, dynamic>;
                                                var imagePath =
                                                    productData['image_path'];
                                                if (imagePath != null &&
                                                    imagePath.isNotEmpty) {
                                                  imagePaths.add(imagePath[
                                                      0]); // เพิ่ม image_path ที่ index 0
                                                }
                                              }
                                            }

                                            // เพิ่มข้อมูลไปที่ orders
                                            await orderAdd.add({   
                                              'order_date':DateTime.now().toString().substring(0, 10),                                           
                                              'productId_arr': productIdArr,
                                              'image_arr':
                                                  imagePaths, // เพิ่ม image_paths ไปใน order,
                                              'total':totalSum
                                            });
                                            Navigator.pop(context);
                                            // ลบข้อมูลจาก cart
                                            for (var doc in productIdArr) {
                                              await cartRef.doc(doc).delete();
                                              print(doc);
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.black,
                                            foregroundColor: Colors.white,
                                          ),
                                          child: Text("Check out"),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20)
                                ],
                              );
                            }

                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'You have no items in your cart.',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    "Browse our products and add them to your cart!",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }

                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "To view your order details, please log in.",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              "This ensures the best experience for you.",
                              style: TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 14),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "To view your order details, please log in.",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          "This ensures the best experience for you.",
                          style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 14),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
