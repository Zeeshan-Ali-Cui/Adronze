import 'package:adronze/Models/cartmodel.dart';
import 'package:adronze/Models/ordermodel.dart';
import 'package:adronze/services/placeOrderService.dart';
import 'package:adronze/views/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launch/flutter_launch.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:imager/imager.dart';
import 'package:place_picker/entities/location_result.dart';
import 'package:place_picker/widgets/place_picker.dart';

class proceedOrder extends StatefulWidget {
  cartm? cm;
  double? lat, long;

  proceedOrder({Key? key, this.lat, this.long, this.cm}) : super(key: key);

  @override
  State<proceedOrder> createState() => _proceedOrderState();
}
class _proceedOrderState extends State<proceedOrder> {
  var name = TextEditingController();
  var lat = TextEditingController();
  var long = TextEditingController();

  int status = 0;
  String? locationaname = "";


  bool err = false;
  String msgErr = '';

  @override

  Future<void> _getAddressFromLatLng() async {
    if (widget.lat != null && widget.long != null) {
      await placemarkFromCoordinates(widget.lat!, widget.long!)
          .then((List<Placemark> placemarks) {
        Placemark place = placemarks[0];
        setState(() {
          locationaname =
              '${place.street}, ${place.subLocality},${place.subAdministrativeArea}, ${place.postalCode}';
        });
      }).catchError((e) {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAddressFromLatLng();
    getprice();
  }
      void whatsAppOpen() async {
        bool whatsapp = await FlutterLaunch.hasApp(name: "whatsapp");

        if (whatsapp) {
          await FlutterLaunch.launchWhatsapp(
              phone: "03075212326", message: "Hello, Adronze Admin");
        } else {
          setState(() {
            err = false;
            msgErr = '';
          });
        }
      }

  String price = "";
  void getprice(){
    int pric =0;
    widget.cm!.products!.forEach((e)
    { print(e.price.toString()+"-price------------->>>>>>>>>>>>");
      pric += int.parse(e.price!);}
    );

    setState(() {
      price = pric.toString();
    });
  }
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Place Order",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xff29A9AB),
        foregroundColor: Colors.white,

      ),
      // backgroundColor: Colors.cyan[100],
      body: SizedBox.expand(
        child:
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10,left:20,right: 20,bottom: 10),
              child: Container(
                child: TextField(
                    controller: name,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      filled: true, //<-- SEE HERE
                      fillColor: Colors.white,
                      labelText: 'Enter Your Name ',

                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20,bottom: 5,left: 20,right: 20),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: const EdgeInsets.only(left: 20,right:20),
                      child: Text("Please Pay Your Bill, Send Payment"
                          " Screenshot and your Order ID through WhatsApp (Click On WhatsApp Icon ) "),
                    ),
                  ),
                  InkWell(
                    child: Container(
                      padding: EdgeInsets.only(left: 20,right: 300),
                        child: Imager.fromLocal("assets/images/whatsapp.png",height: 30.h,width: 40.w)
                    ),
                    onTap: (){
                      whatsAppOpen();
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Container(
                      child: Text("Total Price : "+ price),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 100),
                    child: InkWell(
                      child: Container(
                          padding: const EdgeInsets.only(right: 41.5,top: 15,bottom: 15,left: 41.5),
                          decoration: BoxDecoration(
                            color: const Color(0xff29A9AB),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        child: Text("Pay Bill",style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600,
                            color: Color(0xffFFFFFF)),
                        textAlign: TextAlign.center,)
                      ),
                      onTap: (){
                        showAlertDialog(context);
                      },
                    ),
                  ),

                ],
              ),
            ),

            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Color(0xff29A9AB))),
              padding: const EdgeInsets.all(16.0),
              child: Text(
                 locationaname != "" && locationaname!.isNotEmpty
                        ? locationaname.toString()
                        : ' Your Current Location',
                style: TextStyle(fontSize: 18),
                  ),
            ),
            SizedBox(height: 30,),
            InkWell(
              onTap: () async {
                LocationResult? result = await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => PlacePicker("AIzaSyD7hq4y3PKjUpmNh81yNyh-v2y9Ty4yBJk")));
                print(result!.formattedAddress!.toString());
                widget.lat= result.latLng!.latitude;
                widget.long=result.latLng!.longitude;
               _getAddressFromLatLng();
              },
              child:
              Container(
                  decoration: BoxDecoration(
                    color: Color(0xff29A9AB),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "Change Location",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  )),
            ),
            Spacer(),
            InkWell(
              onTap:loading ?(){}: () async {

               if(name.text.isEmpty ){
                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please Enter Your Name")));
                 return ;
               }
                setState(() {
                  loading = true;
                });
                try {
                  String uid = FirebaseAuth.instance.currentUser!.uid;
                  orderm order = orderm(
                      DateTime
                          .now()
                          .microsecondsSinceEpoch
                          .toString(),
                      name.text,
                      widget.lat.toString(),
                      widget.long.toString(),
                      0,
                      locationaname,
                      widget.cm!.products!,0);
                  bool check = await placeOrderService().placeorder(uid, order);
                  if (check) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                        SnackBar(content: Text("Order Placed Sucessfully")));
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (BuildContext contex) {
                      return home();
                    }));
                  } else {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text("Order Failed retry")));
                  }
                }catch(e){

                }
                setState(() {
                  loading = true;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                    decoration: BoxDecoration(
                      color:Color(0xff29A9AB),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 25,left: 25,top: 20,bottom: 20),
                      child: loading? CircularProgressIndicator(color: Color(0xff29A9AB),):Text(
                        "Place Order",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
showAlertDialog(BuildContext context) {
  // Create button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16.0))),
    title: Text("Payment Method"),
    // content: Text("Jazzcash   03075212326 "),
    actions: [
      Padding(
        padding: const EdgeInsets.only(left: 10,right: 150,bottom: 20),
        child: Container(
          child: Text("Jazzcash 03075212326",style: TextStyle(fontWeight: FontWeight.w700),),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left:10,right: 150,bottom: 20),
        child: Container(
          child: Text("Easypaisa 03075212326",style: TextStyle(fontWeight: FontWeight.w700),),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 10,right: 75,bottom: 20),
        child: Container(
          child: Text("Meezan Bank PK07MEZN0053010107333716",style: TextStyle(fontWeight: FontWeight.w700),),
        ),
      ),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: Color(0xff29A9AB),
        ),
        child:  okButton,
      )

    ],
  );

  // show the dialog
  showDialog(
      context: context,
      builder: (BuildContext context) {
    return alert;
  }
  );
}
