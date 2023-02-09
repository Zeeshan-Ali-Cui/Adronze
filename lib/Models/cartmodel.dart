import 'package:adronze/Models/productmodel.dart';

class cartm {
  String? id;
  List<productm>? products;
  cartm( this.id, this.products);

  cartm.fromjson(Map<String, dynamic> json){
    id = json['id'];
    if (json['products'] != null) {
      products = <productm>[];
      json['products'].forEach((v) {
        products!.add(new productm.fromjson(v));
      });
    }

  }

  Map<String, dynamic> toJson() {
     Map<String, dynamic> cdata = new Map<String, dynamic>();

    cdata['id'] = this.id;
    cdata['products']=this.products!.map((e) => e.toJson()).toList();

    return cdata;
  }
}

