import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Models/cartmodel.dart';
import '../Models/productmodel.dart';
import '../services/firebaseaddcartservice.dart';

class groceryitem extends StatefulWidget {
  cartm? cm;
  groceryitem({Key? key,this.cm}) : super(key: key);

  @override
  State<groceryitem> createState() => _groceryitemState();
}

class _groceryitemState extends State<groceryitem> {

  List<productm> products = [
    productm("Vegetable", "assets/images/grocery/vegetable.png", "80", "1kg item only"),
    productm("Fruits", "assets/images/grocery/fruits.png", "300", "1kg item only"),
    productm("Burger", "assets/images/grocery/burger.png", "150", "1 Burger only"),
    productm("Drink", "assets/images/grocery/drink.png", "50", "1 NR Drink only"),
  ];


  cartm? cm;

  @override
  void initState() {

    super.initState();
    if(widget.cm != null){
      cm = widget.cm;
    }
  }
  void getproducts()async{
    var cartdata = await cartservice().getcart(FirebaseAuth.instance.currentUser!.uid.toString());
    if(cartdata.id != null && cartdata.id!.isNotEmpty){
      setState(() {
        cm = cartdata;
      });
    }
  }

  late double w,h;
  late double itemW,itemH;
  @override
  Widget build(BuildContext context) {
    w= MediaQuery.of(context).size.width;
    h= MediaQuery.of(context).size.height;
    itemW=w*0.45;
    itemH=h*0.1;
    return Scaffold(
      appBar: AppBar(
          title: const Text('Grocery item'),
          backgroundColor: Color(0xff29A9AB), // appbar color.
          foregroundColor: Colors.white),
      // backgroundColor: Colors.cyan[100],
      body:
      SizedBox.expand(

        child: Padding(
          padding: const EdgeInsets.only(top: 40,right: 20,left: 20),
          child:ListView.builder(
              shrinkWrap: true,
              // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //   crossAxisCount: 2,
              //   childAspectRatio: 0.9,
              //   crossAxisSpacing: 16,
              //   mainAxisSpacing: 16,
              // ),
              itemCount: products.length,
              itemBuilder: (c,i) {
                var item = products[i];

                bool alreadyexist = false;
                if(cm != null){
                  for(var p in cm!.products!){
                    if(p.name == item.name){
                      alreadyexist = true;
                      print(alreadyexist);
                      break;
                    }
                  }
                }

                return
                  categoryItems(item.name.toString(),item.img.toString(), item.price.toString(),
                      alreadyexist,
                          ()async{

                        String uid = FirebaseAuth.instance.currentUser!.uid;
                        bool check = await cartservice().addtocart(uid, item);
                        if(check){
                          setState(() {
                            cm!.products!.add(item);
                          });

                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Product Added")));
                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Product Adding Failed")));
                        }
                      });
              }

          ),
        ),
      ),
    );
  }
  categoryItems(String title, String image, String price, bool alreadyadded,ontap){
    return InkWell(
      onTap: (){
        ontap();
      },
      child: SizedBox(
        width: itemW,
        height: itemH,
        child: Card(
          child: Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 10),
                child: Image.asset(image,width: 50,height: h*.09, ),
              ),
              Spacer(),
              Text(title,style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),),
              Spacer(),
              Text("Price ${price} Rs"),
              Spacer(),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xff29A9AB),
                  //onPrimary: Colors.black,
                ),

                onPressed:alreadyadded ? ()async{
                  bool check = await cartservice().detletefromcart(FirebaseAuth.instance.currentUser!.uid, title);
                  if(check) {
                    for(int i=0; i< cm!.products!.length;i++) {
                      if(cm!.products![i].name == title){
                        setState(() {
                          cm!.products!.removeAt(i);
                        });
                      }
                    }
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Product Remove")));
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Product Removing Failed")));
                  }
                }
                    : ontap,
                icon:
                alreadyadded ?
                Icon(Icons.minimize,
                  size: 12.0,
                  color: Colors.white,):
                Icon(
                  Icons.card_travel,
                  size: 12.0,
                  color: Colors.white,
                ),
                label: Text(alreadyadded ? "remove": 'Add to Cart',
                  style: TextStyle(
                    color: Colors.white,
                  ),),

              ),
            ],

          ),
        ),
      ),
    );

  }
}
