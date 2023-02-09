import 'dart:ui';

import 'package:adronze/Models/ordermodel.dart';
import 'package:adronze/services/placeOrderService.dart';
import 'package:adronze/views/orderdetailview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class orderview extends StatefulWidget {
  const orderview({Key? key}) : super(key: key);

  @override
  State<orderview> createState() => _orderviewState();
}

class _orderviewState extends State<orderview> {
  orderlist listoforder = orderlist([]);

  bool loading = true;
  void getorders() async {
    setState(() {
      loading = true;
    });
    try {
      var ord = await placeOrderService()
          .getorder(FirebaseAuth.instance.currentUser!.uid.toString());
      setState(() {
        listoforder = ord;
      });
    } catch (e) {}
    setState(() {
      loading = false;
    });
  }
  listenToOrderStatus(){
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Map<String,dynamic>? data = message.data;
      if(data['type']=='1'){
        getorders();
      }

    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Add Your Code here.
      getorders();
    });
    listenToOrderStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Orders'),
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xff29A9AB), // appbar color.
          foregroundColor: Colors.white),
        // backgroundColor: Colors.cyan[100],
      body: SizedBox.expand(
        child: loading
            ? Center(
                child: CircularProgressIndicator( color: Color(0xff29A9AB),),
              )
            : listoforder.orders!.length == 0
                ? Center(
                    child: Text("Not Order any item yet"),
                  )
                : ListView.builder(
                    itemCount: listoforder.orders!.length,
                    itemBuilder: (c, i) {
                      var order = listoforder.orders![i];
                      return InkWell(
                        child: Card(
                          elevation: 1,
                          margin: EdgeInsets.all(30),
                          shadowColor: Colors.cyan,
                          // color: Colors.cyan,
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Order Id: " + order.id!.toString(),
                                      style: TextStyle(fontSize: 14),
                                      textAlign: TextAlign.start,
                                    ),
                                    SizedBox(height: 10,),
                                    Text(
                                      "Total Products: " +
                                          order.products!.length.toString(),
                                      style: TextStyle(fontSize: 14),
                                      textAlign: TextAlign.start,
                                    ),
                                    SizedBox(height: 10,),
                                    Text(
                                      "Order status: " +
                                          "${order.status == 0 ? "In Queue" : order.status == 1 ? "Dispatched" :
                                          order.status == 3 ? "Cancel":
                                          "Completed"}",
                                      style: TextStyle(fontSize: 14,
                                      color: order.status==0?Colors.orangeAccent:order.status==1?Colors.blue:
                                       order.status==3?Colors.red:Colors.green),
                                      textAlign: TextAlign.start,
                                    ),
                                     SizedBox(height: 10,),
                                    Text(
                                      "Payment status: " +
                                          "${order.payment == 0 ? " Payment in progress" : "Payment Sucessful"}" ,
                                      style: TextStyle(fontSize: 14,
                                          color: order.payment==0?Colors.red:Colors.green),
                                      textAlign: TextAlign.start,
                                    ),
                                  ],

                                ),
                                Spacer(),
                                Icon(Icons.arrow_right_alt_outlined)
                              ],
                            ),
                          ),

                        ),

                        onTap: (){
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (BuildContext contex)
                            {
                              return orderdetailview(order: order,);
                            }));
                        },
                      );

                    }
                    ),

      ),

    );
  }
}
