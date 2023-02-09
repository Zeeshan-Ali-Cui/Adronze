class productm {
  String? name;
  String? img;
  String? price;
  String? discription;
  productm( this.name, this.img, this.price,this.discription);
  productm.fromjson(Map<String, dynamic> json){
    name = json["name"];
    img = json["img"];
    price = json["price"];
    discription = json["discription"];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> pdata = new Map<String, dynamic>();

    pdata['name'] = this.name;
    pdata['img'] = this.img;
    pdata['price']= this.price;
    pdata['discription']= this.discription;
    return pdata;
  }

}

