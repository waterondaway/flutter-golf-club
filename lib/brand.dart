import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/productPage.dart';

class Brand extends StatefulWidget {
  final String brands;
  final List<String> filters;
  const Brand({super.key, required this.brands, required this.filters});

  @override
  _BrandState createState() => _BrandState();
}

class _BrandState extends State<Brand> {
  @override
  Widget build(BuildContext context) {
    String category = widget.filters.isNotEmpty ? widget.filters[0] : "";

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 244, 244),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('${widget.brands} : ${category}', style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('products') // Collection หลัก
                  .doc(widget.brands.toLowerCase()) // Document ที่ใช้แทน cobra
                  .collection(category) // Collection ภายใน document
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  print("Fetching data for brand: ${widget.brands}");
                  return const Center(child: Text('No products found'));
                }

                var products = snapshot.data!.docs;

                return Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // กำหนดจำนวนคอลัมน์ในกริด
                      crossAxisSpacing: 1.0, // ระยะห่างระหว่างคอลัมน์
                      mainAxisSpacing: 10.0, // ระยะห่างระหว่างแถว
                      childAspectRatio:
                          0.70, // ปรับขนาดความกว้าง-สูงของแต่ละ item
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      var product = products[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Productpage(
                                      productId: product.id, brands: widget.brands, category: category)));
                        },
                        child: Card(
                          color: Colors.white,
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(10.0),
                                ),
                                child: Image.network(
                                  product[
                                      'image_path'], // ปรับเป็นชื่อฟิลด์ที่ใช้เก็บ URL รูปภาพ
                                  fit: BoxFit.cover,
                                  height:
                                      150, // เพิ่มความสูงเพื่อให้รูปภาพแสดงเต็ม
                                  width: double.infinity, // ความกว้างของรูปภาพ
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  product['product_name'] ?? 'No Name',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
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
                                      color: Colors.black),
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, top: 3.0),
                                  child: Icon(
                                    Icons.star,
                                    size: 15,
                                    color: Color(0xFFFFC043),
                                  )),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            Text(widget.brands)
          ],
        ),
      ),
    );
  }
}