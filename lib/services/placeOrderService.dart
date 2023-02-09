import 'package:adronze/Models/cartmodel.dart';
import 'package:adronze/Models/ordermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class placeOrderService {
  Future<bool> placeorder(String? uid, orderm om) async {
    try {
      orderlist orders = orderlist([]);
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      try {
        var col = await firestore.collection("Orders").doc(uid).get();
        if (col != null) {
          orders = orderlist.fromjson(col.data() as Map<String, dynamic>);
        }
      } catch (e) {}
      //add new product
      orders.orders!.add(om);
      await firestore.collection("Orders").doc(uid).set(orders.toJson());

      //empty cart
      cartm cart = cartm(uid, []);
            await firestore.collection("Carts").doc(uid).set(cart.toJson());



            return true;
    } catch (e) {
      return false;
    }
  }

  Future<orderlist> getorder(
    String? uid,
  ) async {
    orderlist orders = orderlist([]);

    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      try {
        var col = await firestore.collection("Orders").doc(uid).get();
        if (col != null) {
          orders = orderlist.fromjson(col.data() as Map<String, dynamic>);
        }
      } catch (e) {}

      return orders;
    } catch (e) {
      return orders;
    }
  }
}
