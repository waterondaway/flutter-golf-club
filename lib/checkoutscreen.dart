import 'package:flutter/material.dart';

class Checkoutscreen extends StatefulWidget {
  const Checkoutscreen({super.key});

  @override
  State<Checkoutscreen> createState() => _CheckoutscreenState();
}

class _CheckoutscreenState extends State<Checkoutscreen> {
  int? selectedPaymentMethod;
  @override
  List<Map<String, dynamic>> cartItems = [
    {
      "name": "ไม้กอล์ฟยกชุด",
      "price": 100.0,
      "quantity": 1,
      "image": 'assets/images/download (1).jpg'
    },
    {
      "name": "ไม้กอล์ฟยกชุด",
      "price": 200.0,
      "quantity": 2,
      "image": 'assets/images/download (1).jpg'
    },
  ];

  void _increaseQuantity(int index) {
    setState(() {
      cartItems[index]["quantity"]++;
    });
  }

  void _decreaseQuantity(int index) {
    setState(() {
      if (cartItems[index]["quantity"] > 1) {
        cartItems[index]["quantity"]--;
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          "Order summary",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2),
          child: Container(
            color: Colors.grey,
            height: 1,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 170,
            child: Align(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5),
                  Text(
                    "  📌 ณัฐชานันท์ ล้อดี (+66)99*****95",
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "   19/9 หมู่ 8 ต.ทุ่งสุขลา อ.ศรีราชา จ.ชลบุรี 20230",
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "   ห้อง B110 อำเภอศรีราชา จังหวัดชลบุรี 20230",
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "   20230,ศรีราชา,ชลบุรี,ไทย",
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(height: 5),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  return buildCartItem(cartItems[index], index);
                },
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 1,
            color: Colors.grey,
          ),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Payment method",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          // ถ้าคลิกแล้วเลือก, ถ้ากดซ้ำให้ยกเลิก
                          selectedPaymentMethod =
                              (selectedPaymentMethod == 1) ? null : 1;
                          print(
                              'Selected Payment Method: $selectedPaymentMethod');
                        });
                      },
                      child: ListTile(
                        leading: Icon(Icons.credit_card,color: Colors.blue,),
                        title: Text("Credit Card"),
                        trailing: Icon(
                          selectedPaymentMethod == 1
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey, // สีของเส้นขอบ
                  width: 1.0, // ความหนาของเส้นขอบ
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total: ฿00.00 ",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Checkoutscreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, // สีพื้นหลังของปุ่ม
                      foregroundColor: Colors.white, // สีข้อความของปุ่ม
                      
                    ),
                    child: Text(
                      "Place order",
                      style: TextStyle(),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildCartItem(Map<String, dynamic> item, int index) {
    return ListTile(
      leading: Container(
        width: 80,
        height: 300,
        child: Image.asset(
          item["image"],
          fit: BoxFit.fill,
        ),
      ),
      title: Text(
        item["name"],
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("ราคา: ${item["price"]} บาท | จำนวน: ${item["quantity"]}"),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                  width: 130, // กำหนดความกว้างของกล่อง
                  height: 30,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey), // ขอบของกล่อง
                    borderRadius: BorderRadius.circular(8), // มุมกลม
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => _decreaseQuantity(index),
                        icon: Icon(Icons.remove, color: Colors.black, size: 15),
                      ),
                      Container(
                        height: 24, // ความสูงของเส้นขั้น
                        width: 1, // ความหนาของเส้นขั้น
                        color: Colors.grey, // สีของเส้นขั้น
                      ),
                      SizedBox(width: 10),
                      Text(
                        "${item["quantity"]}",
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(width: 10),
                      Container(
                        height: 24, // ความสูงของเส้นขั้น
                        width: 1, // ความหนาของเส้นขั้น
                        color: Colors.grey, // สีของเส้นขั้น
                      ),
                      IconButton(
                        onPressed: () => _increaseQuantity(index),
                        icon: Icon(Icons.add, color: Colors.black, size: 15),
                      )
                    ],
                  ))
            ],
          )
        ],
      ),
    );
  }
}
