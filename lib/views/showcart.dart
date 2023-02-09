import 'package:adronze/Models/cartmodel.dart';
import 'package:adronze/services/firebaseaddcartservice.dart';
import 'package:adronze/views/home.dart';
import 'package:adronze/views/proceedOrder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:place_picker/entities/location_result.dart';
import 'package:place_picker/widgets/place_picker.dart';

class showcart extends StatefulWidget {
  final double? lat,long;

   showcart({Key? key,this.lat,this.long}) : super(key: key);

  @override
  State<showcart> createState() => _showcartState();
}

class _showcartState extends State<showcart> {



  cartm? cm = cartm("", []);

  @override
  void initState() {

    // saveuser();
    super.initState();
    getproducts();
  }
  void getproducts()async{
    var cartdata = await cartservice().getcart(FirebaseAuth.instance.currentUser!.uid.toString());
    if(cartdata.products != null && cartdata.products!.isNotEmpty && cartdata.products != []){
      setState(() {
        cm = cartdata;
      });
    }
    setState(() {
      loading = false;
    });
  }

  bool loading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cart",
        style: TextStyle(color: Colors.white),

      ),
        leading: InkWell(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context){return home();}));
            },
            child: Icon(Icons.arrow_back_outlined)),
        backgroundColor: Color(0xff29A9AB),
        foregroundColor: Colors.white,

      ),
        // backgroundColor: Colors.cyan[100],
      body: WillPopScope(
        onWillPop: ()async{
          Navigator.of(context).push(MaterialPageRoute(builder: (context){return home();}));
          return true;
        },
        child: SizedBox.expand(child:
          loading ? Center(child: CircularProgressIndicator(color: Color(0xff29A9AB),),):
          cm!.products!.length == 0
          ? Center(child: Text("Add items to cart to get started"),):
          ListView.builder(
                  itemCount: cm!.products!.length ,
                  itemBuilder: (c,i){
                    var item = cm!.products![i];
                    return
                    Card(
                      child: ListTile(title: Text(item!.name.toString()),
                      trailing: InkWell(child: Icon(Icons.remove_circle_outline_sharp, color: Color(0xff29A9AB),),
                        onTap: ()async{
                          bool check = await cartservice().detletefromcart(FirebaseAuth.instance.currentUser!.uid, item.name.toString());
                          if(check) {
                            for(int i=0; i< cm!.products!.length;i++) {
                              if(cm!.products![i].name == item.name){
                                setState(() {
                                  cm!.products!.removeAt(i);
                                });
                              }
                            }
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Product Remove")));
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Product Removing Failed")));
                          }
                        },
                      ),
                      )
                    );
                  }),
          ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
      cm!.products!.length == 0
          ? SizedBox(width: 0,height: 0,):
      InkWell(
        onTap: ()async{
          LocationResult? result = await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => PlacePicker("AIzaSyD7hq4y3PKjUpmNh81yNyh-v2y9Ty4yBJk")));

          // Handle the result in your way
          print(result!.formattedAddress!.toString());
          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext contex){return proceedOrder(
            cm: cm,
            lat: result.latLng!.latitude,long: result.latLng!.longitude,
          );}));
        },
        child: Container(
            decoration: BoxDecoration(
              color: Color(0xff29A9AB),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child:
        Padding(
          padding: const EdgeInsets.only(top: 10,left: 50,right: 50,bottom: 10),
          child: Text("Proceed",style: TextStyle(color: Colors.white,fontSize: 18),),
        )),
      ),
    );
  }
}
