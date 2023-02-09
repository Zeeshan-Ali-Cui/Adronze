import 'package:adronze/Models/ordermodel.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
class orderdetailview extends StatefulWidget {
  orderm? order;
  orderdetailview({Key? key,this.order}) : super(key: key);

  @override
  State<orderdetailview> createState() => _orderdetailviewState();
}

class _orderdetailviewState extends State<orderdetailview> {

  bool loading_loc = true;
  String order_Loc = "";
  Future<void> saveLocation() async {
    await placemarkFromCoordinates(
        double.parse(widget.order!.lat.toString()), double.parse(widget.order!.long.toString()))
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        order_Loc =
        '${place.street}, ${place.subLocality},${place.subAdministrativeArea}, ${place.postalCode}';
        loading_loc = false;
      });
      // final GoogleMapController controller = await _controller.future;
      // controller.animateCamera(CameraUpdate.newCameraPosition(targetPosition));

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    saveLocation();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("Order Detail"),
      backgroundColor: Color(0xff29A9AB),
        foregroundColor: Colors.white,
      ),
      // backgroundColor: Colors.white,
      body: SizedBox.expand(
        child: Container(
          padding: EdgeInsets.only(left: 20,right: 20,top: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              showInfo("Person Name",widget.order!.name.toString()),
              Divider(),
              showInfo("Location",'${loading_loc ? "Loading...:":order_Loc}'),

              Divider(),
              showInfo("Order status: ",  "${widget.order!.status == 0 ? "in queue" : widget.order!.status == 1 ? "Dispatched" : "Completed"}"),

              SizedBox(height: 20,),
              Center(child: Text("Products List",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),textAlign: TextAlign.center,)),
              SizedBox(height: 10,),

              Expanded(
                child: ListView.builder(
                    itemCount: widget.order!.products!.length ,
                    itemBuilder: (c,i){
                      var item = widget.order!.products![i];
                      return
                        Card(
                            child: ListTile(title: Text(item!.name.toString()),
                            )
                        );
                }),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget showInfo(String heading,String val){
    return Container(
      alignment:Alignment.centerLeft,
      decoration: BoxDecoration(border: Border.all(color: Colors.cyan)),
      padding: const EdgeInsets.only(left: 10,top: 10,bottom: 10),
      child: Row(
        children: [
            Expanded(flex:2,child: Text(heading,style: TextStyle(fontSize: 13,fontWeight: FontWeight.w700),)),
            Expanded(flex: 5,
              child: Container(alignment:Alignment.centerLeft,child: Text(val,style: TextStyle(fontSize: 12),)),

            )
        ],
      ),
    );
  }
}
