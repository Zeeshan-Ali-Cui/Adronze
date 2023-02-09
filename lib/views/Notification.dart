import 'package:adronze/Models/notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'orderdetailview.dart';

class notificationsview extends StatefulWidget {
  const notificationsview({Key? key}) : super(key: key);

  @override
  State<notificationsview> createState() => _notificationsviewState();
}

class _notificationsviewState extends State<notificationsview> {
  bool loading = true;
  List<NotificationModel> notifications = [];

  getNotifications() async {
    setState(() {
      loading = true;
    });
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Notifications')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (snapshot.docs.isNotEmpty) {
      notifications = [];
      for (DocumentSnapshot ds in snapshot.docs) {
        notifications
            .add(NotificationModel.fromjson(ds.data() as Map<String, dynamic>));
      }
      notifications.sort((a, b) => a.at!.compareTo(b.at!));
      notifications = notifications.reversed.toList();
    }
    setState(() {
      loading = false;
    });
  }

  listenToOrderStatus() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Map<String, dynamic>? data = message.data;
      if (data['type'] == '1') {
        getNotifications();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getNotifications();
    listenToOrderStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Notification'),
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xff29A9AB), // appbar color.
          foregroundColor: Colors.white),
        // backgroundColor: Colors.cyan[100],
      body: !loading
          ? notifications.isNotEmpty
              ? Container(
                  margin: EdgeInsets.only(top: 15),
                  child: ListView.builder(
                      itemCount: notifications.length,
                      itemBuilder: (c, i) {
                        return notificationItemView(i);
                      }),
                )
              : Center(
                  child: Text("No notifications yet!"),
                )
          : Center(
              child: CircularProgressIndicator( color:Color(0xff29A9AB),),
            ),
    );
  }

  notificationItemView(int i) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: InkWell(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext contex) {
            return orderdetailview(
              order: notifications[i].order,
            );
          }));
        },
        child: Material(
          elevation: 2,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Your order was updated!",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Text(
                        "Order status: " +
                            "${notifications[i].status == 0 ? "In Queue" : notifications[i].status == 1 ? "Dispatched" : notifications[i].status == 3 ? "Cancel" : "Completed"}",
                        style: TextStyle(
                            fontSize: 14,
                            color: notifications[i].status == 0
                                ? Colors.orangeAccent
                                : notifications[i].status == 1
                                    ? Colors.blue
                                    : notifications[i].status == 3
                                        ? Colors.red
                                        : Colors.green),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      DateFormat('dd/mm/yyyy hh:mm a')
                          .format(notifications[i].at!),
                      style: TextStyle(color: Colors.grey, fontSize: 11),
                    )
                  ],
                ),
                Spacer(),
                Icon(Icons.arrow_right_alt_outlined)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
