import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  CollectionReference postCollection = FirebaseFirestore.instance.collection('post');
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          // leading: Icon(Icons.arrow_back_ios_new, color: Colors.black),
          title: Text("Welcome to Golf Club", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
          actions: [
            Icon(Icons.search, color: Colors.black),
            SizedBox(width: 30)
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home, color: Colors.black), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.home, color: Colors.black), label: "Your Order"),
            BottomNavigationBarItem(icon: Icon(Icons.home, color: Colors.black), label: "User")
          ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            addPost(postCollection);
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          backgroundColor: Colors.black,
          child: Icon(Icons.shopping_bag, color: Colors.white)
        ),
      ),
    );
  }
}

Future<void> addPost(postCollection) async {
  await postCollection.add({
      'title': 'New Golf Post',
      'description': 'This is a test post for golf club',
      'timestamp': FieldValue.serverTimestamp(),
  });
}