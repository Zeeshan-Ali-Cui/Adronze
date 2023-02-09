import 'package:flutter/material.dart';
import '../main.dart';
class about extends StatefulWidget {
  const about({Key? key}) : super(key: key);

  @override
  State<about> createState() => _aboutState();
}

class _aboutState extends State<about> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(" About App "),
        backgroundColor: Color(0xff29A9AB), // appbar color.
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:[
                    CircleAvatar(
                      backgroundColor: Colors.white70,
                      minRadius: 60.0,
                      child: CircleAvatar(
                        radius: 50.0,
                        backgroundImage:AssetImage("assets/images/dronedelivery.jpg"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(),
          Container(
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text(
                    'Adronze',
                    style: TextStyle(
                      color: Color(0xff29A9AB),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Adronze is first Drone Delivery App That can deliver your package using Autonoumous Drone. '
                    'Today most of the drones are operated manually but'
                    ' the internet connected drone can do long range autonomous missions.'
                        'Hence it can deliver light weight packages for long distances more accurately in remote areas in'
                     ' emergency conditions where the delivery takes more time due to its locations.'
                    ' In emergency conditions means it can be used after earthquakes, floods, or extreme weather events.'
                      'It can deliver medical kits also. It follows GPS co-ordinates which navigates destinations rapidly.'
                    'It is autonomous hence it reduces manpower as well as accidents because it takes air routes.'
                    'It will also reduce the fuel cost. We are using quadcopter (drone) which can be fly '
                    'autonomously with the help of flight controller.'
                    ,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
