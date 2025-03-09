import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/checkoutscreen.dart';


class Cartshopscreen extends StatefulWidget {
  const Cartshopscreen({super.key});

  @override
  State<Cartshopscreen> createState() => _CartshopscreenState();
}

class _CartshopscreenState extends State<Cartshopscreen> {
  // ตัวอย่างข้อมูลสินค้าในตะกร้า
  // List<Map<String, dynamic>> cartItems = [
  //   {
  //     "name": "ไม้กอล์ฟยกชุด",
  //     "price": 100.0,
  //     "quantity": 1,
  //     "image": 'assets/images/download (1).jpg'
  //   },
  //   {
  //     "name": "ไม้กอล์ฟยกชุด",
  //     "price": 200.0,
  //     "quantity": 2,
  //     "image": 'assets/images/download (1).jpg'
  //   },
  // ];

  // void _increaseQuantity(int index) {
  //   setState(() {
  //     cartItems[index]["quantity"]++;
  //   });
  // }

  // void _decreaseQuantity(int index) {
  //   setState(() {
  //     if (cartItems[index]["quantity"] > 1) {
  //       cartItems[index]["quantity"]--;
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    CollectionReference userRef = FirebaseFirestore.instance.collection('users').doc('mYu70LVUSACs3Ec0JeQa').collection('carts');
    CollectionReference productRef = FirebaseFirestore.instance.collection('product');
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          "Shopping cart",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2),
          child: Container(
            color: Colors.grey,
            height: 1,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: userRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return Center(child: Text('No data found.'));
          }

          var userCartData = snapshot.data!.docs;
          List<String> productIds = [];
          Map<String, int> productQuantities = {}; // สร้าง map สำหรับเก็บ productId และ qty

          // สร้าง map สำหรับจับคู่ productId กับ quantity
          for (var doc in userCartData) {
            String productId = doc['productId'];
            int qty = doc['qty'];  // assuming 'qty' is stored in Firestore
            productQuantities[productId] = qty;
            productIds.add(productId);
          }

          return StreamBuilder(
            stream: productRef.where(FieldPath.documentId, whereIn: productIds).snapshots(),
            builder: (context, productSnapshot) {
              if (productSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!productSnapshot.hasData) {
                return Center(child: Text('No products found.'));
              }
              var productData = productSnapshot.data!.docs;

              return ListView.builder(
                itemCount: productData.length,
                itemBuilder: (context, index) {
                  var product = productData[index];
                  String productId = product.id;
                  int quantity = productQuantities[productId] ?? 0; // Get quantity from map

                  return ListTile(
                    title: Text(product['productName']),
                    subtitle: Text('Price: ${product['price']} x $quantity'),
                    leading: Image.network(product['image_path']),
                    trailing: IconButton(
                      icon: Icon(Icons.add_shopping_cart),
                      onPressed: () {
                        // Handle add to cart action
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),

      // body: Column(
      //   children: [
      //     Expanded(
      //       child: ListView.builder(
      //         itemCount: cartItems.length,
      //         itemBuilder: (context, index) {
      //           return buildCartItem(cartItems[index], index);
      //         },
      //       ),
      //     ),
      //     Container(
      //       padding: EdgeInsets.all(20),
      //       decoration: BoxDecoration(
      //         border: Border(
      //           top: BorderSide(
      //             color: Colors.grey, // สีของเส้นขอบ
      //             width: 1.0, // ความหนาของเส้นขอบ
      //           ),
      //         ),
      //       ),
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         children: [
      //           Text(
      //             "Total: ฿00.00 ",
      //             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      //           ),
      //           ElevatedButton(
      //               onPressed: () {
      //                 Navigator.push(
      //                   context,
      //                   MaterialPageRoute(
      //                       builder: (context) => Checkoutscreen()),
      //                 );
      //               },
      //               style: ElevatedButton.styleFrom(
      //                 backgroundColor: Colors.black, // สีพื้นหลังของปุ่ม
      //                 foregroundColor: Colors.white, // สีข้อความของปุ่ม
      //               ),
      //               child: Text(
      //                 "Check out",
      //                 style: TextStyle(),
      //               ))
      //         ],
      //       ),
      //     )
      //   ],
      // ),
    );
  }

  // ฟังก์ชันนี้จะสร้าง widget สำหรับแสดงข้อมูลในแต่ละรายการ
  // Widget buildCartItem(Map<String, dynamic> item, int index) {
  //   return ListTile(
  //     leading: Image.asset(item["image"],
  //         width: 100, height: 200, fit: BoxFit.cover),
  //     title: Text(
  //       item["name"],
  //       style: TextStyle(fontWeight: FontWeight.bold),
  //     ),
  //     subtitle: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text("ราคา: ${item["price"]} บาท | จำนวน: ${item["quantity"]}"),
  //         SizedBox(height: 20),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.end,
  //           children: [
  //             Container(
  //                 width: 130, // กำหนดความกว้างของกล่อง
  //                 height: 30,
  //                 decoration: BoxDecoration(
  //                   border: Border.all(color: Colors.grey), // ขอบของกล่อง
  //                   borderRadius: BorderRadius.circular(8), // มุมกลม
  //                 ),
  //                 child: Row(
  //                   children: [
  //                     IconButton(
  //                       onPressed: () => _decreaseQuantity(index),
  //                       icon: Icon(Icons.remove, color: Colors.black, size: 15),
  //                     ),
  //                     Container(
  //                       height: 24, // ความสูงของเส้นขั้น
  //                       width: 1, // ความหนาของเส้นขั้น
  //                       color: Colors.grey, // สีของเส้นขั้น
  //                     ),
  //                     SizedBox(width: 10),
  //                     Text(
  //                       "${item["quantity"]}",
  //                       style: TextStyle(fontSize: 15),
  //                     ),
  //                     SizedBox(width: 10),
  //                     Container(
  //                       height: 24, // ความสูงของเส้นขั้น
  //                       width: 1, // ความหนาของเส้นขั้น
  //                       color: Colors.grey, // สีของเส้นขั้น
  //                     ),
  //                     IconButton(
  //                       onPressed: () => _increaseQuantity(index),
  //                       icon: Icon(Icons.add, color: Colors.black, size: 15),
  //                     )
  //                   ],
  //                 ))
  //           ],
  //         )
  //       ],
  //     ),
  //   );
  // }
}
