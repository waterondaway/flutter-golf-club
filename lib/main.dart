import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/cartPage.dart';
import 'package:flutter_application_1/homePage.dart';
import 'package:flutter_application_1/orderPage.dart';
import 'package:flutter_application_1/profilePage.dart';
import 'firebase_options.dart';

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
	final mobileScreen = [HomePage(), OrderPage(), ProfilePage()];
	List<String> header = ["Golf Club Elite", "Your Order", "Profile"];
	List<String> subheader = ["Your Golf Journey Starts Here", "Track Your Purchases Easily", "Stay on Top of Your Game"];
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: Colors.white,
			appBar: AppBar(
				backgroundColor: Colors.white,
				title: Row(
					children: [
						Image.asset('assets/images/golf.png', width: 40, height: 40),
						Container(
							padding: EdgeInsets.only(left: 20),
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									Text(header[indexScreen], style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
									Text(subheader[indexScreen], style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600))
								],
							),
						)
					],
				),
				actions: [
					Container(
						padding: EdgeInsets.only(right: 20),
						child: GestureDetector(
							onTap: () {
								setState(() {
									indexScreen = 2;
								});
							},
							child: Icon(Icons.account_circle, color: Colors.black, size: 40),
						),
					)
				],
			),
			body: mobileScreen[indexScreen],
			floatingActionButton: FloatingActionButton(
				onPressed: () {
					Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage()));
				},
				shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
				backgroundColor: Colors.black,
				child: Icon(Icons.shopping_bag, color: Colors.white, size: 30),
			),
			bottomNavigationBar: BottomNavigationBar(
				backgroundColor: Colors.white,
				currentIndex: indexScreen,
				onTap: (int index){
					setState(() {
						indexScreen = index;
					});
				},
				items: [
					BottomNavigationBarItem(icon: Icon(Icons.house, color: indexScreen == 0 ? Colors.black : Colors.grey), label: "Home"),
					BottomNavigationBarItem(icon: Icon(Icons.list_alt, color: indexScreen == 1 ? Colors.black : Colors.grey), label: "Your Order"),
					BottomNavigationBarItem(icon: Icon(Icons.manage_accounts, color: indexScreen == 2 ? Colors.black : Colors.grey), label: "Profile")
				],
				selectedLabelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
				selectedItemColor: Colors.black,
			),
		);
	}
}