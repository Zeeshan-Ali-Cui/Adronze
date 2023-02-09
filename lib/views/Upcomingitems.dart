import 'package:flutter/material.dart';
class Upcomingitem extends StatefulWidget {
  const Upcomingitem({Key? key}) : super(key: key);

  @override
  State<Upcomingitem> createState() => _UpcomingitemState();
}

class _UpcomingitemState extends State<Upcomingitem> {
  final titles = ["Blood", "Med Kit", "Tcs Service","Flower", "Medicine", "Courier","Toy Bike", "Emergency Kit", "Services"];
  final subtitles = [
    "Coming Soon",
    "Coming Soon",
    "Coming Soon",
    "Coming Soon",
    "Coming Soon",
    "Coming Soon",
    "Coming Soon",
    "Coming Soon",
    "Coming Soon"

  ];
  final icons = [Icons.favorite_outlined,
    Icons.medical_services_outlined,
    Icons.sensor_occupied_rounded,
    Icons.flare_outlined,
    Icons.medication,
    Icons.card_travel,
    Icons.delivery_dining_rounded,
    Icons.medical_services_outlined,
    Icons.sensor_occupied_rounded];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text(' Upcoming Items list '),
            backgroundColor: Color(0xff29A9AB), // appbar color.
            foregroundColor: Colors.white),
        backgroundColor: Colors.white,
        body: ListView.builder(
            itemCount: titles.length,
            itemBuilder: (context, index) {
              return Card(
                  child: ListTile(
                      title: Text(titles[index]),
                      subtitle: Text(subtitles[index]),
                      leading: Icon(Icons.add_circle_outline,
                        color: Color(0xff29A9AB),),
                      trailing: Icon(icons[index],color: Color(0xff29A9AB),)));
            })
    );
  }
}
