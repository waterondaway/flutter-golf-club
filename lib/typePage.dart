import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/productPage.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

class TypePage extends StatefulWidget {
  final String type;
  const TypePage({super.key, required this.type});

  @override
  State<TypePage> createState() => _TypePageState();
}

class _TypePageState extends State<TypePage> {
  CollectionReference productsCollection = FirebaseFirestore.instance.collection('product');
  String filter = 'All';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									Text('Categories: ${widget.type}', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
									Text('Find the Perfect Driver for Your Game', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600))
								],
						),
          ],
        )
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: filter == 'All' ? Colors.black : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10))
                    )
                  ),
                  onPressed: () {
                    setState(() {
                      filter = 'All';
                    });
                  }, 
                  child: Text('All', style: TextStyle(color: filter == 'All' ? Colors.white : Colors.black))
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: filter == 'Mens' ? Colors.black : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(0), bottomLeft: Radius.circular(0))
                    )
                  ),
                  onPressed: () {
                    setState(() {
                      filter = 'Mens';
                    });
                  }, 
                  child: Text('Mens', style: TextStyle(color: filter == 'Mens' ? Colors.white : Colors.black))
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: filter == 'Ladies' ? Colors.black : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(0), bottomLeft: Radius.circular(0))
                    )
                  ),
                  onPressed: () {
                    setState(() {
                      filter = 'Ladies';
                    });
                  }, 
                  child: Text('Ladies', style: TextStyle(color: filter == 'Ladies' ? Colors.white : Colors.black))
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: filter == 'Juniors' ? Colors.black : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10))
                    )
                  ),
                  onPressed: () {
                    setState(() {
                      filter = 'Juniors';
                    });
                  }, 
                  child: Text('Juniors', style: TextStyle(color: filter == 'Juniors' ? Colors.white : Colors.black))
                ),
              ]
            ),
            SizedBox(height: 15),
            StreamBuilder(
              stream: filter == 'All' ? productsCollection.where('type', isEqualTo: widget.type).snapshots() : productsCollection.where('type', isEqualTo: widget.type.toLowerCase()).where('gender', isEqualTo: filter.toLowerCase()).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty){
                  var productsDocument = snapshot.data!.docs;
                  return Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 3, mainAxisSpacing: 10, childAspectRatio: 0.58), 
                      itemCount: productsDocument.length,
                      itemBuilder: (context, index) {
                        var eachProductsDocuments = productsDocument[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ProductPage(productId: eachProductsDocuments.id, productName: eachProductsDocuments['productName'])));
                          },
                          child: Card(
                            color: Colors.white,
                            elevation: 2.0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ImageSlideshow(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                      child: Image.network(eachProductsDocuments['image_path'][0], fit: BoxFit.contain),
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                      child: Image.network(eachProductsDocuments['image_path'][1], fit: BoxFit.contain),
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                      child: Image.network(eachProductsDocuments['image_path'][2], fit: BoxFit.contain),
                                    ),
                                  ]
                                ),
                                SizedBox(height: 10),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(eachProductsDocuments['productName'], maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8, right: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('£${eachProductsDocuments['price'].toString()}', maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold)),
                                      Text('More Info', maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                                    ],
                                  )
                                ),
                                SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 8, right: 8),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Icon(Icons.star, size: 17, color: Colors.orange),
                                          Icon(Icons.star, size: 17, color: Colors.orange),
                                          Icon(Icons.star, size: 17, color: Colors.orange),
                                          SizedBox(width: 10),
                                          Text('3.5', style: TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.bold)),
                                        ],
                                      )
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 8),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text('13 sold', style: TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.bold))
                                        ],
                                      )
                                    ),
                                  ],
                                )
                                
                              ],
                            ),
                          ),
                        );
                      }
                    )
                  );
                } else {
                  return Center(
                    child: Column(
                      children: [
                        Text('The requested item is unavailable.', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('We apologize for the inconvenience.')
                      ],
                    )
                  );
                }
              }
            )
          ],
        ),
      ),
    );
  }
}