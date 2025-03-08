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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ส่วนข้อมูลสินค้า
            StreamBuilder<DocumentSnapshot>(
              stream: productRef.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(child: Text('Product not found'));
                }

                var productData = snapshot.data!.data() as Map<String, dynamic>?;

                if (productData == null) {
                  return const Center(child: Text('No data available'));
                }
                SizedBox(height: 30,);
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
                    const SizedBox(height: 15),
                    const Divider(thickness: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            'Price: ${productData['price'] ?? 'N/A'}',
                            style: const TextStyle(
                              fontSize: 18,
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
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Divider(thickness: 5),
                    const SizedBox(height: 10),
                    SizedBox(height: 10,),
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
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(right: 0),
                                child: Text('From, Thailand'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          ReadMoreText(
                            productData['description'] ?? 'No description available',
                            trimLines: 2,
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
                    const SizedBox(height: 15),
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
                            onPressed: () {},
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
            const SizedBox(height: 30),
            const Divider(thickness: 5),
            Padding(padding: EdgeInsets.only(left: 8.0), child: Text('Recommend Items !')),
            // ส่วนรายการสินค้าแนะนำ
            const SizedBox(height: 15),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('products')
                  .doc(widget.brands.toLowerCase())
                  .collection(widget.category)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No products found'));
                }

                var products = snapshot.data!.docs;

                return SizedBox(
                  height: 300,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      var product = products[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Productpage(
                                productId: product.id,
                                brands: widget.brands,
                                category: widget.category,
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
                                    product['product_name'] ?? 'No Name',
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
                                  padding: const EdgeInsets.only(left: 8.0, top: 3.0),
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
    );
  }
}