import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class Productpage extends StatefulWidget {
  const Productpage({
    super.key,
    required this.productId,
    required this.brands,
    required this.category,
  });

  final String productId;
  final String brands;
  final String category;

  @override
  State<Productpage> createState() => _ProductpageState();
}

class _ProductpageState extends State<Productpage> {
  @override
  Widget build(BuildContext context) {
    DocumentReference productRef = FirebaseFirestore.instance
        .collection('products')
        .doc(widget.brands.toLowerCase())
        .collection(widget.category)
        .doc(widget.productId);

    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<DocumentSnapshot>(
        stream: productRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            const Center(child: Text('Product not found'));
            return Column(
              children: [
                Text(widget.brands),
                Text(widget.category),
                Text(widget.productId)
              ],
            );
          }

          var productData = snapshot.data!.data() as Map<String, dynamic>?;

          if (productData == null) {
            return const Center(child: Text('No data available'));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    child: Image.network(
                      productData['image_path'] ?? '',
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.image_not_supported, size: 100);
                      },
                    ),
                  ),
                  Positioned(
                    top: 27,
                    left: 5,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      'Price: ${productData['price'] ?? 'N/A'}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: Text(
                      'sold: 14 piece',
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  productData['product_name'] ?? 'No Name',
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              Divider(thickness: 2),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Detail',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 0),
                          child: Text('Form, Thailand'),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ReadMoreText(
                      productData['description'],
                      trimLines: 2,
                      textAlign: TextAlign.justify,
                      trimMode: TrimMode.Line,
                      trimCollapsedText:
                          '\nRead more', // ย้าย Read more ไปบรรทัดล่าง
                      trimExpandedText:
                          '\nRead less', // ย้าย Read less ไปบรรทัดล่าง
                      moreStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15, // ขนาดตัวอักษรใหญ่ขึ้น
                      ),
                      lessStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15, // ขนาดตัวอักษรใหญ่ขึ้น
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [                
                Container(
                  width: 180,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 111, 111, 111),
                          textStyle: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 3),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Chat with Shop',
                                style: TextStyle(color: Colors.white)),
                            Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Icon(
                                  Icons.shopping_bag,
                                  size: 20,
                                  color: Colors.white,
                                ))
                          ])),
                ),
                Container(
                  width: 180,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          textStyle: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 3),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Add Cart',
                                style: TextStyle(color: Colors.white)),
                            Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Icon(
                                  Icons.shopping_bag,
                                  size: 20,
                                  color: Colors.white,
                                ))
                          ])),
                ),
              ]),
            ],
          );
        },
      ),
    );
  }
}