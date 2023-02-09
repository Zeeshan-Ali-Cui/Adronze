import 'package:adronze/Models/cartmodel.dart';
import 'package:adronze/services/firebaseaddcartservice.dart';
import 'package:adronze/views/Notification.dart';
import 'package:adronze/views/order.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../services/firebaseuserdataservice.dart';
import 'Availableitem.dart';
import 'Profile.dart';

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);
  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _currentAddress;
  Position? _currentPosition;
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }
  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
        _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
        '${place.street}, ${place.subLocality},${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }



  cartm cm = cartm("", []);
  void getproducts()async{
     var cartdata = await cartservice().getcart(FirebaseAuth.instance.currentUser!.uid.toString());
     if(cartdata.products != null && cartdata.products!.isNotEmpty && cartdata.products != null){
       setState(() {
         cm = cartdata;
       });
     }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    getproducts();
  }

  @override
  void initState() {

    // saveuser();
    super.initState();
    _tabController = TabController(vsync: this, length: 4);
    saveloc();
    // getproducts();
  }

  saveloc(){
    _getCurrentPosition().then((value) => _getAddressFromLatLng(_currentPosition!).then(
            (value) {
              print("long ${_currentPosition!.latitude!}, lat ${_currentPosition!.longitude!}, "
            "current position ${_currentAddress} ");
              userdataservice().savelatlong(FirebaseAuth.instance.currentUser!.uid!, _currentPosition!.latitude!.toString(),_currentPosition!.longitude!.toString() );

            }
    ));
  }

  @override
  Widget build(BuildContext context) {
    return
      AnnotatedRegion
      <SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light
            .copyWith(statusBarColor: Color(0xff29A9AB)),
        child: Scaffold(

        bottomNavigationBar: bottomnav(),
        body: TabBarView(
          controller: _tabController,
          children: [
            Availableitem(cm: cm,lat: _currentPosition == null ? null: _currentPosition!.latitude,long:_currentPosition == null ? null: _currentPosition!.longitude,),
            orderview(),
            notificationsview(),
            profilepage()

          ],
        ),
    ),
      );

  }
  bottomnav(){
    return  Container(
      color: Colors.white,
      child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,

      children: [
      Container(
      height: 60,
      color: Colors.white,
      child: InkWell(
      onTap: ()  {
        setState(() {
          _tabController.index=0;
        });
      },
      child: Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Column(
      children:[
      Icon(
      Icons.home,
      color: Color(0xff29A9AB),
      ),
      Text('Home'),
      ])))),

      Container(
      height: 60,
      color: Colors.white,
      child: InkWell(
      onTap: ()  {
        setState(() {
          _tabController.index=1;
        });
      },
      child: Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Column(
      children: [
      Icon(
      Icons.card_travel,
      color: Color(0xff29A9AB),
      ),
      Text('Order'),
      ])))),

      Container(
      height: 60,
      color: Colors.white,
      child: InkWell(
      onTap: () {
        setState(() {
          _tabController.index=2;
        });
      },
      child: Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Column(
      children: [
      Icon(
      Icons.notifications_active_outlined,
      color: Color(0xff29A9AB),
      ),
      Text('Notification'),
      ])))),

      Container(
      height: 60,
      color: Colors.white,
      child: InkWell(
      onTap: ()  {
        setState(() {
          _tabController.index=3;
        });
      },
      child: Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Column(
      children: <Widget>[
      Icon(
      Icons.person,
      color: Color(0xff29A9AB),
      ),
      Text('Profile'),
      ]))))]),
    );
  }
}
