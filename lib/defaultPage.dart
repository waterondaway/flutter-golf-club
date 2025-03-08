import 'package:flutter/material.dart';
import 'package:flutter_application_1/homePage.dart';
import 'package:flutter_application_1/orderPage.dart';
import 'package:flutter_application_1/profilePage.dart';

class defaultPage extends StatefulWidget {
  const defaultPage({super.key});

  @override
  State<defaultPage> createState() => _defaultPageState();
}

class _defaultPageState extends State<defaultPage> {
  int indexScreen = 0;
  final mobileScreen = [homePage(), orderPage(), profilePage()];
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
                //  Navigator.push(
                //   context, 
                //   MaterialPageRoute(
                //     builder: (context) => Cartshopscreen()),
                //     );
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