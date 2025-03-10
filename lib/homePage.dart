import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/brandPage.dart';
import 'package:flutter_application_1/typePage.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CollectionReference productsCollection = FirebaseFirestore.instance.collection('products');
  CollectionReference categoriesCollection = FirebaseFirestore.instance.collection('categories');
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImageSlideshow(
            autoPlayInterval: 5000,
            isLoop: true,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network('https://plus.unsplash.com/premium_photo-1679710943658-1565004c00ac?q=80&w=3544&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', fit: BoxFit.cover),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network('https://images.unsplash.com/photo-1535131749006-b7f58c99034b?q=80&w=3540&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', fit: BoxFit.cover),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network('https://images.unsplash.com/photo-1593111774240-d529f12cf4bb?q=80&w=3552&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', fit: BoxFit.cover),
              )
            ],
          ),
          SizedBox(height: 15),
          Divider(thickness: 1),
          Text('Get Insprired! Popular Golf', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          SizedBox(
            height: 100,
            child: StreamBuilder(
                stream: productsCollection.snapshots(), 
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    var productsDocument = snapshot.data!.docs;
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: productsDocument.length,
                      itemBuilder: (context, index) {
                        var productsField = productsDocument[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => BrandPage(brand: productsField['brands'])));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            width: 130,
                            child: Image.network(productsField['image_logo']),
                          ),
                        );
                      },
                    );
                  }
                  return Center(
                    child: Text('Something went Wrong!')
                  );
                }
              )
            ),
            SizedBox(height: 15),
            SizedBox(
              height: 100,
              child: StreamBuilder(
                  stream: categoriesCollection.snapshots(), 
                  builder: (context, snapshot) {
                    if(snapshot.hasData){
                      var categoriesDocument = snapshot.data!.docs;
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categoriesDocument.length,
                        itemBuilder: (context, index) {
                          var categoriesField = categoriesDocument[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => TypePage(type: categoriesField['name'])));
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              width: 130,
                              child: Image.network(categoriesField['image_logo'])
                            ),
                          );
                        },
                      );
                    }
                    return Center(
                      child: Text('Something went Wrong!')
                    );
                  }
                )
            ),
            SizedBox(height: 15),
            Divider(thickness: 1),
            Text('Stay focused, and enjoy the game!', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            
          ],
      ),
    );
  }
}