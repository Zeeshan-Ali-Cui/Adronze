import 'package:adronze/Models/productmodel.dart';

class orderm {
  String? id;
  String? name;
  String? lat;
  String? long;
  int? status;
  int? payment;
  String? address;
  List<productm>? products;

  orderm(this.id,this.name,this.lat,this.long,this.status,this.address,this.products,this.payment);

  orderm.fromjson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    lat = json['lat'];
    long = json['long'];
    status = json['status'];
    payment = json['payment'];
    address = json['address'] ?? "";
    if (json['products'] != null) {
      products = <productm>[];
      json['products'].forEach((v) {
        products!.add(new productm.fromjson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    print("$payment+_______________");
    Map<String, dynamic> odata = new Map<String, dynamic>();
    odata['id'] = this.id;
    odata['name'] = this.name;
    odata['lat'] = this.lat;
    odata['long'] = this.long;
    odata['status'] = this.status;
    odata['payment'] = this.payment;
    odata['address'] = this.address ?? "";
    odata['products']=this.products!.map((e) => e.toJson()).toList();

    return odata;
  }

}


class orderlist {
  List<orderm>? orders ;

  orderlist(this.orders);

  orderlist.fromjson(Map<String, dynamic> json){

    if (json['orders'] != null) {
      orders = <orderm>[];
      json['orders'].forEach((v) {
        orders!.add(new orderm.fromjson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> odata = new Map<String, dynamic>();
    odata['orders']=this.orders!.map((e) => e.toJson()).toList();

    return odata;
  }


}