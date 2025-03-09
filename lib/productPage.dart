import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/cartshopscreen.dart';
import 'package:readmore/readmore.dart';

class Productpage extends StatefulWidget {
  const Productpage({
    super.key,
    required this.productId,
  });

  final String productId;

  @override
  State<Productpage> createState() => _ProductpageState();
}

class _ProductpageState extends State<Productpage> {
  CollectionReference productRef =
      FirebaseFirestore.instance.collection('product');
  CollectionReference addProduct = FirebaseFirestore.instance
      .collection('users')
      .doc('mYu70LVUSACs3Ec0JeQa')
      .collection('carts');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ส่วนข้อมูลสินค้า
            StreamBuilder(
              stream: productRef.doc(widget.productId).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData) {
                  return const Center(child: Text('Product not found'));
                }

                var productData = snapshot.data;

                if (productData == null) {
                  return const Center(child: Text('No data available'));
                }
                SizedBox(
                  height: 30,
                );
                print(productData);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          child: Image.network(
                            productData['image_path'] ?? '',
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.image_not_supported,
                                  size: 100);
                            },
                          ),
                        ),
                        Positioned(
                          top: 27,
                          left: 5,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back,
                                color: Colors.black),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    // const Divider(
                    //   thickness: 5,
                    //   color: Colors.black,
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            'Price: £${productData['price'] ?? 'N/A'}',
                            style: const TextStyle(
                              fontSize: 30,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: Text(
                            'sold: 14 piece',
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        productData['productName'] ?? 'No Name',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                      color: Colors.black,
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Detail',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(right: 0),
                                child: Text('From, Thailand', style: TextStyle(fontSize: 15),),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          ReadMoreText(
                            productData['description'] ??
                                'No description available',
                            trimLines: 2,
                            style: TextStyle(fontSize: 15),
                            textAlign: TextAlign.justify,
                            trimMode: TrimMode.Line,
                            trimCollapsedText: '\nRead more',
                            trimExpandedText: '\nRead less',
                            moreStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            lessStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 60),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 180,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 111, 111, 111),
                              textStyle: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 3,
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Chat with Shop',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Icon(
                                    Icons.shopping_bag,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 180,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () async {
                              var cartRef = addProduct.doc(widget
                                  .productId); // ใช้ productId เป็น document ID
                              var cartSnapshot = await cartRef.get();

                              if (cartSnapshot.exists) {
                                // ถ้าข้อมูลสินค้าพบในตะกร้าแล้ว อัพเดทจำนวนเพิ่มขึ้น 1
                                int currentQty = cartSnapshot['qty'] ?? 0;
                                cartRef.update({
                                  'qty': currentQty + 1,
                                });
                              } else {
                                // ถ้าข้อมูลสินค้าไม่พบในตะกร้า เพิ่มสินค้าใหม่
                                cartRef.set({
                                  'productId': widget.productId,
                                  'status': true,
                                  'qty': 1,
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              textStyle: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 3,
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Add Cart',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Icon(
                                    Icons.shopping_bag,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            const Divider(thickness: 2, color: Colors.black,),
            SizedBox(height: 20,),
            Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text('Recommend Items !', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)),
            // ส่วนรายการสินค้าแนะนำ
            const SizedBox(height: 15),
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('product').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No products found'));
                }

                var products = snapshot.data!.docs;
                // สุ่มข้อมูล 10 รายการ
                products.shuffle(); // ทำการสุ่มรายการ
                var randomProducts = products.take(10).toList();
                return SizedBox(
                  height: 300,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      var product = randomProducts[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Productpage(
                                productId: product.id,
                                // brands: widget.brands,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          // height: 10,
                          width: 180,
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
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0),
                                  ),
                                  child: Image.network(
                                    product['image_path'],
                                    fit: BoxFit.cover,
                                    // height: 150,
                                    // width: double.infinity,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    product['productName'] ?? 'No Name',
                                    style: const TextStyle(
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
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, top: 3.0),
                                  child: const Icon(
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
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Builder(builder: (context) {
        return FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Cartshopscreen()),
              );
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100)),
            backgroundColor: Colors.black,
            child: Icon(Icons.shopping_bag, color: Colors.white));
      }),
    );
  }
}
