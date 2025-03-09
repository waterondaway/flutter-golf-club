import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/productPage.dart';

class Brand extends StatefulWidget {
  final String brands;
  const Brand({super.key, required this.brands});

  @override
  _BrandState createState() => _BrandState();
}

class _BrandState extends State<Brand> {
  String filter = 'all';
  CollectionReference brandRef =
      FirebaseFirestore.instance.collection('product');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 244, 244),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          '${widget.brands} ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5,),
            Row(
              children: [
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        filter = 'all';
                        print(filter);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10))),
                        backgroundColor:
                            filter == 'all' ? Colors.black : Colors.white),
                    child: Text(
                      'All',
                      style: TextStyle(
                          color: filter == 'all' ? Colors.white : Colors.black),
                    )),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        filter = 'mens';
                        print(filter);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(0),
                                bottomLeft: Radius.circular(0))),
                        backgroundColor:
                            filter == 'mens' ? Colors.black : Colors.white),
                    child: Text(
                      'Mens',
                      style: TextStyle(
                          color:
                              filter == 'mens' ? Colors.white : Colors.black),
                    )),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        filter = 'ladies';
                        print(filter);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(0),
                                bottomLeft: Radius.circular(0))),
                        backgroundColor:
                            filter == 'ladies' ? Colors.black : Colors.white),
                    child: Text(
                      'Ladies',
                      style: TextStyle(
                          color:
                              filter == 'ladies' ? Colors.white : Colors.black),
                    )),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        filter = 'junior';
                        print(filter);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10))
                      ),  
                        backgroundColor:
                            filter == 'junior' ? Colors.black : Colors.white),
                    child: Text(
                      'junior',
                      style: TextStyle(
                          color: filter == 'junior'
                              ? Colors.white
                              : Colors.black),
                    )),
              ],
            ),
            SizedBox(height: 10,),
            StreamBuilder(
              stream: filter != 'all'
                  ? brandRef
                      .where('productBrand',
                          isEqualTo: widget.brands.toLowerCase())
                      .where('gender', isEqualTo: filter)
                      .snapshots()
                  : brandRef
                      .where('productBrand',
                          isEqualTo: widget.brands.toLowerCase())
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
                          0.63, // ปรับขนาดความกว้าง-สูงของแต่ละ item
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      var product = products[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Productpage(productId: product.id)));
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
                                  product['productName'] ?? 'No Name',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  '£${product['price']}',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          margin:
                                              const EdgeInsets.only(left: 8.0),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.star,
                                                size: 17,
                                                color: Color(0xFFFFC043),
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                product['star']?.toString() ?? '0',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      color: Colors.white,
                                      child: Padding(
                                        padding: EdgeInsets.only(right: 8),
                                        child: Text('ขายแล้ว x ชิ้น', style: TextStyle(fontSize: 13.5),),
                                      ),
                                    )
                                  ])
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
