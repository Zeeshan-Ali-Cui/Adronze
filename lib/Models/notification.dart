


import 'package:adronze/Models/ordermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel{
  String? uid;
  int? status;
  orderm? order;
  DateTime? at;

  NotificationModel.fromjson(Map<String, dynamic> json){
    uid=json['uid'];
    status=json['status'];
    order=orderm.fromjson(json['order']);
    at=(json['at'] as Timestamp).toDate();
  }

}