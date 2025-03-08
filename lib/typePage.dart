import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/productPage.dart';

class Typepage extends StatefulWidget {
  const Typepage({super.key, required this.type, required this.filter});
  final String type;
  final String filter;

  @override
  State<Typepage> createState() => _TypepageState();
}

class _TypepageState extends State<Typepage> {
  // เราจะดึงข้อมูลจาก Firestore โดยใช้ค่า `type` และ `filter`
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.type), // แสดงประเภทที่เลือก
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('products') // Collection หลัก
            .snapshots(), // ดึงข้อมูลจากทุก category (document) ภายใต้ collection `products`
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No categories found'));
          }

          // Get the list of categories from Firestore data
          var categories = snapshot.data!.docs;

          // ดึงข้อมูลของผลิตภัณฑ์ตามประเภทที่เลือก
          return GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // จำนวนคอลัมน์
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              var category = categories[index].id; // Get category name

              print(category);
              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('products') // Collection หลัก
                    .doc(category) // Document ของ category
                    .collection(widget.filter) // ใช้ filter สำหรับ sub-collection
                    .where('type', isEqualTo: widget.type.toLowerCase()) // กรองข้อมูลตามประเภท
                    .snapshots(), // ดึงข้อมูลแบบ real-time
                builder: (context, mensSnapshot) {
                  if (mensSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  var ironProducts = mensSnapshot.data!.docs;

                  // สร้างการ์ดสินค้าภายใน grid
                  return GridView.builder(
                    itemCount: ironProducts.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 1.0,
                      mainAxisSpacing: 10.0,
                      childAspectRatio: 0.70,
                    ),
                    itemBuilder: (context, index) {
                      var product = ironProducts[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Productpage(
                                productId: product.id,
                                brands: category,
                                category: category,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          color: Colors.white,
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: SingleChildScrollView( // ทำให้สามารถเลื่อนเนื้อหาได้
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0),
                                  ),
                                  child: Image.network(
                                    product['image_path'],
                                    fit: BoxFit.cover,
                                    height: 150,
                                    width: double.infinity,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    product['product_name'] ?? 'No Name',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    '${product['price']}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0, top: 3.0),
                                  child: Icon(
                                    Icons.star,
                                    size: 15,
                                    color: Color(0xFFFFC043),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
