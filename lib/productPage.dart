import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Productpage extends StatefulWidget {
  const Productpage({super.key, required this.productId});
  final String productId;

  @override
  State<Productpage> createState() => _ProductpageState();
}

class _ProductpageState extends State<Productpage> {
  CollectionReference products = FirebaseFirestore.instance.
  collection('products')
  .doc()
  .collection('');

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Column(
        children: [
          Text(widget.productId),
          Container(
            // child: Image.network(''),
          )
        ],
      ),
    );
  }
}