import 'package:adronze/Models/cartmodel.dart';
import 'package:adronze/services/firebaseaddcartservice.dart';
import 'package:adronze/services/firebaseuserdataservice.dart';
import 'package:adronze/views/Bookview.dart';
import 'package:adronze/views/CategoryDetailpage.dart';
import 'package:adronze/views/Fuel.dart';
import 'package:adronze/views/Upcomingitems.dart';
import 'package:adronze/views/grocery.dart';
import 'package:adronze/views/showcart.dart';
import 'package:adronze/views/sports.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:imager/imager.dart';

class Availableitem extends StatefulWidget {
  cartm? cm;
  final double? lat, long;

  Availableitem({Key? key, this.cm, this.lat, this.long}) : super(key: key);

  @override
  State<Availableitem> createState() => _AvailableitemState();
}

class _AvailableitemState extends State<Availableitem> {
  late double w, h;
  late double itemW, itemH;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userdataservice().savetoken(FirebaseAuth.instance.currentUser!.uid);
  }

  bool loading = false;
  bool loading_error = false;

  void getproducts() async {
    setState(() {
      loading = true;
    });
    try {
      var cartdata = await cartservice()
          .getcart(FirebaseAuth.instance.currentUser!.uid.toString());
      if (cartdata.products != null &&
          cartdata.products!.isNotEmpty &&
          cartdata.products != null) {
        setState(() {
          widget.cm = cartdata;
        });
      }
    } catch (e) {
      setState(() {
        loading_error = true;
      });
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    itemW = w * 0.45;
    itemH = h * 0.1;

    return  AnnotatedRegion
    <SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light
          .copyWith(statusBarColor: Color(0xff29A9AB)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Home",
            style: TextStyle(fontStyle: FontStyle.italic),
          ),

          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (c) {
                    return showcart(
                      lat: widget.lat,
                      long: widget.long,
                    );
                  }));
                }),
          ],

          backgroundColor: const Color(0xff29A9AB),
          // appbar color.
          foregroundColor: Colors.white,
        ),
        // backgroundColor: Colors.cyan[100],

        body:
        SizedBox.expand(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: loading_error
                ? Center(
                    child: InkWell(
                        onTap: () {
                          getproducts();
                        },
                        child: Text("error Loading Data...\n Refresh")),
                  )
                : loading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Colors.blueGrey,
                        ),
                      )
                    : SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 10,left: 10),
                            child: Text("Welcome Back!"),
                          ),
                          Container(
                            color: Colors.white,
                            margin: const EdgeInsets.symmetric(vertical: 10.0),
                            height: 187.h,
                            padding: EdgeInsets.only(left: 10,right: 10),
                            child: ListView(
                              // This next line does the trick.
                              scrollDirection: Axis.horizontal,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(right: 10),
                                  color: Colors.white,
                                  child: Imager.fromLocal("assets/images/Droneimg.jpg",height: 120.h,width: 387.w),
                                ),

                                Container(
                                  padding: EdgeInsets.only(right: 10),
                                  color: Colors.white,
                                  child: Imager.fromLocal("assets/images/dronegif2.gif",height: 120.h,width: 387.w),
                                ),
                                Container(
                                  padding: EdgeInsets.only(right: 10),
                                  color: Colors.white,
                                  child: Imager.fromLocal("assets/images/dronedelivery.jpg",height: 120.h,width: 387.w),
                                ),
                              ],
                            ),
                          ),
                          Divider(),

                          Padding(
                            padding: const EdgeInsets.only(left: 20,right: 20),
                            child: Container(
                              padding: EdgeInsets.only(left:20,right: 210,top: 5,bottom: 5),
                              child: Text("Services",style: TextStyle(fontSize: 24.sp,fontWeight: FontWeight.w700),),
                            ),
                          ),
                          Divider(),
                          Container(
                            child: GridView(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 1.2,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                ),
                                children: [
                                    categoryItems(
                                        "Medicine", "assets/images/medicine.png", () {

                                            return
                                          showModalBottomSheet(
                                              context: context,
                                            builder: (context) {
                                              return categorydetail(
                                              cm: widget.cm,
                                        );
                                            },
                                          );
                                      }),
                                    categoryItems(
                                        "Groceries", "assets/images/Groceries.png", () {
                                      return
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return groceryitem(
                                              cm: widget.cm,
                                            );
                                          },
                                        );
                                    }),
                                    categoryItems("Books", "assets/images/Books.png", () {
                                      return
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return bookview(
                                              cm: widget.cm,
                                            );
                                          },
                                        );
                                    }),
                                    categoryItems("Fuel", "assets/images/fuel.png", () {
                                      return
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return fuelview(
                                              cm: widget.cm,
                                            );
                                          },
                                        );
                                    }),
                                    categoryItems(
                                        "Sports items", "assets/images/Sports.png", () {
                                      return
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return sportsview(
                                              cm: widget.cm,
                                            );
                                          },
                                        );
                                    }),
                                    categoryItems(
                                        "Upcomings", "assets/images/upcoming.png", () {
                                      return
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return Upcomingitem(
                                            );
                                          },
                                        );
                                    }),
                                  ]),
                          ),
                        ],
                      ),
                    ),
          ),
        ),
      ),
    );
  }

  categoryItems(String title, String image, Function ontap) {
    return InkWell(
      onTap: () {
        ontap();
      },
      child: SizedBox(
        width: itemW,
        height: itemH,
        child: Card(

          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  image,
                  width: 50,
                  height: h * .09,
                ),
              ),
              Spacer(),
              Text(
                title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
              ),
              Spacer()
            ],
          ),
        ),
      ),
    );
  }
}
