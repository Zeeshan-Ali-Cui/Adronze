import 'dart:async';
import 'package:adronze/Models/cartmodel.dart';
import 'package:adronze/views/proceedOrder.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SimpleMapScreen extends StatefulWidget {
  cartm? cm;
  final double? lat, long;
  SimpleMapScreen({Key? key,this.lat,this.long,this.cm}) : super(key: key);

  @override
  _SimpleMapScreenState createState() => _SimpleMapScreenState();
}


class _SimpleMapScreenState extends State<SimpleMapScreen> {
  Set<Marker> _markers = Set<Marker>();

  bool location_seleected = false;

  void setloactiononMap()async{
    if(widget.lat != null && widget.long != null){
      setState((){
      _markers = Set<Marker>();
      print("added -------->>>>>>>>>>>>");
      _markers.add(Marker(markerId: MarkerId("abc"),position: LatLng( widget.lat!, widget.long!)));


      location_seleected = true;
      });
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(widget.lat!, widget.long!), zoom: 14.0)));
    }

  }


  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition initialPosition = CameraPosition(
      target: LatLng(33.78473647216905, 72.72147686221962), zoom: 14.0);

  static const CameraPosition targetPosition = CameraPosition(
      target: LatLng(37.43296265331129, -122.08832357078792),
      zoom: 14.0,
      bearing: 192.0,
      tilt: 60);


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){

    // Add Your Code here.
    setloactiononMap();

    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Map"),
        centerTitle: true,
      ),
      body: GoogleMap(
        initialCameraPosition: initialPosition,
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: _markers,
        onTap: (latlong){
          setState((){
            _markers = Set<Marker>();
            _markers.add(Marker(markerId: MarkerId(DateTime.now().microsecondsSinceEpoch.toString()),
                position: latlong
            ));
            location_seleected = true;
          });

        },
      ),

      floatingActionButton:
      !location_seleected ? Container(height: 0,width: 0,):
      FloatingActionButton.extended(
        backgroundColor: location_seleected ? Colors.blue[100]:Colors.blue[600],
        onPressed:!location_seleected? (){

        }: () {
          // saveLocation();
          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext contex){return proceedOrder(
            cm: widget.cm,
            lat: _markers.first.position.latitude,long: _markers.first.position.longitude,
          );}));
          // Navigator.of(context).pop();
        },
        label: const Text("Choose"),
        icon: const Icon(Icons.location_on_outlined,),
      ),
    );
  }



  Future<void> saveLocation() async {
    await placemarkFromCoordinates(
        _markers.first.position.latitude, _markers.first.position.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        current_loc =
        '${place.street}, ${place.subLocality},${place.subAdministrativeArea}, ${place.postalCode}';
      });
    // final GoogleMapController controller = await _controller.future;
    // controller.animateCamera(CameraUpdate.newCameraPosition(targetPosition));

  });
}

}




String current_loc = "";
