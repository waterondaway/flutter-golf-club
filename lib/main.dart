import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<String> filters = []; // ✅ เพิ่มตัวแปร filters
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "Welcome to Golf Club",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          actions: [
            Icon(Icons.search, color: Colors.black),
            SizedBox(width: 20),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home, color: Colors.black), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart, color: Colors.black),
                label: "Your Order"),
            BottomNavigationBarItem(
                icon: Icon(Icons.person, color: Colors.black), label: "User"),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          backgroundColor: Colors.black,
          child: Icon(Icons.shopping_bag, color: Colors.white),
        ),
        body: Padding(
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
                    borderRadius: BorderRadius.circular(
                        20), // กำหนดขนาดของโค้งมุมที่ต้องการ
                    child: Image.network(
                      'https://plus.unsplash.com/premium_photo-1679710943658-1565004c00ac?q=80&w=3544&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                      fit: BoxFit.cover,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                        20), // กำหนดขนาดของโค้งมุมที่ต้องการ
                    child: Image.network(
                      'https://images.unsplash.com/photo-1535131749006-b7f58c99034b?q=80&w=3540&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                      fit: BoxFit.cover,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                        20), // กำหนดขนาดของโค้งมุมที่ต้องการ
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
                      children: ["All", "Man", "Woman"].map((filter) {
                        return FilterChip(
                          label: Text(filter),
                          selected: filters.contains(filter),
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
                                filters.add(filter);
                              } else {
                                filters.remove(filter);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      padding: EdgeInsets.all(12),
                    ),
                    child: Text(
                      'More Info',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),

              // ✅ เส้นคั่น
              Divider(thickness: 1),
              Container(
                child: Text('Get Insprired! Popular Golf',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 15),
              // ✅ Brand List
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(
                    5,
                    (index) => Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text('Golf Brand ${index + 1}',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 15),

              // ✅ Club List
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(
                    5,
                    (index) => Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text('Golf Club ${index + 1}',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
