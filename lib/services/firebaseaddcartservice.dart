import 'package:adronze/Models/cartmodel.dart';
import 'package:adronze/Models/productmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class cartservice{
  Future<cartm> getcart(String uid)async{
    cartm cart = cartm("", []);
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      var col = await firestore.collection("Carts").doc(uid).get();
      cart = cartm.fromjson(col.data() as Map<String, dynamic>);
      print(cart.products!.length.toString()+"----------->>>>>>>>>>>>>>>>>");
      return cart;
    }catch(e){}

    return cart;
  }

  Future<bool> addtocart(String uid,productm pm)async{
    cartm cart = cartm("", []);
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      try{
      var col = await firestore.collection("Carts").doc(uid).get();
      if(col != null) {
        cart = cartm.fromjson(col.data() as Map<String, dynamic>);
      }
      }catch(e){}
      //add new product
      cart.products!.add(pm);
      await firestore.collection("Carts").doc(uid).set(cart.toJson());



      return true;
    }catch(e){}

    return false;
  }

  Future<bool> detletefromcart(String uid,String name)async{
    cartm cart = cartm("", []);
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      try{
        var col = await firestore.collection("Carts").doc(uid).get();
        if(col != null) {
          cart = cartm.fromjson(col.data() as Map<String, dynamic>);
          cart.products!.removeWhere((element) => element.name.toString() == name.toString());
          await firestore.collection("Carts").doc(uid).set(cart.toJson());
        }
      }catch(e){}
      //add new product



      return true;
    }catch(e){}

    return false;
  }

}