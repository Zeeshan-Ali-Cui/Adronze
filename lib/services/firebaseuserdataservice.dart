import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart' as fbs;
import 'package:adronze/Models/model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as p;
class userdataservice {

  Future<bool> datastore_user()async{
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    var col = await firestore.collection("users").get();
    for(var data in col.docs){
      print("email : "+data["email"]+"Name : "+data["name"]);
    }

    return false;
  }


  Future<bool> datastoreonsignup(Userdata data)async{

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    var col = await firestore.collection("users").doc(data.id).set(data.toJson());

    return false;
  }


Future<bool> savelatlong(String uid, String Lat, String Long)async{

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var col = await firestore.collection("users").doc(uid).update({"Lat":Lat, "Long": Long});


  return false;
}
  Future<Userdata> showuserdata(String uid)async{

    Userdata us = Userdata("","", "", "", "","");

    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      var col = await firestore.collection("users").doc(uid).get();
      us = Userdata.fromjson(col.data() as Map<String,dynamic> );
      return us;
    }catch(e){}

    return us;
  }

  Future<bool> UpdateCoverPhoto(File imageFile,String uid) async {
    var imgUrl = "";
    try {
      var storageImage = fbs.FirebaseStorage.instance
          .ref()
          .child("img")
          .child(uid)
          .child("Prodile Picture");
      // imageFile.path.replaceAll(new RegExp(r'/'), '')

      final metadata = fbs.SettableMetadata(
          contentType: '${p.extension(imageFile.path)}',
          customMetadata: {'picked-file-path': imageFile.path});

      var task = storageImage.putFile(imageFile, metadata);
      imgUrl = await (await task.whenComplete(() => null)).ref.getDownloadURL();



      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({"img": imgUrl,
      });

      return true;
    } on Exception catch (e) {
      return false;
    }
  }

  Future<void> savetoken(String id)async {
    try {
      FirebaseMessaging.instance.getToken().then((value) async{
        print("token ------------>> $value");
        FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection("Tokens").doc(id).set(
          {"Token": value});});




    }catch(e){}
  }
}
