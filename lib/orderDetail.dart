import 'package:flutter/material.dart';

class Orderdetail extends StatefulWidget {
  const Orderdetail({super.key});

  @override
  State<Orderdetail> createState() => _OrderdetailState();
}

class _OrderdetailState extends State<Orderdetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text("Order Detail", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(padding: EdgeInsets.only(top: 10)),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              width: 400,
              height: 190,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.grey),
              padding: EdgeInsets.only(left: 20, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Status Your Order",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: 400,
                    height: 2,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ]),
          SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              width: 400,
              height: 320,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.grey),
              padding: EdgeInsets.only(left: 30, top: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.black),
                        child: Center(
                            child: Text(
                          "รูปภาพ",
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Container(
                        width: 200,
                        height: 110,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white),
                        child: Center(child: Text("ชื่อสินค้า,ราคา")),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.black),
                        child: Center(
                            child: Text(
                          "รูปภาพ",
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Container(
                        width: 200,
                        height: 110,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white),
                        child: Center(child: Text("ชื่อสินค้า,ราคา")),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ]),
          SizedBox(
            height: 10,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              width: 400,
              height: 130,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.grey),
              padding: EdgeInsets.only(left: 20, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 360,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("หมายเลขคำสั่งซื้อ"),
                                Text("283473947")
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 360,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [Text("ชำระผ่าน"), Text("Credit card")],
                            )
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
