import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lmao/bindetails.dart';
import 'package:lmao/sensor.dart';
import 'package:http/http.dart' as http;

String id = "";

class MonitorScreen extends StatefulWidget {
  const MonitorScreen({Key? key}) : super(key: key);

  @override
  State<MonitorScreen> createState() => _MonitorScreenState();
}

class _MonitorScreenState extends State<MonitorScreen> {
  List<double> depth = [];
  bool cond = true;
  int l = 0;
  Timer? timer;
  List<bool> flag = [];
  double val = 1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    for (int i = 0; i < 1000; i++) {
      depth.add(0);
      flag.add(false);
    }
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");
      if (l == 0) {
        l = 1;
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Alert"),
                content: Text("High Garbage Value"),
                actions: [
                  ElevatedButton(
                    onPressed: () async {
                      l = 0;
                      cond = true;
                      FirebaseMessaging.instance.subscribeToTopic("monitor");
                      Navigator.pop(context);
                    },
                    child: Text("Exit"),
                  )
                ],
              );
            });
        FirebaseFirestore.instance.collection('log').add({
          'message': "Dustbin with id $id Full",
          'time': Timestamp.now(),
        });
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer!.cancel();
    super.dispose();
  }

  Future<void> sendNotif(String id) async {
    Uri url = Uri.parse("https://fcm.googleapis.com/fcm/send");
    String? token = await FirebaseMessaging.instance.getToken();
    Map<String, dynamic> m = {
      "to": "/topics/monitor",
      "notification": {
        "body": "High Garbage Value in Dustbin with ID: " + id,
        "title": "Alert",
      },
      "mutable_content": true,
      "sound": "Tri-tone"
    };
    var resp = await http.post(url, body: jsonEncode(m), headers: {
      "Authorization":
          "key=AAAARvDs0Lg:APA91bHlFLLkNn8Qjl847nD86YsIYUxlnAYGaAUH_mCuiJZz-puOMQJEXbjtAxuAfQQjj4CGDXg5Bonqeo8x5saE8QGgTrmtBeAkr1EJUoy2feqxWl9JEcsGkXWfCTZOWqWc30goXml1",
      "Content-Type": "application/json"
    });
    await FirebaseMessaging.instance.unsubscribeFromTopic('monitor');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Monitor Screen"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('dustbin').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, i) {
                timer = Timer.periodic(Duration(seconds: 5), (timer) {
                  if (!flag[i]) depth[i] = (Random().nextDouble() * 100);
                  if (depth[i] > ultrasonic && !flag[i]) {
                    if (cond) {
                      id = snapshot.data!.docs[i]['id'].toInt().toString();
                      sendNotif(
                          snapshot.data!.docs[i]['id'].toInt().toString());
                      cond = false;
                    }
                    flag[i] = true;
                  }
                  if (mounted) {
                    setState(() {});
                  }
                });
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return Detail(garbage: depth[i]);
                          },
                        ),
                      );
                    },
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: (depth[i] > ultrasonic) || flag[i]
                            ? Colors.red
                            : Colors.green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          snapshot.data!.docs[i]['id'].toInt().toString(),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
