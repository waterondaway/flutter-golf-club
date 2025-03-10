import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  // Function for user login
  void userLogin() async {
    showDialog(
      context: context, 
      builder: (context) {
        return  Center(
          child: Stack(
            children: [
              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.transparent)),
              Image.asset('assets/images/golf.png', width: 80, height: 80)
            ]
          ),
        );
      }
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailControl.text, password: passwordControl.text);
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
    Navigator.pop(context);
  }
  // Function for user register
  void userRegister() async {
    showDialog(
      context: context, 
      builder: (context) {
        return Center(
          child: Stack(
            children: [
              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.transparent)),
              Image.asset('assets/images/golf.png', width: 80, height: 80)
            ]
          ),
        );
      }
    );
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailControl.text, password: passwordControl.text);
      String uid = userCredential.user!.uid;
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'fullname': fullnameControl.text,
        'telephone': telephoneControl.text,
        'address': addressControl.text
      });
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
    Navigator.pop(context);
  }

  final _loginFormKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();
  bool _isEmailValid = true;
  bool _isPasswordValid = true;
  bool _isFullnameValid = true;
  bool _isTelephoneValid = true;
  bool _isAddressValid = true;
  final emailControl = TextEditingController();
  final passwordControl = TextEditingController();
  final telephoneControl = TextEditingController();
  final fullnameControl = TextEditingController();
  final addressControl = TextEditingController();
  int indexScreen = 0;
  List<String> header = ["Sign In to Continue", "Register to Join Us"];
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
                  Text("Golf Club Authentication", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600))
                ],
              ),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: indexScreen == 0 ? Colors.black : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10))
                  )
                ),
                onPressed: () {
                  setState(() {
                    _isEmailValid = true;
                    _isPasswordValid = true;
                    indexScreen = 0;
                  });
                }, 
                child: Text('Login', style: TextStyle(color: indexScreen == 0 ? Colors.white : Colors.black))
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: indexScreen == 1 ? Colors.black : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10))
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _isEmailValid = true;
                    _isPasswordValid = true;
                    _isFullnameValid = true;
                    _isTelephoneValid = true;
                    _isAddressValid = true;
                    indexScreen = 1;
                  });
                }, 
                child: Text('Register', style: TextStyle(color: indexScreen == 1 ? Colors.white : Colors.black))
              )
            ],
          ),
          indexScreen == 0 ? 
          Form(
            key: _loginFormKey,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top:20, left: 20, right: 20),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        setState(() {
                          _isEmailValid = false;
                        });
                        return "Please enter your email.";
                      } else {
                        setState(() {
                          _isEmailValid = true;
                        });
                      }
                    },
                    controller: emailControl,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Email",
                      labelStyle: TextStyle(color: _isEmailValid ? Colors.black : Color(0xFFc75d59)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2))
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top:20, left: 20, right: 20, bottom: 20),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        setState(() {
                          _isPasswordValid = false;
                        });
                        return "Please enter your password.";
                      } else {
                        setState(() {
                          _isPasswordValid = true;
                        });
                      }
                    },
                    obscureText: true,
                    controller: passwordControl,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Password",
                      labelStyle: TextStyle(color: _isPasswordValid ? Colors.black : Color(0xFFc75d59)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2))
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black
                  ),
                  onPressed: () {
                    _loginFormKey.currentState!.validate() ? userLogin() : null; 
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
          ) : 
          Form(
            key: _registerFormKey,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top:20, left: 20, right: 20),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        setState(() {
                          _isEmailValid = false;
                        });
                        return "Please enter your email.";
                      } else {
                        setState(() {
                          _isEmailValid = true;
                        });
                      }
                    },
                    controller: emailControl,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Email",
                      labelStyle: TextStyle(color: _isEmailValid ? Colors.black : Color(0xFFc75d59)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2))
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top:20, left: 20, right: 20),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        setState(() {
                          _isPasswordValid = false;
                        });
                        return "Please enter your password.";
                      } else {
                        setState(() {
                          _isPasswordValid = true;
                        });
                      }
                    },
                    obscureText: true,
                    controller: passwordControl,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Password",
                      labelStyle: TextStyle(color: _isPasswordValid ? Colors.black : Color(0xFFc75d59)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2))
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top:20, left: 20, right: 20),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        setState(() {
                          _isFullnameValid = false;
                        });
                        return "Please enter your fullname.";
                      } else {
                        setState(() {
                          _isFullnameValid = true;
                        });
                      }
                    },
                    controller: fullnameControl,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Fullname",
                      labelStyle: TextStyle(color: _isFullnameValid ? Colors.black : Color(0xFFc75d59)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2))
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top:20, left: 20, right: 20),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        setState(() {
                          _isTelephoneValid = false;
                        });
                        return "Please enter your telephone.";
                      } else {
                        setState(() {
                          _isTelephoneValid = true;
                        });
                      }
                    },
                    controller: telephoneControl,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Telephone",
                      labelStyle: TextStyle(color: _isTelephoneValid ? Colors.black : Color(0xFFc75d59)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2))
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top:20, left: 20, right: 20, bottom: 20),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        setState(() {
                          _isAddressValid = false;
                        });
                        return "Please enter your address.";
                      } else {
                        setState(() {
                          _isAddressValid = true;
                        });
                      }
                    },
                    controller: addressControl,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Address",
                      labelStyle: TextStyle(color: _isAddressValid ? Colors.black : Color(0xFFc75d59)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2))
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black
                  ),
                  onPressed: () {
                    _registerFormKey.currentState!.validate() ? userRegister() : null; 
                  }, 
                  child: Container(
                    width: 120,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.app_registration_rounded, color: Colors.white),
                        SizedBox(width: 20),
                        Text('Register', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))
                      ],
                    ),
                  )
                ),
              ],
            ),
          ),
        ],
      )
    );
  }
}