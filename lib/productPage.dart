import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:readmore/readmore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductPage extends StatefulWidget {
  final String productId;
  final String productName;
  const ProductPage(
      {super.key, required this.productId, required this.productName});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  // Function to show modal for user add product.
  void showAddDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            content: Container(
              width: 200,
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network('https://uxwing.com/wp-content/themes/uxwing/download/checkmark-cross/done-icon.png', width: 60, height: 60),
                  SizedBox(height: 10),
                  Text('The process is complete', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('Items through the cart.', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))
                ],
              ),
            ),
          );
        });
  }

  CollectionReference productsCollection =
      FirebaseFirestore.instance.collection('product');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${widget.productName}',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    Text('Find the Perfect Driver for Your Game',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600))
                  ],
                ),
              )
            ],
          )),
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot_auth) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  StreamBuilder(
                      stream:
                          productsCollection.doc(widget.productId).snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasData && snapshot.data != null) {
                          var productsDocument = snapshot.data;
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 10),
                            child: Column(
                              children: [
                                ImageSlideshow(children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10)),
                                    child: Image.network(
                                        productsDocument!['image_path'][0],
                                        fit: BoxFit.contain),
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10)),
                                    child: Image.network(
                                        productsDocument['image_path'][1],
                                        fit: BoxFit.contain),
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10)),
                                    child: Image.network(
                                        productsDocument['image_path'][2],
                                        fit: BoxFit.contain),
                                  )
                                ]),
                                SizedBox(height: 15),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 5),
                                  child: Text(productsDocument['productName'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text(
                                          'Brands: ${productsDocument['productBrand']}',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey)),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 10),
                                      child: Text(
                                          'Sold: ${productsDocument['sold']} pieces',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey)),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Description",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                                color: Colors.black)),
                                        SizedBox(height: 2),
                                        ReadMoreText(
                                          productsDocument['description'],
                                          trimLines: 2,
                                          style: TextStyle(fontSize: 15),
                                          textAlign: TextAlign.justify,
                                          trimMode: TrimMode.Line,
                                          trimCollapsedText: ' Read more',
                                          trimExpandedText: ' Read less',
                                          moreStyle: const TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                          lessStyle: const TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        )
                                      ],
                                    )),
                                SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                        width: 180,
                                        height: 50,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.grey,
                                          ),
                                          onPressed: () {
                                            // wait
                                          },
                                          child: Row(
                                            children: [
                                              Text('Chat with Shop',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(width: 8),
                                              Icon(Icons.shopping_bag,
                                                  size: 15, color: Colors.white)
                                            ],
                                          ),
                                        )),
                                    Container(
                                        width: 155,
                                        height: 50,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                snapshot_auth.hasData
                                                    ? Colors.black
                                                    : Colors.grey,
                                          ),
                                          onPressed: () async {
                                            if (snapshot_auth.hasData) {
                                              final user = FirebaseAuth
                                                  .instance.currentUser;
                                              await FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(user!.uid)
                                                  .collection('carts')
                                                  .add({
                                                'productId': productsDocument[
                                                    'productId'],
                                                'quantity': 1,
                                              });
                                              showAddDialog(context);
                                            } else {
                                              return;
                                            }
                                          },
                                          child: Row(
                                            children: [
                                              Text('Add to Cart',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(width: 8),
                                              Icon(Icons.shopping_bag,
                                                  size: 15, color: Colors.white)
                                            ],
                                          ),
                                        )),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Divider(thickness: 1),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    SizedBox(width: 8),
                                    Text('Recommend Items',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18))
                                  ],
                                ),
                                SizedBox(height: 10),
                                StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection('product')
                                        .where('productId',
                                            isNotEqualTo: productsDocument.id)
                                        .where('gender',
                                            isEqualTo:
                                                productsDocument['gender'])
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      }
                                      if (snapshot.hasData) {
                                        var productsDocument =
                                            snapshot.data!.docs;
                                        return SizedBox(
                                            height: 320,
                                            child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount:
                                                    productsDocument.length,
                                                itemBuilder: (context, index) {
                                                  var eachProductsDocuments =
                                                      productsDocument[index];
                                                  return GestureDetector(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => ProductPage(
                                                                  productId:
                                                                      eachProductsDocuments
                                                                          .id,
                                                                  productName:
                                                                      eachProductsDocuments[
                                                                          'productName'])));
                                                    },
                                                    child: Card(
                                                        color: Colors.white,
                                                        elevation: 2,
                                                        child: Container(
                                                          width: 180,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius: BorderRadius.only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            10),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            10)),
                                                                child: Image.network(
                                                                    eachProductsDocuments[
                                                                        'image_path'],
                                                                    fit: BoxFit
                                                                        .contain),
                                                              ),
                                                              SizedBox(
                                                                  height: 10),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(8),
                                                                child: Text(
                                                                    eachProductsDocuments[
                                                                        'productName'],
                                                                    maxLines: 2,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                              ),
                                                              Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              8,
                                                                          right:
                                                                              8),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                          '£${eachProductsDocuments['price'].toString()}',
                                                                          maxLines:
                                                                              2,
                                                                          overflow: TextOverflow
                                                                              .ellipsis,
                                                                          style:
                                                                              TextStyle(fontWeight: FontWeight.bold)),
                                                                      Text(
                                                                          'More Info',
                                                                          maxLines:
                                                                              2,
                                                                          overflow: TextOverflow
                                                                              .ellipsis,
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.grey)),
                                                                    ],
                                                                  )),
                                                              SizedBox(
                                                                  height: 5),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Padding(
                                                                      padding: EdgeInsets.only(
                                                                          left:
                                                                              8,
                                                                          right:
                                                                              8),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        children: [
                                                                          Icon(
                                                                              Icons.star,
                                                                              size: 17,
                                                                              color: Colors.orange),
                                                                          Icon(
                                                                              Icons.star,
                                                                              size: 17,
                                                                              color: Colors.orange),
                                                                          Icon(
                                                                              Icons.star,
                                                                              size: 17,
                                                                              color: Colors.orange),
                                                                          SizedBox(
                                                                              width: 10),
                                                                          Text(
                                                                              '3.5',
                                                                              style: TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.bold)),
                                                                        ],
                                                                      )),
                                                                  Padding(
                                                                      padding: EdgeInsets.only(
                                                                          right:
                                                                              8),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                              '13 sold',
                                                                              style: TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.bold))
                                                                        ],
                                                                      )),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        )),
                                                  );
                                                }));
                                      } else {
                                        return Row(
                                          children: [
                                            SizedBox(width: 8),
                                            Text(
                                                'Do not have any recommend items.')
                                          ],
                                        );
                                      }
                                    })
                              ],
                            ),
                          );
                        } else {
                          return Center(child: Text('Something went Wrong!'));
                        }
                      })
                ],
              ),
            );
          }),
    );
  }
}
