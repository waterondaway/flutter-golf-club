import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/brand.dart';
import 'package:flutter_application_1/cartshopscreen.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int indexScreen = 0;
  final mobileScreen = [Home(), Order(), Profile()];
  List<String> header = ["Golf Club Elite", "Your Order", "Profile"];
  List<String> subheader = ["Your Golf Journey Starts Here", "Track Your Purchases Easily", "Stay on Top of Your Game"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Row(
            children: [
              Image.asset('assets/images/golf.png', width: 40, height: 40),
              Padding(padding: EdgeInsets.only(left: 20), child: 
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(header[indexScreen], style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),
                  Text(subheader[indexScreen], style: TextStyle(color: Colors.black, fontSize: 18))
                ]
              )
            )
            ],
          ),
          actions: [
          Padding(
              padding: EdgeInsets.only(right: 20),
              child: Builder(
                builder: (context) => GestureDetector(
                  onTap: () { 
                    setState(() {
                      indexScreen = 2;
                    });
                    // Navigator.push(
                    //   context, 
                    //   MaterialPageRoute(builder: (context) => authPage()),
                    // );
                  },
                  child: Icon(Icons.account_circle, color: Colors.black, size: 40),
                ),
              ),
            )
          ],
          backgroundColor: Colors.white,
        ),
        body: mobileScreen[indexScreen],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: indexScreen,
          onTap: (int index) {
            setState(() {
              indexScreen = index;
            });
            print(index);
          },
          backgroundColor: Colors.white,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.house,
                    color: indexScreen == 0 ? Colors.black : Colors.grey),
                label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.list_alt,
                    color: indexScreen == 1 ? Colors.black : Colors.grey),
                label: "Your Order"),
            BottomNavigationBarItem(
                icon: Icon(Icons.manage_accounts,
                    color: indexScreen == 2 ? Colors.black : Colors.grey),
                label: "Profile")
          ],
          selectedLabelStyle: TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black87,
        ),
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton(
              onPressed: () {

                 Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => Cartshopscreen()),
                    );
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
              backgroundColor: Colors.black,
              child: Icon(Icons.shopping_bag, color: Colors.white)
            );
          }
        ),
      );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CollectionReference getProducts =
      FirebaseFirestore.instance.collection('products');
  CollectionReference getCategories =
      FirebaseFirestore.instance.collection('categories');
  List<String> filters = ["All"];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Slideshow
          ImageSlideshow(
            autoPlayInterval: 10000,
            isLoop: true,
            onPageChanged: (value) {
              print('Page changed: $value');
            },
            children: [
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(10), // กำหนดขนาดของโค้งมุมที่ต้องการ
                child: Image.network(
                  'https://plus.unsplash.com/premium_photo-1679710943658-1565004c00ac?q=80&w=3544&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                  fit: BoxFit.cover,
                ),
              ),
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(10), // กำหนดขนาดของโค้งมุมที่ต้องการ
                child: Image.network(
                  'https://images.unsplash.com/photo-1535131749006-b7f58c99034b?q=80&w=3540&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                  fit: BoxFit.cover,
                ),
              ),
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(10), // กำหนดขนาดของโค้งมุมที่ต้องการ
                child: Image.network(
                  'https://images.unsplash.com/photo-1593111774240-d529f12cf4bb?q=80&w=3552&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),

          SizedBox(height: 15),

          // ✅ Filter & Button
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Wrap(
                  spacing: 10.0,
                  children: ["All", "Juniors", "Ladies", "Mens"].map((filter) {
                    return FilterChip(
                      backgroundColor: Colors.white,
                      checkmarkColor: Colors.white,
                      selectedColor: Colors.black,
                      label: Text(filter),
                      labelStyle: TextStyle(
                          color: filters.contains(filter)
                              ? Colors.white
                              : Colors.black),
                      selected: filters.contains(filter),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            if (filter == "All") {
                              filters.clear();
                              filters.add(filter);
                            } else {
                              filters.add(filter);
                              filters.remove("All");
                            }
                          } else {
                            filters.remove(filter);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          SizedBox(height: 15),

          // ✅ เส้นคั่น
          Divider(thickness: 1),
          Container(
            child: Text('Get Insprired! Popular Golf',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ),
          SizedBox(height: 15),
          // ✅ Brand List
          SizedBox(
            height: 100,
            child: StreamBuilder(
              stream: getProducts.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('เกิดข้อผิดพลาด'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('ไม่มีข้อมูล'));
                }
                var products = snapshot.data!.docs;
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    var product = products[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Brand(
                                      brands: product['brands'],
                                      filters: filters
                                    )));
                      },
                      child: Container(
                        width: 130,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Image.network(product['image_logo']),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          SizedBox(height: 15),

          // ✅ Club List
          SizedBox(
            height: 100,
            child: StreamBuilder(
              stream: getCategories.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('เกิดข้อผิดพลาด'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('ไม่มีข้อมูล'));
                }
                var categories = snapshot.data!.docs;
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    var type = categories[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Brand(
                                      brands: type['brands'],
                                      filters: filters,
                                    )));
                      },
                      child: Stack(
                        children: [
                          Container(
                            width: 130,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Image.network(type['image_logo']),
                            ),
                          ),
                          Positioned(
                            top: 75,
                            left: 30,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(1), // สีเงา
                                    blurRadius: 0, // ระยะเบลอของเงา
                                    offset: Offset(0, 0), // ระยะห่างของเงา (x, y)
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  type['name'],
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ]),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [

          Container(
            height: 170,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3), // สีของเงา
                  spreadRadius: 1, // ระยะการกระจายของเงา
                  blurRadius: 3, // ความเบลอของเงา
                  offset: const Offset(0, 0), // ตำแหน่งเงา
                ),
              ]
            ),
            
          ),

          SizedBox(height: 20),

          Container(
            height: 170,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3), // สีของเงา
                  spreadRadius: 1, // ระยะการกระจายของเงา
                  blurRadius: 3, // ความเบลอของเงา
                  offset: const Offset(0, 0), // ตำแหน่งเงา
                ),
              ]
            ),
            
          ),


          
          // ClipRRect(
          //       borderRadius:
          //           BorderRadius.circular(10), // กำหนดขนาดของโค้งมุมที่ต้องการ
          //       child: Image.network(
          //         'https://plus.unsplash.com/premium_photo-1679710943658-1565004c00ac?q=80&w=3544&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
          //         fit: BoxFit.cover,
          //       ),
          //     ),
        ],
      )
    );
  }
}

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Center(
        
      )
    );
  }
}
