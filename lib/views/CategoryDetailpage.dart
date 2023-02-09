import 'package:adronze/Models/cartmodel.dart';
import 'package:adronze/Models/productmodel.dart';
import 'package:adronze/services/firebaseaddcartservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class categorydetail extends StatefulWidget {
  cartm? cm;
  categorydetail({Key? key,this.cm}) : super(key: key);

  @override
  State<categorydetail> createState() => _categorydetailState();
}

class _categorydetailState extends State<categorydetail> {

  List<productm> products = [
    productm("Panadol", "assets/images/panadol.jpg", "80", "For headache and pain"),
    productm("Disprin", "assets/images/Disprin.jpg", "50", "For headache and pain"),
    productm("Arinac", "assets/images/ARINAC.jpg", "100", "For illness"),
    productm("Afrin", "assets/images/Afrin.jpg", "50", "For headache and pain"),
    productm("Injection", "assets/images/injection.png", "90", "Injection Kit"),
    productm("Drip", "assets/images/Drip.png", "300", "Drip Kit"),
  ];

  cartm? cm;

  @override
  void initState() {

    // saveuser();
    super.initState();
    if(widget.cm != null){
      cm = widget.cm;
    }
  }
  void getproducts()async{
    setState(() {
      loading = true;
    });

    var cartdata = await cartservice().getcart(FirebaseAuth.instance.currentUser!.uid.toString());
    if(cartdata.id != null && cartdata.id!.isNotEmpty){
      setState(() {
        cm = cartdata;
      });
    }
    setState(() {
      loading = false;
    });

  }

  bool loading = false;

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
          title: const Text('Medicine item'),
          backgroundColor:Color(0xff29A9AB), // appbar color.
          foregroundColor: Colors.white),
        // backgroundColor: Colors.cyan[100],
      body:
      SizedBox.expand(

        child:
        loading ?
            Center(child: CircularProgressIndicator(color:Color(0xff29A9AB)),):

        Padding(
          padding: const EdgeInsets.only(top: 40,right: 10,left: 10),
          child: SingleChildScrollView(
            child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //   crossAxisCount: 1,
                //  childAspectRatio: 4.0,
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
                        // print(alreadyexist);
                         break;
                       }
                     }
                     }

                      return
                        categoryItems(item.name.toString(),item.img.toString(),item.price.toString(),
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
      ),
    );
  }
  categoryItems(String title, String image, String price, bool alreadyadded,ontap){
    return InkWell(
      onTap: (){
        ontap();
      },
      child: Card(
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 10),
              child: Image.asset(image,width: 50,height: h*.09, ),
            ),
            Spacer(),
            Text(title,style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),overflow: TextOverflow.ellipsis),
            Spacer(),
            Text("Price ${price} Rs",overflow: TextOverflow.ellipsis,),
            Spacer(),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                primary: Color(0xff29A9AB),
                //onPrimary: Colors.black,
              ),
              onPressed:alreadyadded ?
                  ()async{
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
                ),overflow: TextOverflow.ellipsis,),
            ),
          ],

        ),
      ),
    );

  }
}
