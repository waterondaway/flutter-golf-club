import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/authPage.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Function to show model for user edit.
  void showEditDialog(BuildContext context, String field, String? currentValue, DocumentReference userDocument){
    TextEditingController controller = TextEditingController(text: currentValue);
    showDialog(
      context: context, 
      builder: (context){
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Editing Profile', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          content: TextField(
            cursorColor: Colors.black,
            controller: controller,
            decoration: InputDecoration(
              labelText: 'Enter new $field',
              border: OutlineInputBorder(),
              labelStyle: TextStyle(color: Colors.black),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2))
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black
              ),
              onPressed: () async {
                await userDocument.update({field: controller.text});
                Navigator.of(context).pop();
              },
              child: Text('Save', style: TextStyle(color: Colors.white)),
            )
          ],
        );
      }
    );
  }
  // Function for user signout.
  void userLogout() async {
    FirebaseAuth.instance.signOut();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(), 
      builder: (context, snapshot){
        if (snapshot.hasData) {
          final currentUser = FirebaseAuth.instance.currentUser;
          DocumentReference userDocument = FirebaseFirestore.instance.collection('users').doc(currentUser!.uid);
          return StreamBuilder(
            stream: userDocument.snapshots(), 
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting){
                return  Center(
                  child: Stack(
                    children: [
                      CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.transparent)),
                      Image.asset('assets/images/golf.png', width: 80, height: 80)
                    ]
                  ),
                );
              }
              var currentUserField = snapshot.data!.data() as Map<String, dynamic>;
              return ListView(
                padding: EdgeInsets.only(top: 10, left: 10),
                children: [
                  ListTile(
                    title: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: "Name: ", style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: currentUserField['fullname'] ?? "Not Found!")
                        ],
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.edit_rounded, 
                      size: 17, 
                      color: Colors.black),
                      onPressed: () {
                        showEditDialog(context, 'fullname', currentUserField['fullname'], userDocument);
                      },
                    ),
                  ),
                  ListTile(
                    title: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: "Phone: ", style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: currentUserField['telephone'] ?? "Not Found!")
                        ],
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.edit_rounded, 
                      size: 17, 
                      color: Colors.black),
                      onPressed: () {
                        showEditDialog(context, 'telephone', currentUserField['telephone'], userDocument);
                      },
                    ),
                  ),
                  ListTile(
                    title: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: "Address: ", style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: currentUserField['address'] ?? "Not Found!")
                        ],
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.edit_rounded, 
                      size: 17, 
                      color: Colors.black),
                      onPressed: () {
                        showEditDialog(context, 'address', currentUserField['address'], userDocument);
                      },
                    ),
                  ),
                  ListTile(
                    title: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Loggined with ${currentUser!.email}', style: TextStyle(fontSize: 13, color: Colors.grey)),
                          SizedBox(height: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black
                            ),
                            onPressed: () {
                              userLogout();
                            }, 
                            child: Container(
                              width: 80,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.logout, color: Colors.white, size: 14),
                                  SizedBox(width: 15),
                                  Text('Logout', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold))
                                ],
                              ),
                            )
                          ),
                        ],
                      ),
                    )
                  ),
                ],
              );
            }
          );
        } else {
          return Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("You are currently using without logging in.", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text("For the best golf experience, please log in now.", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14)),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AuthPage()));
                    }, 
                    child: Container(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.login, color: Colors.white),
                          SizedBox(width: 20),
                          Text('Login', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))
                        ],
                      ),
                    )
                  )
                ],
              ),
            ),
          );
        }
      }
    );
  }
}